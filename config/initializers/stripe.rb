Rails.configuration.stripe = {
  publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  secret_key:      ENV['STRIPE_SECRET_KEY']
}

# Stripe.api_key = Rails.configuration.stripe[:secret_key]

Stripe.api_key = "sk_test_uYL4rMq5HZRiwSB8RWxqSYhq"
