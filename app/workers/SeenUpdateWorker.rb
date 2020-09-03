# typed: true
class SeenUpdateWorker
  include Sidekiq::Worker

  def perform(user_id, profile_id, data)
    current_user = User.find(user_id)
    return unless current_user

    current_profile = current_user.profiles.find_by(id: profile_id)
    return unless current_profile

    current_profile.update_seen(data)
  end
end
