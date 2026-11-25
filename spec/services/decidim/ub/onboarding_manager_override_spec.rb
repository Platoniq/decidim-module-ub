# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe OnboardingManager do
    subject { described_class.new(user) }

    let(:organization) { create(:organization) }
    let(:user) { create(:user, :confirmed, organization:, extended_data:) }
    let(:extended_data) { { "onboarding" => { "action" => "create", "model" => "gid://decidim/Decidim::Meetings::Meeting/1" } } }

    it "has a pending action" do
      expect(subject.pending_action?).to be(true)
    end

    context "when the user signed up with the UB OAuth method" do
      before do
        create(:identity, user:, provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME)
      end

      it "has no pending action" do
        expect(subject.pending_action?).to be(false)
      end
    end
  end

  describe Devise::SessionsController do
    it "keeps the core sign-in redirects" do
      file = described_class.instance_method(:after_sign_in_path_for).source_location.first

      expect(file).to end_with("app/controllers/concerns/decidim/devise_authentication_methods.rb")
    end
  end
end
