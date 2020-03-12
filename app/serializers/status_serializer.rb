class StatusSerializer < ActiveModel::Serializer
  attributes :id, :color, :message
  # has_one :user
end
