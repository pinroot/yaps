class PingerEvent < ApplicationRecord
  enum status: [ :up, :down, :enabled, :disabled, :created, :unknown ]

  belongs_to :pinger
  validates_presence_of :pinger_id, :reason, :status

end
