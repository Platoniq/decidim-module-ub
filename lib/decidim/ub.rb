# frozen_string_literal: true

require "decidim/ub/engine"

module Decidim
  module Ub
    OMNIAUTH_PROVIDER_NAME = "ub"
    ROLES = %w(EST PAS PDI PEX ANT).freeze

    class << self
      def roles_to_auth_name(roles)
        roles.map { |role| "ub_#{role.downcase}" }
      end

      def config = self

      def configure
        yield self
      end
    end

    mattr_accessor :omniauth, default: {
      enabled: ENV["UB_CLIENT_ID"].present?,
      icon_path: ENV.fetch("UB_ICON", "media/images/ub_logo.svg"),
      client_id: ENV["UB_CLIENT_ID"].presence,
      client_secret: ENV["UB_CLIENT_SECRET"].presence,
      site: ENV["UB_SITE"].presence,
      authorize_url: ENV["UB_AUTHORIZE_URL"].presence,
      token_url: ENV["UB_TOKEN_URL"].presence
    }

    mattr_accessor :authorizations, default: roles_to_auth_name(ROLES).freeze

    class Error < StandardError; end
  end
end
