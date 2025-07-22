# frozen_string_literal: true

module Decidim
  module DeviseAuthenticationMethods
    def pending_onboarding_action?(user)
      return false if user.ub_identity?

      super
    end
  end
end
