class Profile < ApplicationRecord
  belongs_to :user

  def update_status(params)

    new_status = {}
    if params[:message]
      new_status["message"] = params[:message]
    end
    if params[:color]
      new_status["color"] = params[:color]
    end
    self.status = self.status.merge(new_status)
    return self.save
  end

  after_create do |profile|
    profile.status = {
      message: 'I just joined, so everyone please welcome me! Sup fam?',
      color: 3,
    }
    profile.save
  end
end
