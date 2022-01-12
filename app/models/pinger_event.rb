class PingerEvent < ApplicationRecord
  enum status: [ :up, :down, :enabled, :disabled, :created, :unknown ]

  belongs_to :pinger
  validates_presence_of :pinger_id, :reason, :status

  validate :check_last_status

  def check_last_status
    if status.present? and Pinger.find(pinger_id).pinger_events.last.present?
      if status == Pinger.find(pinger_id).pinger_events.last.status
        errors.add(:status, 'Something bad')
      end
    end
  end

  #def check_last_status
  #  if events.last.status == status
  #    errors.add(:status, 'Somewhing bad')
  #  end 
  #end

end
