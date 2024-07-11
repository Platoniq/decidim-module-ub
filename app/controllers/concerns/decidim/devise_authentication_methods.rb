# frozen_string_literal: true

module Decidim
  module DeviseAuthenticationMethods
    def first_login_and_not_authorized?(user)
      return false if user.ub_identity?

      super
    end
  end
end
