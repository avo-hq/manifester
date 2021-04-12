require "yaml"
require "active_support/core_ext/hash/keys"
require "active_support/core_ext/hash/indifferent_access"

class Manifester::Configuration
  attr_reader :root_path, :config_path, :env

  def initialize(root_path:, config_path:, env:)
    @root_path = root_path
    @config_path = config_path
    @env = env
  end

  def public_path
    root_path.join(fetch(:public_root_path))
  end

  def public_output_path
    public_path.join(fetch(:public_output_path))
  end

  def public_manifest_path
    public_output_path.join("manifest.json")
  end

  def cache_manifest?
    fetch(:cache_manifest)
  end

  private
    def fetch(key)
      data.fetch(key, defaults[key])
    end

    def data
      @data ||= load
    end

    def load
      YAML.load(config_path.read)[env].deep_symbolize_keys

    rescue Errno::ENOENT => e
      raise "Manifester configuration file not found #{config_path}. " \
            "Please run rails manifester:install " \
            "Error: #{e.message}"

    rescue Psych::SyntaxError => e
      raise "YAML syntax error occurred while parsing #{config_path}. " \
            "Please note that YAML must be consistently indented using spaces. Tabs are not allowed. " \
            "Error: #{e.message}"
    end

    def defaults
      @defaults ||= \
        HashWithIndifferentAccess.new(YAML.load_file(File.expand_path("../../install/config/manifester.yml", __FILE__))[env])
    end
end
