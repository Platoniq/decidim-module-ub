# frozen_string_literal: true

module Decidim
  module Ub
    module OmniauthHelperOverride
      extend ActiveSupport::Concern

      included do
        alias_method :original_normalize_provider_name, :normalize_provider_name

        def normalize_provider_name(provider)
          return "Universitat de Barcelona" if provider == :ub

          original_normalize_provider_name(provider)
        end
      end
    end
  end
end
