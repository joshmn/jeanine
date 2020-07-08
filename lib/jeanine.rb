require 'rack'

require 'forwardable'
require 'logger'

require "jeanine/version"
require 'jeanine/core_ext'

module Jeanine
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
  autoload :App,   'jeanine/app'
end
