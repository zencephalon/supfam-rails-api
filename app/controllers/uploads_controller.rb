# typed: true
require 'aws-sdk'

class UploadsController < ApplicationController
  def presign
    signer = Aws::S3::Presigner.new
    # TODO: validate filetype
    key = "#{@current_user.name}/#{SecureRandom.uuid}.#{params[:filetype]}"
    url = signer.presigned_url(:put_object, bucket: 'supfam-avatar', key: key)

    render json: { url: url, key: key }
  end
end
