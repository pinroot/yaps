require 'socket'
require 'timeout'

module Checkers
  class PortChecker
    def initialize(ip, port, timeout)
      @ip = ip
      @port = port
      @timeout = timeout
    end
    def port_open?
      Timeout::timeout(@timeout) do
        begin
          TCPSocket.new(@ip, @port).close
          true
        rescue Errno::ECONNREFUSED, Errno::EHOSTUNREACH
          false
        end
      end
      rescue Timeout::Error
      false
    end
  end
end
