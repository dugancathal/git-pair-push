require 'dnssd'
module Git
  module Pair
    module Push
      class ServiceRegistrar
        attr_reader :provider
        SERVICE_TYPE = '_gitpush._tcp'
        def initialize(provider=DNSSD)
          @provider = provider
        end

        def register(port)
          DNSSD.register! service_name, SERVICE_TYPE, nil, port
          service_name
        end

        private
        def service_name
          "gitpush-#{`hostname`.chomp.gsub('.', '-')}"
        end
      end
    end
  end
end