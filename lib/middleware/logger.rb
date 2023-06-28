require 'logger'

class AppLogger

  def initialize(app, **options)
    @logger = Logger.new(options[:logdev] || STDOUT)
    @app = app
  end

  def call(env)
    response = @app.call(env)
    @logger.info(log_message(env, response))

    response
  end

  private

  def log_message(env, response)
    "\n    Request: #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}
    Handler: #{env['simpler.controller'].class}##{env['simpler.action']}
    Parameters: #{env['simpler.params']}
    Response: #{response[0]} #{response[1]['Content-Type']} #{env['simpler.template']}"
  end
end
