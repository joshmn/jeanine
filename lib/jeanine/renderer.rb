require 'jeanine/view'

module Jeanine
  class Renderer
    def self._renderers
      @_renderers ||= Set.new
    end

    def self.add(key, &block)
      define_method(_render_with_renderer_method_name(key), &block)
      _renderers << key.to_sym
    end

    def _render_with_renderer_method_name(key)
      self.class._render_with_renderer_method_name(key)
    end

    def self._render_with_renderer_method_name(key)
      "_render_with_renderer_#{key}"
    end

    def initialize(response)
      @response = response
    end

    def render(*args)
      options = _normalize_render(*args)
      _render_to_body_with_renderer(options)
    end

    private

    def _normalize_render(*args, &block)
      options = _normalize_args(*args, &block)
      _normalize_options(options)
      options
    end

    def _normalize_args(action = nil, options = {})
      if action.is_a?(Hash)
        action
      else
        options
      end
    end

    def _normalize_options(options)
      options
    end

    def _render_to_body_with_renderer(options)
      self.class._renderers.each do |name|
        if options.key?(name)
          _process_options(options)
          method_name = _render_with_renderer_method_name(name)
          return send(method_name, options.delete(name), options)
        end
      end
      nil
    end

    def _process_options(options)
      status, content_type, location = options.values_at(:status, :content_type, :location)
      @response.status = status if status
      @response.content_type = content_type if content_type
      @response.headers["Location"] = location if location
    end

    add :json do |json, options|
      json = json.to_json(options) unless json.is_a?(String)

      if options[:callback]
        "/**/#{options[:callback]}(#{json})"
      else
        @response.content_type = Mimes.for(:json)
        json
      end
    end

    def cache
      Thread.current[:tilt_cache] ||= Tilt::Cache.new
    end

    def find_template!(template)
      Jeanine.view_paths.to_a.each do |path|
        template_with_path = "#{path}/#{template}"
        if File.exist?(template_with_path)
          return template_with_path
        end
      end
      raise "Template not found in view paths. Looking for #{template} in #{Jeanine.view_paths.to_a.join(', ')}"
    end

    def html(engine, template_name, options = {}, locals = {}, &block)
      locals          = options.delete(:locals) || locals || {}
      layout          = options[:layout]
      scope           = options.delete(:scope) || self
      options.delete(:layout)
      options[:outvar] ||= '@_out_buf'
      options[:default_encoding] ||= "UTF-8"
      template        = compile_template(engine, template_name, options)
      output          = template.render(scope, locals, &block)
      if layout
        unless layout.include?("layouts/")
          layout = "layouts/#{layout}"
        end
        layout = find_template!(layout)
        options = options.merge(layout: false, scope: scope)
        catch(:layout_missing) { return html(engine, layout, options, locals) { output } }
      end
      output
    end

    def compile_template(engine, template_name, options)
      Tilt::Cache.new.fetch engine, template_name, options do
        template = Tilt[engine]
        raise "Template engine not found: #{engine}" if template.nil?
        template_name = find_template!(template_name)
        template.new(template_name, options)
      end
    end

    add :template do |template, options|
      view = Jeanine::View.new
      @response.action_variables.each do |k,v|
        view.instance_variable_set(k, v.dup)
      end
      options[:scope] = view
      html(:erb, template, options)
    end

    add :text do |text, _options|
      @response.content_type = Mimes.for(:text)
      text
    end

    add :plain do |text, _options|
      @response.content_type = Mimes.for(:plain)
      text
    end
  end
end
