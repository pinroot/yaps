class SimpleTcpPortCheckJob
  include SuckerPunch::Job

  def perform(pinger_id)

    @pinger = Pinger.find(pinger_id)
    
    @check = ActivePinger::TCP.new(@pinger.address, @pinger.port, @pinger.timeout)    

    def current_status
      if @check.up?
        status = "up"
      else
        status ="down"
      end
      return status
    end

    def previous_status
      if @pinger.events.any?
        status = @pinger.events.last.status
      else
        status = "unknown"
      end
      return status
    end

    def build_event
      if current_status == "down" and previous_status != current_status
        event = @pinger.events.build(reason: @check.exception, status: current_status)
      elsif current_status == "up" and previous_status != current_status
        event = @pinger.events.build(reason: "Connection established", status: current_status)
      end
      event.save if event
      Rails.logger.info "The new event with status '#{previous_status}' was created for pinger ##{@pinger.id}" if event
      @pinger.update_columns(pinged_at: Time.now)
    end    

    build_event

    Rails.logger.info "Previous status was '#{previous_status}'"
    Rails.logger.info "Current status is '#{current_status}'"

  end

end
