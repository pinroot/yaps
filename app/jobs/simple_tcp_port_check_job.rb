class SimpleTcpPortCheckJob
  include SuckerPunch::Job
  def perform(pinger_id)
    @pinger = Pinger.find(pinger_id)
    @check = ActivePinger::TCP.new(@pinger.address, @pinger.port, @pinger.timeout)
    def set_reason
      if @check.up?
        return "Connection allowed"
      elsif @check.down?
        return @check.exception
      else
        return "Unknown"
      end
    end
    if @check.status != @pinger.events.last.status
      @pinger.events.build(status: @check.status, reason: set_reason).save 
    end
    @pinger.update_columns(pinged_at: Time.now)
  end
end
