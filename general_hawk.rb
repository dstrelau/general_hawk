require 'cijoe'
require 'yaml'

class GeneralHawk
  class << self
    def to_app
      write_git_config
      app
    end

    private
    def write_git_config
      joes.each do |name, opts|
        cijoes = opts.delete('cijoe')
        cijoes.each do |key,value|
          `cd #{opts['project_path']} && git config cijoe.#{key} #{value}`
        end if cijoes.respond_to?(:each)
      end
    end

    def app
      builder = Rack::Builder.new
      joes.each do |app, opts|
        builder.map("/#{app}") { run Class.new(CIJoe::Server).set(opts) }
      end
      builder.to_app
    end

    def joes
      @_joes ||= YAML.load_file(File.dirname(__FILE__)+'/joes.yml')
    end
  end
end
