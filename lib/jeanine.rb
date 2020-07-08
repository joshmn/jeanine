require 'forwardable'
require 'logger'

require "jeanine/version"
require 'jeanine/core_ext'
require 'jeanine/router'
require 'jeanine/app'
require 'tilt'

module Jeanine
  def self.view_paths
    @_view_paths ||= Set.new(["views"])
  end
  def self.tilt_cache
    @title_cache ||= Tilt::Cache.new
  end

  def self.logger
    @logger ||= Logger.new(STDOUT)
  end

  def logger=(val)
    @logger = val
  end

  def self.router
    @router ||= Router.new
  end
end
