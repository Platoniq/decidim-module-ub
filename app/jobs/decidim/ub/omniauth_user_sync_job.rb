# frozen_string_literal: true

module Decidim
  module Ub
    class OmniauthUserSyncJob < ApplicationJob
      queue_as :default

      def perform(data)
        user = Decidim::User.find(data[:user_id])
        return unless user.ub_identity?

        Decidim::Ub::SyncUser.call(user, data.dig(:raw_data, :info, :roles)) do
          on(:ok) do
            Rails.logger.info "OmniauthUserSyncJob: Success: Ub roles updated for user #{user.id}"
          end

          on(:invalid) do |message|
            Rails.logger.error "OmniauthUserSyncJob: ERROR: Error updating ub roles '#{message}'"
          end
        end
      end
    end
  end
end
