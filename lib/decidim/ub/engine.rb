# frozen_string_literal: true

require "omniauth/strategies/ub"

module Decidim
  module Ub
    # This is the engine that runs on the public interface of ub.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Ub

      config.to_prepare do
        Decidim::OmniauthHelper.include(Decidim::Ub::OmniauthHelperOverride)
        Decidim::User.include(Decidim::Ub::UserOverride)
      end

      initializer "decidim_ub.omniauth" do
        next unless Decidim::Ub.omniauth && Decidim::Ub.omniauth[:client_id]

        # Decidim use the secrets configuration to decide whether to show the omniauth provider
        Rails.application.secrets[:omniauth][Decidim::Ub::OMNIAUTH_PROVIDER_NAME.to_sym] = Decidim::Ub.omniauth

        Rails.application.config.middleware.use OmniAuth::Builder do
          provider Decidim::Ub::OMNIAUTH_PROVIDER_NAME,
                   client_id: Decidim::Ub.omniauth[:client_id],
                   client_secret: Decidim::Ub.omniauth[:client_secret],
                   client_options: {
                     site: Decidim::Ub.omniauth[:site],
                     authorize_url: Decidim::Ub.omniauth[:authorize_url],
                     token_url: Decidim::Ub.omniauth[:token_url]
                   }
        end
      end

      initializer "decidim_ub.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end

      initializer "decidim_ub.authorizations" do
        Decidim::Ub.authorizations.each do |name|
          Decidim::Verifications.register_workflow(name.to_sym) do |workflow|
            workflow.form = "Decidim::Ub::Verifications::#{name.camelize}"
          end
        end
      end

      initializer "decidim_ub.user_sync" do
        ActiveSupport::Notifications.subscribe "decidim.user.omniauth_registration" do |_name, data|
          Decidim::Ub::OmniauthUserSyncJob.perform_later(data) if data[:provider] == Decidim::Ub::OMNIAUTH_PROVIDER_NAME
        end

        ActiveSupport::Notifications.subscribe "decidim.ub.user.updated" do |_name, data|
          Decidim::Ub::AutoVerificationJob.perform_later(data)
        end
      end
    end
  end
end
