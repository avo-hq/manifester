class Manifester::Instance
  cattr_accessor(:logger) { ActiveSupport::TaggedLogging.new(ActiveSupport::Logger.new(STDOUT)) }

  attr_reader :root_path

  def initialize(root_path: Rails.root, public_root_dir: "public", public_output_dir: "packs", cache_manifest: false, fallback_to_webpacker: -> {})
    @root_path, @public_root_dir, @public_output_dir, @cache_manifest, @fallback_to_webpacker = root_path, public_root_dir, public_output_dir, cache_manifest, fallback_to_webpacker
  end

  def config
    @config ||= Manifester::Configuration.new(
      root_path: @root_path,
      public_root_dir: @public_root_dir,
      public_output_dir: @public_output_dir,
      cache_manifest: @cache_manifest,
      fallback_to_webpacker: @fallback_to_webpacker
    )
  end

  def manifest
    @manifest ||= Manifester::Manifest.new self
  end
end
