require 'aws-sdk'

class UploadsController < ApplicationController
  def presign
    signer = Aws::S3::Presigner.new
    url = signer.presigned_url(:put_object, bucket: "supfam-avatar", key: "#{@current_user.name}/#{SecureRandom.uuid}/${filename}")
    render json: { url: url }
  end
end
