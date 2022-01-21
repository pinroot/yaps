class PingerEvent < ApplicationRecord
  belongs_to :pinger

  enum status: [ :up, :down, :enabled, :disabled, :created, :unknown ]

  validates_presence_of :pinger_id, :reason, :status

  validate :check_last_status

  # ugly duplicates validation
  # TODO: https://blog.kiprosh.com/implement-optimistic-locking-in-rails/
  def check_last_status
    if status.present? and Pinger.find(pinger_id).pinger_events.last.present?
      if status == Pinger.find(pinger_id).pinger_events.last.status
        errors.add(:status, 'Something bad')
      end
    end
  end

end
