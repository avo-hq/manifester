
class Manifester::Manifest
  class MissingEntryError < StandardError; end

  delegate :config, to: :@manifester

  def initialize(manifester)
    @manifester = manifester
  end

  def refresh
    @data = load
  end

  def lookup_manifest_with_chunks(name, pack_type = {})
    manifest_pack_type = manifest_type(pack_type[:type])
    manifest_pack_name = manifest_name(name, manifest_pack_type)
    find("entrypoints")[manifest_pack_name]["assets"][manifest_pack_type]
  rescue NoMethodError
    nil
  end

  def lookup_manifest_with_chunks!(name, pack_type = {})
    lookup_manifest_with_chunks(name, pack_type) || handle_missing_entry(name, pack_type)
  end

  # Computes the relative path for a given Manifester asset using manifest.json.
  # If no asset is found, returns nil.
  #
  # Example:
  #
  #   Manifester.manifest.lookup('calendar.js') # => "/packs/calendar-1016838bab065ae1e122.js"
  def lookup(name, pack_type = {})
    find(full_pack_name(name, pack_type[:type]))
  end

  # Like lookup, except that if no asset is found, raises a Manifester::Manifest::MissingEntryError.
  def lookup!(name, pack_type = {})
    lookup(name, pack_type) || handle_missing_entry(name, pack_type)
  end

  private
    def data
      if config.cache_manifest?
        @data ||= load
      else
        refresh
      end
    end

    def find(name)
      data[name.to_s].presence
    end

    def full_pack_name(name, pack_type)
      return name unless File.extname(name.to_s).empty?
      "#{name}.#{manifest_type(pack_type)}"
    end

    def handle_missing_entry(name, pack_type)
      raise Manifester::Manifest::MissingEntryError, missing_file_from_manifest_error(full_pack_name(name, pack_type[:type]))
    end

    def load
      if config.public_manifest_path.exist?
        JSON.parse config.public_manifest_path.read
      else
        {}
      end
    end

    # The `manifest_name` method strips of the file extension of the name, because in the
    # manifest hash the entrypoints are defined by their pack name without the extension.
    # When the user provides a name with a file extension, we want to try to strip it off.
    def manifest_name(name, pack_type)
      return name if File.extname(name.to_s).empty?
      File.basename(name, ".#{pack_type}")
    end

    def manifest_type(pack_type)
      case pack_type
      when :javascript then "js"
      when :stylesheet then "css"
      else pack_type.to_s
      end
    end

    def missing_file_from_manifest_error(bundle_name)
      <<-MSG
Manifester can't find #{bundle_name} in #{config.public_manifest_path}.
Your manifest contains:
#{JSON.pretty_generate(@data)}
      MSG
    end
end
