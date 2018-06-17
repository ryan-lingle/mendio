class ProfilePicUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
