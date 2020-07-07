require 'forwardable'
require 'logger'

require "brody/version"
require 'brody/core_ext'
require 'brody/router'
require 'brody/app'
require 'tilt'

module Brody
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
