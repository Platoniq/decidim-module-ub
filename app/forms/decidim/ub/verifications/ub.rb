# frozen_string_literal: true

require "digest"

module Decidim
  module Ub
    module Verifications
      class Ub < Decidim::AuthorizationHandler
        validate :user_valid

        def unique_id
          Digest::SHA512.hexdigest("#{role}/#{uid}-#{Rails.application.secrets.secret_key_base}")
        end

        protected

        def organization
          current_organization || user&.organization
        end

        def uid
          user.ub_identity
        end

        def user_valid
          errors.add(:user, "decidim.ub.errors.missing_role") unless user.ub_roles.include?(role)
        end

        def role = raise NotImplementedError
      end
    end
  end
end
