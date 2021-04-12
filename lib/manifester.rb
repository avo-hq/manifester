require "manifester/version"
require "manifester/engine"

module Manifester
  extend self

  def instance=(instance)
    @instance = instance
  end

  def instance
    @instance ||= Manifester::Instance.new
  end
end
