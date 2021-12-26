class Pinger < ApplicationRecord
  # TODO: GLOBAL SETTINGS
  # 1) MINIMUM\MAXIMUM INTERVAL MUST STORE IN APP SETTINGS
  # 2) STORAGE DEPTH FOR EVENTS (IN DAYS) MST STORE IN APP SETTINGS


  after_create :create_pinger_scheduler
  after_update :update_pinger_scheduler
  after_destroy :destroy_pinger_scheduler

  enum pinger_type: [ :simple_tcp_port_check ]

  has_many :pinger_events, dependent: :destroy
  has_many :events, foreign_key: "pinger_id", class_name: "PingerEvent", dependent: :destroy

  validates_presence_of :name, :address, :interval, :timeout, :pinger_type

  validates :interval, comparison: { greater_than_or_equal_to: 60 } # 1 minute
  validates :interval, comparison: { less_than_or_equal_to: 3600 } # 1 hour

  validates :address, format: {
    with:    %r{[a-z0-9]+([\-\.]{1}[a-z0-9]+)*\.[a-z]{2,6}(:[0-9]{1,5})?(\/.*)?$}i, multiline: true,
    message: 'must be a FQDN'
  }

  def create_pinger_scheduler
    scheduler = Rufus::Scheduler.singleton.every "#{interval}s", job: true do
      SimpleTcpPortCheckJob.perform_async(id) if pinger_type == "simple_tcp_port_check"
    end
    if scheduler
      update_columns(scheduler_job_id: scheduler.job_id)
      Rails.logger.info "Rufus Scheduled Job: '#{scheduler.job_id}'"
    else
      Rails.logger.info "Rufus couldn't schedule the job, something wrong"
    end
  end

  def update_pinger_scheduler
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
