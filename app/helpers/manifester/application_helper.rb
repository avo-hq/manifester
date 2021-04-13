module Manifester
  module ApplicationHelper
    def current_manifester_instance
      Manifester.instance
    end

    # Computes the relative path for a given Manifester asset.
    # Returns the relative path using manifest.json and passes it to path_to_asset helper.
    # This will use path_to_asset internally, so most of their behaviors will be the same.
    #
    # Example:
    #
    #   <%= asset_manifest_path 'calendar.css' %> # => "/packs/calendar-1016838bab065ae1e122.css"
    def asset_manifest_path(name, **options)
      path_to_asset(current_manifester_instance.manifest.lookup!(name), options)
    end

    # Computes the absolute path for a given Manifester asset.
    # Returns the absolute path using manifest.json and passes it to url_to_asset helper.
    # This will use url_to_asset internally, so most of their behaviors will be the same.
    #
    # Example:
    #
    #   <%= asset_manifest_url 'calendar.css' %> # => "http://example.com/packs/calendar-1016838bab065ae1e122.css"
    def asset_manifest_url(name, **options)
      url_to_asset(current_manifester_instance.manifest.lookup!(name), options)
    end

    # Computes the relative path for a given Manifester image with the same automated processing as image_manifest_tag.
    # Returns the relative path using manifest.json and passes it to path_to_asset helper.
    # This will use path_to_asset internally, so most of their behaviors will be the same.
    def image_manifest_path(name, **options)
      resolve_path_to_image(name, **options)
    end

    # Computes the absolute path for a given Manifester image with the same automated
    # processing as image_manifest_tag. Returns the relative path using manifest.json
    # and passes it to path_to_asset helper. This will use path_to_asset internally,
    # so most of their behaviors will be the same.
    def image_manifest_url(name, **options)
      resolve_path_to_image(name, **options.merge(protocol: :request))
    end

    # Creates an image tag that references the named pack file.
    #
    # Example:
    #
    #  <%= image_manifest_tag 'application.png', size: '16x10', alt: 'Edit Entry' %>
    #  <img alt='Edit Entry' src='/packs/application-k344a6d59eef8632c9d1.png' width='16' height='10' />
    #
    #  <%= image_manifest_tag 'picture.png', srcset: { 'picture-2x.png' => '2x' } %>
    #  <img srcset= "/packs/picture-2x-7cca48e6cae66ec07b8e.png 2x" src="/packs/picture-c38deda30895059837cf.png" >
    def image_manifest_tag(name, **options)
      if options[:srcset] && !options[:srcset].is_a?(String)
        options[:srcset] = options[:srcset].map do |src_name, size|
          "#{resolve_path_to_image(src_name)} #{size}"
        end.join(", ")
      end

      image_tag(resolve_path_to_image(name), options)
    end

    # Creates a link tag for a favicon that references the named pack file.
    #
    # Example:
    #
    #  <%= favicon_manifest_tag 'mb-icon.png', rel: 'apple-touch-icon', type: 'image/png' %>
    #  <link href="/packs/mb-icon-k344a6d59eef8632c9d1.png" rel="apple-touch-icon" type="image/png" />
    def favicon_manifest_tag(name, **options)
      favicon_link_tag(resolve_path_to_image(name), options)
    end

    # Creates script tags that reference the js chunks from entrypoints when using split chunks API,
    # as compiled by webpack per the entries list in package/environments/base.js.
    # By default, this list is auto-generated to match everything in
    # app/packs/entrypoints/*.js and all the dependent chunks. In production mode, the digested reference is automatically looked up.
    # See: https://webpack.js.org/plugins/split-chunks-plugin/
    #
    # Example:
    #
    #   <%= javascript_manifest_tag 'calendar', 'map', 'data-turbolinks-track': 'reload' %> # =>
    #   <script src="/packs/vendor-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
    #   <script src="/packs/calendar~runtime-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
    #   <script src="/packs/calendar-1016838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
    #   <script src="/packs/map~runtime-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
    #   <script src="/packs/map-16838bab065ae1e314.chunk.js" data-turbolinks-track="reload"></script>
    #
    # DO:
    #
    #   <%= javascript_manifest_tag 'calendar', 'map' %>
    #
    # DON'T:
    #
    #   <%= javascript_manifest_tag 'calendar' %>
    #   <%= javascript_manifest_tag 'map' %>
    def javascript_manifest_tag(*names, **options)
      javascript_include_tag(*sources_from_manifest_entrypoints(names, type: :javascript), **options)
    end

    # Creates a link tag, for preloading, that references a given Manifester asset.
    # In production mode, the digested reference is automatically looked up.
    # See: https://developer.mozilla.org/en-US/docs/Web/HTML/Preloading_content
    #
    # Example:
    #
    #   <%= preload_manifest_asset 'fonts/fa-regular-400.woff2' %> # =>
    #   <link rel="preload" href="/packs/fonts/fa-regular-400-944fb546bd7018b07190a32244f67dc9.woff2" as="font" type="font/woff2" crossorigin="anonymous">
    def preload_manifest_asset(name, **options)
      if self.class.method_defined?(:preload_link_tag)
        preload_link_tag(current_manifester_instance.manifest.lookup!(name), options)
      else
        raise "You need Rails >= 5.2 to use this tag."
      end
    end

    # Creates link tags that reference the css chunks from entrypoints when using split chunks API,
    # as compiled by webpack per the entries list in package/environments/base.js.
    # By default, this list is auto-generated to match everything in
    # app/packs/entrypoints/*.js and all the dependent chunks. In production mode, the digested reference is automatically looked up.
    # See: https://webpack.js.org/plugins/split-chunks-plugin/
    #
    # Examples:
    #
    #   <%= stylesheet_manifest_tag 'calendar', 'map' %> # =>
    #   <link rel="stylesheet" media="screen" href="/packs/3-8c7ce31a.chunk.css" />
    #   <link rel="stylesheet" media="screen" href="/packs/calendar-8c7ce31a.chunk.css" />
    #   <link rel="stylesheet" media="screen" href="/packs/map-8c7ce31a.chunk.css" />
    #
    # DO:
    #
    #   <%= stylesheet_manifest_tag 'calendar', 'map' %>
    #
    # DON'T:
    #
    #   <%= stylesheet_manifest_tag 'calendar' %>
    #   <%= stylesheet_manifest_tag 'map' %>
    def stylesheet_manifest_tag(*names, **options)
      stylesheet_link_tag(*sources_from_manifest_entrypoints(names, type: :stylesheet), **options)
    end

    private

      def sources_from_manifest_entrypoints(names, type:)
        names.map { |name| current_manifester_instance.manifest.lookup_manifest_with_chunks!(name.to_s, type: type) }.flatten.uniq
      end

      def resolve_path_to_image(name, **options)
        path = name.starts_with?("media/images/") ? name : "media/images/#{name}"
        path_to_asset(current_manifester_instance.manifest.lookup!(path), options)
      rescue
        path_to_asset(current_manifester_instance.manifest.lookup!(name), options)
      end
  end
end
