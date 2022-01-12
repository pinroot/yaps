class PingerEvent < ApplicationRecord
  enum status: [ :up, :down, :enabled, :disabled, :created, :unknown ]

  belongs_to :pinger
  validates_presence_of :pinger_id, :reason, :status

  #validate :check_last_status
  #def check_last_status
  #  if events.last.status == status
  #    errors.add(:status, 'Somewhing bad')
  #  end 
  #end

end
