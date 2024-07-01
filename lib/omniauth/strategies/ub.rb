# frozen_string_literal: true

require "omniauth-oauth2"

module OmniAuth
  module Strategies
    class Ub < OmniAuth::Strategies::OAuth2
      option :name, "ub"
      option :token_options, %w(client_id client_secret)

      uid do
        token_info["uid"]
      end

      info do
        {
          name: token_info["cn"],
          nickname: token_info["dni"],
          email: token_info["mail"]
        }
      end

      def callback_url
        full_host + callback_path
      end

      def token_info
        @token_info ||= begin
          connection = Faraday.new(url: options.client_options[:site], ssl: { verify: true }) do |conn|
            conn.headers["Authorization"] = "#{access_token.response.parsed.token_type} #{access_token.token}"
          end
          response = connection.get("/api/adas/oauth2/tokendata")
          raise Error, "Unable to fetch the user information" unless response.success?

          JSON.parse(response.body).to_h
        end
      end
    end
  end
end
