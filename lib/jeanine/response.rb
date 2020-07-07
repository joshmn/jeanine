require 'forwardable'
require 'json'

module Jeanine
  class Response
    attr_accessor :action_variables
    attr_reader :headers, :body
    attr_accessor :status

    def initialize(body = [], status = 200, headers = { 'Content-Type' => 'text/html; charset=utf-8' })
      @body = body
      @status = status
      @headers = headers
      @length = 0

      return if body == []
      if body.respond_to? :to_str
        write body.to_str
      elsif body.respond_to? :each
        body.each { |i| write i.to_s }
      else
        raise TypeError, 'body must #respond_to? #to_str or #each'
      end
    end

    def complete!
      unless (100..199).include?(status) || status == 204
        headers['Content-Length'] = @length.to_s
      end
      [status, headers, body]
    end

    def content_type=(type)
      headers['Content-Type'] = type
    end

    def redirect_to(target, status = 302)
      self.status = status
      headers['Location'] = target
    end

    def write(string)
      s = string.to_s
      @length += s.bytesize

      body << s
    end
  end
end
