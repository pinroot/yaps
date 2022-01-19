json.extract! pinger, :id, :name, :address, :interval, :timeout, :port, :pinger_type, :enabled, :created_at, :updated_at
json.url pinger_url(pinger, format: :json)
