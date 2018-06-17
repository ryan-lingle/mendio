class ArtworkUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
