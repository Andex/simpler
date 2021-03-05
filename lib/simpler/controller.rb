require_relative 'view'

module Simpler
  class Controller

    attr_reader :name, :request, :response

    def initialize(env)
      @name = extract_name
      @request = Rack::Request.new(env)
      @response = Rack::Response.new
    end

    def make_response(action)
      if action.nil?
        bad_request
      else
        @request.env['simpler.controller'] = self
        @request.env['simpler.action'] = action

        set_default_headers
        params[:id] = set_request_param
        send(action)
        write_response
      end

      @response.finish
    end

    private

    def extract_name
      # то, что захватится перед 'Controller' занесется в группу по ключу :name - синтаксис групп (?<name_group>regex)
      self.class.name.match('(?<name>.+)Controller')[:name].downcase
    end

    def set_default_headers
      @response['Content-Type'] = 'text/html'
    end

    def write_response
      body = render_plain || render_body
      # write дописывает body к ответу
      @response.write(body)
    end

    def render_body
      View.new(@request.env).render(binding)
    end

    def params
      @request.params
    end

    def render(template)
      @request.env['simpler.template'] = template
    end

    def render_plain
      return unless @request.env['simpler.template'].is_a?(Hash)

      @response['Content-Type'] = 'text/plain'
      @request.env['simpler.template'][:plain]
    end

    def headers
      @response
    end

    def status(status)
      @response.status = status
    end

    def bad_request
      status 404
      @response.write("Page at URL '#{@request.env['PATH_INFO']}' not found\n")
    end

    def set_request_param
      @request.env['REQUEST_PATH'].split('/')[2]
    end
  end
end
