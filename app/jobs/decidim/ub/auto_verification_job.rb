# frozen_string_literal: true

module Decidim
  module Ub
    class AutoVerificationJob < ApplicationJob
      queue_as :default

      def perform(user_id)
        @user = Decidim::User.find(user_id)
        @auths = Decidim::Ub.roles_to_auth_name(@user.ub_roles & Decidim::Ub::ROLES)
        update_auths
      rescue ActiveRecord::RecordNotFound
        Rails.logger.error "AutoVerificationJob: ERROR: model not found for user #{user_id}"
      end

      private

      def update_auths
        current_auths = user_auths.pluck(:name)
        (current_auths - @auths).each { |name| remove_auth(user_auths.find_by(name:)) }
        (@auths - current_auths).each { |name| create_auth(name) }
      end

      def create_auth(name)
        return unless (handler = Decidim::AuthorizationHandler.handler_for(name, user: @user))

        Decidim::Verifications::AuthorizeUser.call(handler, @user.organization) do
          on(:ok) do
            Rails.logger.info "AutoVerificationJob: Success: created auth #{name} for user #{handler.user.id}"
          end

          on(:invalid) do
            Rails.logger.error "AutoVerificationJob: ERROR: not created auth #{name} for user #{handler.user&.id}"
          end
        end
      end

      def remove_auth(auth)
        Decidim::Verifications::DestroyUserAuthorization.call(auth) do
          on(:ok) do
            Rails.logger.info "AutoVerificationJob: Success: removed auth #{auth.name} for user #{auth.user.id}"
          end

          on(:invalid) do
            Rails.logger.error "AutoVerificationJob: ERROR: not removed auth #{auth.name} for user #{auth.user&.id}"
          end
        end
      end

      def user_auths
        @user_auths ||= Decidim::Authorization.where(user: @user, name: Decidim::Ub.authorizations)
      end
    end
  end
end
