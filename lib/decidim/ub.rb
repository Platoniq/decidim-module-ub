# frozen_string_literal: true

require "decidim/ub/engine"

module Decidim
  module Ub
    include ActiveSupport::Configurable

    OMNIAUTH_PROVIDER_NAME = "ub"

    config_accessor :omniauth do
      {
        enabled: ENV["UB_CLIENT_ID"].present?,
        icon_path: ENV.fetch("UB_ICON", "media/images/ub_logo.svg"),
        client_id: ENV["UB_CLIENT_ID"].presence,
        client_secret: ENV["UB_CLIENT_SECRET"].presence,
        site: ENV["UB_SITE"].presence,
        authorize_url: ENV["UB_AUTHORIZE_URL"].presence,
        token_url: ENV["UB_TOKEN_URL"].presence
      }
    end

    class Error < StandardError; end
  end
end
