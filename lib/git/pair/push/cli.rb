require 'git/pair/push/runner'

module Git
  module Pair
    module Push
      class BaseError < StandardError; end
      class CommandLineArgumentError < BaseError; end

      class Cli
        attr_reader :args, :runner
        DEFAULT_PORT = 8675

        def self.run(args)
          new(args).run
        end

        def initialize(args, runner=Git::Pair::Push::Runner.new)
          @args = args
          @runner = runner
        end

        def run
          runner.call(git_args_from(args), port_arg_from(args))
        end

        private
        def git_args_from(args)
          git_args = args - ['-p', port_arg_from(args).to_s]
          git_args
        end

        def port_arg_from(args)
          if args.index('-p')
            Integer(args[args.index('-p') + 1])
          else
            DEFAULT_PORT
          end
        rescue ArgumentError
          raise CommandLineArgumentError.new("#{args[args.index('-p') + 1]} is not a valid port number")
        end
      end
    end
  end
end