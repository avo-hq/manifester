require "zeitwerk"
require "manifester/version"

loader = Zeitwerk::Loader.for_gem
loader.push_dir("#{__dir__}/manifester", namespace: Manifester)
loader.setup

require "manifester/helper"
require "manifester/instance"
require "manifester/configuration"
require "manifester/manifest"

module Manifester
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Manifester::Instance.new
  end
end

require "manifester/engine" if defined?(Rails)