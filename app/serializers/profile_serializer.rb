class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :status, :seen, :avatar_url, :updated_at, :name
end
