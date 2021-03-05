require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    status, headers, body = @app.call(env)
    request_info(env)
    response_info(env, status, headers)

    [status, headers, body]
  end

  def request_info(env)
    @request = Rack::Request.new(env)
    controller = env['simpler.controller'] if env['simpler.controller']
    action = env['simpler.action'] if env['simpler.action']

    log = "\nRequest: #{env['REQUEST_METHOD']} #{env['REQUEST_URI']}\n"
    log += "Handler: #{controller}##{action}\n"
    log += "Parameters: #{@request.params}"
    @logger.info(log)
  end

  def response_info(env, status, headers)
    log = "\nResponse: #{status} [#{headers['Content-Type']}] "
    log += (env['simpler.view_file']).to_s if env['simpler.view_file']
    log += "\n----------------------------------------------------\n\n"
    log += '----------------------------------------------------'
    @logger.info(log)
  end

end
