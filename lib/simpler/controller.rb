require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
      @body = nil
    end

    def make_response(action)
      @request.env['simpler.controller'] = self
      @request.env['simpler.action'] = action
      @request.env['simpler.params'].each { |key, value| @request.update_param(key.to_sym, value) }

      set_default_headers
      send(action)
      write_response

      @response.finish
    end

    private

    def status(value)
      @response.status = value
    end

    def headers
      @response
    end

    def params
      @request.params
    end

    def extract_name
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      @body = render_body if @body.nil?

      @response.write(@body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def render(template)
      if template.is_a? Hash
        @response.headers['Content-Type'] = 'text/' + template.keys.first.to_s
        @body = template.values.first
      else
        @request.env['simpler.template'] = template
      end
    end

  end
end
