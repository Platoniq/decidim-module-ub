# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Ub < OmniAuth::Strategies::OAuth2
      REGEXP_SANITIZER = /[<>?%&^*#@()\[\]=+:;"{}\\|]/

      option :name, "ub"
      option :token_options, %w(client_id client_secret)

      uid do
        raw_info.dig("employeenumber", 0)
      end

      info do
        {
          name: raw_info.dig("cn", 0).gsub(REGEXP_SANITIZER, ""),
          nickname: Decidim::UserBaseEntity.nicknamize(raw_info.dig("uidnet", 0)),
          email: raw_info.dig("mail", 0),
          roles: raw_info["colect2"] || []
        }
      end

      def callback_url
        full_host + callback_path
      end

      def raw_info
        @raw_info ||= begin
          connection = Faraday.new(url: options.client_options[:site], ssl: { verify: true }) do |conn|
            conn.headers["Authorization"] = access_token.options[:header_format].gsub("%s", access_token.token)
          end
          response = connection.get("/api/adas/oauth2/tokendata")
          raise Error, "Unable to fetch the user information" unless response.success?

          JSON.parse(response.body).to_h
        end
      end
    end
  end
end
