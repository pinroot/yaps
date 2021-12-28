class Pinger < ApplicationRecord
  # TODO: GLOBAL SETTINGS
  # 1) MINIMUM\MAXIMUM INTERVAL MUST STORED IN APP SETTINGS
  # 2) STORAGE DEPTH FOR EVENTS (IN DAYS) MUST STORED IN APP SETTINGS

  valid_ip_address_regex = /^(([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])\.){3}([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$/
  valid_hostname_regex = /^(([a-zA-Z0-9]|[a-zA-Z0-9][a-zA-Z0-9\-]*[a-zA-Z0-9])\.)*([A-Za-z0-9]|[A-Za-z0-9][A-Za-z0-9\-]*[A-Za-z0-9])$/

  after_create :create_pinger_scheduler
  after_update :update_pinger_scheduler
  after_destroy :destroy_pinger_scheduler

  enum pinger_type: [ :simple_tcp_port_check ]

  has_many :pinger_events, dependent: :destroy
  has_many :events, foreign_key: "pinger_id", class_name: "PingerEvent", dependent: :destroy

  validates_presence_of :name, :address, :interval, :timeout, :pinger_type

  validates :interval, comparison: { greater_than_or_equal_to: 10 } # 10 seconds
  validates :interval, comparison: { less_than_or_equal_to: 3600 } # 1 hour

  validates :address, format: {
    with:    /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$|(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}/, 
    multiline: true,
    message: 'must be a FQDN or IP'
  }

  def status
    events.last.status
  end

  def scheduler
    scheduler = Rufus::Scheduler.singleton.job(scheduler_job_id)
  end

  def create_pinger_scheduler
    scheduler = Rufus::Scheduler.singleton.every "#{interval}s", job: true do
      SimpleTcpPortCheckJob.perform_async(id) if pinger_type == "simple_tcp_port_check"
    end
    if scheduler
      update_columns(scheduler_job_id: scheduler.job_id)
      Rails.logger.info "Rufus has been scheduled the job: '#{scheduler.job_id}'"
    else
      Rails.logger.info "Rufus couldn't schedule the job, something wrong"
    end
  end

  def update_pinger_scheduler
    scheduler = Rufus::Scheduler.singleton.job(scheduler_job_id) if scheduler_job_id.presence

    if previous_changes.has_key?('enabled')
      if enabled
        create_pinger_scheduler
        Rails.logger.info "Pinger has been enabled: Rufus Scheduled Job #{scheduler_job_id}"
      else
        scheduler.unschedule
        Rails.logger.info "Pinger has been disabled: Rufus Unscheduled Job #{scheduler_job_id}"
        update_columns(scheduler_job_id: nil)  
      end
    end

    if previous_changes.has_key?('interval') or previous_changes.has_key?('timeout')
      Rails.logger.info "Interval or timeout has been changed"
      scheduler.unschedule
      Rails.logger.info "Rufus Unscheduled Job #{scheduler_job_id}"
      update_columns(scheduler_job_id: nil)
      create_pinger_scheduler
    end

    if previous_changes.has_key?('address')
      Rails.logger.info "The address has been changed"
      scheduler.unschedule
      Rails.logger.info "Rufus Unscheduled Job #{scheduler_job_id}"
      update_columns(scheduler_job_id: nil)
      create_pinger_scheduler
    end

  end

  def destroy_pinger_scheduler
    scheduler = Rufus::Scheduler.singleton.job(scheduler_job_id) if scheduler_job_id.presence
    if scheduler
      scheduler.unschedule
      Rails.logger.info "Rufus Unscheduled Job: '#{scheduler_job_id}'"
    else
      Rails.logger.info "Rufus couldn't unschedule the job: '#{scheduler_job_id}'"
    end
  end

end
