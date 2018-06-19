# frozen_string_literal: true

class ProfilePicUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
