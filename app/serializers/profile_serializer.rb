class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :status, :seen
end
