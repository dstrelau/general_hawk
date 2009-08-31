require 'cijoe'
require 'yaml'

class GeneralHawk
  class << self
    def to_app
      joes = Rack::Builder.new
      config.each do |app, opts|
        joes.map("/#{app}") { run Class.new(CIJoe::Server).set(opts) }
      end
      joes.to_app
    end

    private
    def config
      @_config ||= YAML.load_file(File.dirname(__FILE__)+'/joes.yml')
    end
  end
end
