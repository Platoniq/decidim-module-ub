# frozen_string_literal: true

Decidim::Ub.configure do |config|
  config.omniauth = {
    client_id: "test-client-id",
    client_secret: "test-client-secret",
    site: "https://test.example.org",
    authorize_url: "/authorize",
    token_url: "/token"
  }
end
