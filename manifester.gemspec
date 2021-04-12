require_relative "lib/manifester/version"

Gem::Specification.new do |spec|
  spec.name        = "manifester"
  spec.version     = Manifester::VERSION
  spec.authors     = ["Adrian Marin"]
  spec.email       = ["adrian@adrianthedev.com"]
  spec.homepage    = "https://avohq.io"
  spec.summary     = "Summary of Manifester."
  spec.description = "Description of Manifester."
  spec.license     = "MIT"

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/avo-hq/manifester"
  spec.metadata["changelog_uri"] = "https://github.com/avo-hq/manifester"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", "~> 6.1.3", ">= 6.1.3.1"
end
