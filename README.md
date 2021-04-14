# Manifester
Manifester was born from the need to ship webpacker generated assets without webpacker for our Rails engines.

When we first shipped [Avo](https://github.com/avo-hq/avo) we shipped it with the whole Webpacker pipeline. That meant rebuilding the assets on every deploy of the parent app and other nasty unwanted behaviors (conflicting pipelines, etc.).

We just needed something that would take the packed files and add it to the layout.

Most of the code has been extracted from [webpacker](https://github.com/rails/webpacker/).

**Important**: I assume you have followed [this](https://github.com/rails/webpacker/blob/5-x-stable/docs/engines.md) guide to add webpacker to your engine.

## Installation
Add this line to your application's Gemfile:

```ruby
gem 'manifester'
```

And then execute:
```bash
$ bundle
```

```ruby
  # your engine's gemspec
  spec.add_dependency "manifester"
```

Instantiate the plugin in your main file using a few config values. Also have the webpacker instance side by side for development.

```ruby
# lib/your_engine.rb

module YourEngine
  ROOT_PATH = Pathname.new(File.join(__dir__, ".."))
  IN_DEVELOPMENT = ENV["ENGINE_IN_DEVELOPMENT"] == "1"

  class << self
    # have a webpacker instance for your development env
    def webpacker
      @webpacker ||= ::Webpacker::Instance.new(
        root_path: ROOT_PATH,
        config_path: ROOT_PATH.join("config/webpacker.yml")
      )
    end

    def manifester
      @manifester ||= ::Manifester::Instance.new(
        root_path: ROOT_PATH,
        public_output_dir: "your-engine-packs", # the path where your packed files live
        cache_manifest: Rails.env.production?,
        fallback_to_webpacker: -> { YourEngine::IN_DEVELOPMENT || Rails.env.test? } # fallback to webpacker in development
      )
    end
  end
end
```

In your application helper override the `current_webpacker_instance` method to return your engine's instance **only in development** and the parent app webpacker in production.

Add the `current_manifester_instance` method.

```ruby
# app/helpers/your_engine/application_helper
module YourEngine
  module ApplicationHelper
    include ::Manifester::Helper # add the manifester helpers

    # add your current webpacker instance for development
    def current_webpacker_instance
      return YourEngine.webpacker if YourEngine::IN_DEVELOPMENT || Rails.env.test?

      super
    end

    def current_manifester_instance
      YourEngine.manifester
    end
  end
end
```

## Usage

Now you should have webpacker work as usual in development and testing environments and manifester in the production env.

## Contributing

Clone the repo, run `bundle install`.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
