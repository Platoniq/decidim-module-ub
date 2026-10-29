# frozen_string_literal: true

module Decidim
  module Ub
    # Users who signed up with the UB OAuth method are verified by this module,
    # so they never have a pending onboarding action (no redirect to the
    # pending authorizations page after signing in or confirming).
    module OnboardingManagerOverride
      def pending_action?
        return false if user.ub_identity?

        super
      end
    end
  end
end
