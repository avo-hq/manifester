class Manifester::Instance
  cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

  attr_reader :root_path, :config_path

  def initialize(root_path: Rails.root, config_path: Rails.root.join("config/manifester.yml"))
    @root_path, @config_path = root_path, config_path
  end

  def env
    @env ||= Manifester::Env.inquire self
  end

  def config
    @config ||= Manifester::Configuration.new(
      root_path: root_path,
      config_path: config_path,
      env: env
    )
  end

  def manifest
    @manifest ||= Manifester::Manifest.new self
  end
end
