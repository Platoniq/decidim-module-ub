# frozen_string_literal: true

module Decidim
  module Ub
    module UserOverride
      extend ActiveSupport::Concern

      included do
        def ub_identity
          identities.find_by(provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME)
        end

        def ub_identity?
          identities.exists?(provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME)
        end
      end
    end
  end
end
