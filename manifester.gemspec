require_relative "lib/manifester/version"

Gem::Specification.new do |spec|
  spec.name        = "manifester"
  spec.version     = Manifester::VERSION
  spec.authors     = ["Adrian Marin"]
  spec.email       = ["adrian@adrianthedev.com"]
  spec.homepage    = "https://avohq.io"
  spec.summary     = "Manifester loads stylesheets and javascript assets from your manifest.json file."
  spec.description = "Manifester loads stylesheets and javascript assets from your manifest.json file."
  spec.license     = "MIT"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/avo-hq/manifester"
  spec.metadata["changelog_uri"] = "https://github.com/avo-hq/manifester"

  spec.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]

  spec.add_dependency "rails", ">= 6.0"
end
