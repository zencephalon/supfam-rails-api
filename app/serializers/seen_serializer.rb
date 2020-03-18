class SeenSerializer < ActiveModel::Serializer
  attributes :id, :network_type, :network_strength, :cellular_generation, :battery, :lat, :long, :client_type, :battery_state
  # has_one :user
end
