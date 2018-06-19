# frozen_string_literal: true

class ArtworkUploader < CarrierWave::Uploader::Base
  include Cloudinary::CarrierWave
end
