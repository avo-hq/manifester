module Manifester
  module ApplicationHelper
    def current_manifester_instance
      Manifester.instance
    end

    def javascript_manifest_tag(*names, **options)
      javascript_include_tag(*sources_from_manifest_entrypoints(names, type: :javascript), **options)
    end

    def stylesheet_manifest_tag(*names, **options)
      stylesheet_link_tag(*sources_from_manifest_entrypoints(names, type: :stylesheet), **options)
    end

    def stylesheet_pack_tag(*names, **options)
    end

    private

      def sources_from_manifest_entrypoints(names, type:)
        names.map { |name| current_manifester_instance.manifest.lookup_pack_with_chunks!(name.to_s, type: type) }.flatten.uniq
      end
  end
end
