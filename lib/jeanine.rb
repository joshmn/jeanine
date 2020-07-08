require 'rack'

require 'forwardable'
require 'logger'

require "jeanine/version"
require 'jeanine/core_ext'

module Jeanine
  def self.env
    @_env ||= (ENV["RACK_ENV"].presence || "development")
  end

  def self.groups(*groups)
    hash = groups.extract_options!
    env = Jeanine.env
    groups.unshift(:default, env)
    groups.concat ENV["JEANINE_GROUPS"].to_s.split(",")
    groups.concat hash.map { |k, v| k if v.map(&:to_s).include?(env) }
    groups.compact!
    groups.uniq!
    groups
  end

  def self._installed_plugins
    @_installed_plugins ||= []
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

  autoload :Router,   'jeanine/router'
  autoload :App,      'jeanine/app'
end
