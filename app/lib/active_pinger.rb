module ActivePinger
  class TCP
    def initialize(address, port, conn_timeout)
      @address = address
      @port = port
      @conn_timeout = conn_timeout
    end
    def is_port_up?
      if Net::Ping::TCP.new(@address, @port, @conn_timeout).ping
        true
      else
        false
      end
    end
    def time
      Net::Ping::TCP.new(@address, @port, @conn_timeout).ping
    end
  end

end
