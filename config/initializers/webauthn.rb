WebAuthn.configure do |config|
  config.origin = "http://localhost:3000"
  config.rp_name = "Example ID"
  config.credential_options_timeout = 120000
  config.rp_id = nil
  config.encoding = :base64url
  config.algorithms = %w[ES256 PS256 RS256];
end