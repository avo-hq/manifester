require "zeitwerk"
require "manifester/version"

loader = Zeitwerk::Loader.for_gem
loader.setup

module Manifester
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Manifester::Instance.new
  end
end

require "manifester/instance"
require "manifester/env"
require "manifester/configuration"
require "manifester/manifest"

require "manifester/engine" if defined?(Rails)