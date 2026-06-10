$LOAD_PATH.unshift File.expand_path("../lib", __dir__)

require "fileutils"
require "json"
require "minitest/autorun"
require "tmpdir"

require "lumen_llm"

class LumenLLMTest < Minitest::Test
  def setup
    LumenLLM.reset_configuration!
  end

  def teardown
    LumenLLM.reset_configuration!
  end

  def with_env(values)
    old_values = {}
    values.each do |key, value|
      old_values[key] = ENV.key?(key) ? ENV[key] : :__missing__
      value.nil? ? ENV.delete(key) : ENV[key] = value
    end

    yield
  ensure
    values.each_key do |key|
      if old_values[key] == :__missing__
        ENV.delete(key)
      else
        ENV[key] = old_values[key]
      end
    end
  end

  def write_file(path, content)
    FileUtils.mkdir_p(File.dirname(path))
    File.open(path, "w") { |file| file.write(content) }
  end
end
