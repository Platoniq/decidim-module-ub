# frozen_string_literal: true

module Decidim
  module Ub
    class SyncUser < Decidim::Command
      # Public: Initializes the command.
      #
      # user - A decidim user
      # roles - The roles of the user
      def initialize(user, roles)
        @user = user
        @roles = roles
      end

      # Executes the command. Broadcasts these events:
      #
      # - :ok when everything is valid.
      # - :invalid if we couldn't proceed.
      #
      # Returns nothing.
      def call
        update_user!
        ActiveSupport::Notifications.publish("decidim.ub.user.updated", user.id)
        broadcast(:ok)
      rescue StandardError => e
        broadcast(:invalid, e.message)
      end

      private

      attr_reader :user, :roles

      def update_user!
        user.ub_roles = roles
        user.save!
      end
    end
  end
end
