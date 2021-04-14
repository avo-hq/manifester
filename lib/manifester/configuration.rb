class Manifester::Configuration
  attr_reader :root_path
  attr_reader :public_root_dir
  attr_reader :public_output_dir
  attr_reader :cache_manifest
  attr_reader :fallback_to_webpacker

  def initialize(root_path:, public_root_dir:, public_output_dir:, cache_manifest:, fallback_to_webpacker:)
    @root_path = root_path
    @public_root_dir = public_root_dir
    @public_output_dir = public_output_dir
    @cache_manifest = cache_manifest
    @fallback_to_webpacker = fallback_to_webpacker
  end

  def public_path
    root_path.join(@public_root_dir)
  end

  def public_output_path
    public_path.join(@public_output_dir)
  end

  def public_manifest_path
    public_output_path.join("manifest.json")
  end

  def cache_manifest?
    @cache_manifest
  end

  def fallback_to_webpacker?
    fallback_to_webpacker.call
  end
end
