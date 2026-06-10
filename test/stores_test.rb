require "test_helper"

class StoresTest < LumenLLMTest
  class FakeRedis
    attr_reader :setex_calls

    def initialize
      @values = {}
      @setex_calls = []
    end

    def get(key)
      value = @values[key]
      value.nil? ? nil : value.to_s
    end

    def setex(key, ttl, value)
      @setex_calls << [key, ttl, value]
      @values[key] = value
    end

    def incrby(key, amount)
      @values[key] = get(key).to_i + amount.to_i
    end

    def keys(pattern)
      prefix = pattern.sub(/\*$/, "")
      @values.keys.select { |key| key.index(prefix) == 0 }
    end
  end

  def test_null_store_never_caches
    store = LumenLLM::Stores::NullStore.new
    count = 0

    first = store.cache("key") { count += 1 }
    second = store.cache("key") { count += 1 }

    assert_equal 1, first
    assert_equal 2, second
    assert_equal 0, store.stat("anything")
    assert_equal({}, store.all_stats)
  end

  def test_memory_store_caches_and_tracks_stats
    store = LumenLLM::Stores::MemoryStore.new
    count = 0

    assert_equal({ "ok" => true }, store.cache("key") { count += 1; { "ok" => true } })
    assert_equal({ "ok" => true }, store.cache("key") { count += 1; { "ok" => false } })
    assert_equal 1, count

    store.incr_stat("calls", 2)
    assert_equal 2, store.stat("calls")
    assert_equal({ "stats:calls" => 2 }, store.all_stats("stats:c*"))
  end

  def test_redis_store_uses_existing_client_for_cache_and_stats
    redis = FakeRedis.new
    store = LumenLLM::Stores::RedisStore.new(redis)
    count = 0

    first = store.cache("cache:key", :ttl => 45) { count += 1; { "value" => 1 } }
    second = store.cache("cache:key", :ttl => 45) { count += 1; { "value" => 2 } }

    assert_equal({ "value" => 1 }, first)
    assert_equal({ "value" => 1 }, second)
    assert_equal 1, count
    assert_equal ["cache:key", 45, "{\"value\":1}"], redis.setex_calls.first

    store.incr_stat("prompt_tokens:translator", 5)
    assert_equal 5, store.stat("prompt_tokens:translator")
    assert_equal({ "stats:prompt_tokens:translator" => 5 }, store.all_stats("stats:prompt*"))
  end
end
