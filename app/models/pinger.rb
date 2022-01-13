class Pinger < ApplicationRecord
  require 'action_view'
  include ActionView::Helpers::DateHelper

  # TODO: GLOBAL SETTINGS
  # 1) MINIMUM\MAXIMUM INTERVAL MUST STORED IN APP SETTINGS
  # 2) STORAGE DEPTH FOR EVENTS (IN DAYS) MUST STORED IN APP SETTINGS

  after_create :create_pinger_scheduler
  after_update :update_pinger_scheduler
  after_destroy :destroy_pinger_scheduler

  enum pinger_type: [ :simple_tcp_port_check, :external_ping ]

  has_many :pinger_events, dependent: :destroy
  has_many :events, foreign_key: "pinger_id", class_name: "PingerEvent", dependent: :destroy

  validates_presence_of :name, :address, :interval, :timeout, :pinger_type

  validates :interval, comparison: { greater_than_or_equal_to: 10 } # 10 seconds
  validates :interval, comparison: { less_than_or_equal_to: 3600 } # 1 hour seconds

  validates :timeout, comparison: { greater_than_or_equal_to: 1 } # 10 seconds
  validates :timeout, comparison: { less_than_or_equal_to: 5 } # 1 hour seconds

  validates :address, format: {
    with:    /[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$|(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)(\.(25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)){3}/, 
    multiline: true,
    message: 'must be a FQDN or IP'
  }

  def last_downtime_in_words
    distance_of_time_in_words(events.second_to_last.created_at, events.last.created_at)
  end

  def last_status_duration_in_words
    distance_of_time_in_words(events.second_to_last.created_at, pinged_at)
  end

  def status
    events.last.status
  end

  def scheduler
    scheduler = Rufus::Scheduler.singleton.job(scheduler_job_id)
  end

  def create_pinger_scheduler
    events.build(status: "created", reason: "Creation successful")
    scheduler = Rufus::Scheduler.singleton.every "#{interval}s", job: true do
      SimpleTcpPortCheckJob.perform_async(id) if pinger_type == "simple_tcp_port_check"
      ExternalPingJob.perform_async(id) if pinger_type == "external_ping"
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
        events.build(status: "enabled", reason: "Enabling successful")
      else
        scheduler.unschedule
        Rails.logger.info "Pinger has been disabled: Rufus Unscheduled Job #{scheduler_job_id}"
        update_columns(scheduler_job_id: nil)  
        events.build(status: "disabled", reason: "Disabling successful")
      end
    end

    if previous_changes.has_key?('interval') or previous_changes.has_key?('timeout')
      Rails.logger.info "Interval or timeout has been changed"
      scheduler.unschedule
      Rails.logger.info "Rufus Unscheduled Job #{scheduler_job_id}"
      update_columns(scheduler_job_id: nil)
      create_pinger_scheduler
    end

    # !TODO:
    # User must be notified that the change
    # of the address will delete all previous
    # events associated with the previous address  
    if previous_changes.has_key?('address')
      Rails.logger.info "The address has been changed"
      events.destroy_all
      update_columns(pinged_at: nil)
      Rails.logger.info "Remove previous address events"
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
