require 'socket'
require 'timeout'

module Checkers
  class TCPPortChecker
    def initialize(address, port, timeout)
      @address = address
      @port = port
      @timeout = timeout
    end


    def is_open?
      Timeout::timeout(@timeout) do
        begin
          TCPSocket.new(@address, @port).close
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
