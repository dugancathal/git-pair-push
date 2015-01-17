require 'git/pair/push/app'
require 'git/pair/push/service_registrar'
module Git
  module Pair
    module Push
      class Runner
        attr_reader :app, :service_registrar
        def initialize(app=App, service_registrar=ServiceRegistrar.new)
          @app = app
          @service_registrar = service_registrar
        end

        def call(git_args, port)
          app.set git_args: git_args, port: port
          service_name = service_registrar.register port
          puts "Running as #{service_name}"
          app.run!
        end
      end
    end
  end
end