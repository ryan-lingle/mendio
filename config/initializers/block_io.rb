Rails.configuration.blockio = {
  api_key: ENV['BLOCKIO_API_KEY'],
  secret_pin: ENV['BLOCKIO_SECRET_PIN']
}

BlockIo.set_options :api_key=> Rails.configuration.blockio[:api_key], :pin => Rails.configuration.blockio[:secret_pin], :version => 2
