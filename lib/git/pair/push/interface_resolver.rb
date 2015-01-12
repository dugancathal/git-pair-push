module Git
  module Pair
    module Push
      class InterfaceResolver
        def call
          Socket.getifaddrs.reject(&method(:invalid_interface?)).map { |ifaddr| "%-40s %s" % [ifaddr.name, ifaddr.addr.ip_address] }
        end

        private

        def invalid_interface?(ifaddr)
          !ifaddr.addr.ip? || (ifaddr.flags & Socket::IFF_MULTICAST == 0) || ifaddr.name.start_with?('l')
        end
      end
    end
  end
end
