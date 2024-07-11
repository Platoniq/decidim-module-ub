# frozen_string_literal: true

require "spec_helper"

module Decidim
  describe User do
    let!(:user) { create(:user) }
    let!(:organization) { user.organization }

    describe "#ub_identity?" do
      subject { user.ub_identity? }

      context "when user has a ub-provided identity" do
        let!(:identity) { create(:identity, user:, provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME) }

        it { is_expected.to be_truthy }
      end

      context "when user doesn't have a ub-provided identity" do
        let!(:identity) { create(:identity, user:, provider: "other") }

        it { is_expected.to be_falsey }
      end

      context "when user doesn't have an identity" do
        it { is_expected.to be_falsey }
      end
    end

    describe "#ub_identity" do
      subject { user.ub_identity }

      context "when user has a ub-provided identity" do
        let!(:identity) { create(:identity, user:, provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME) }

        it { is_expected.to be_a Decidim::Identity }
      end

      context "when user doesn't have a ub-provided identity" do
        let!(:identity) { create(:identity, user:, provider: "other") }

        it { is_expected.to be_nil }
      end

      context "when user doesn't have an identity" do
        it { is_expected.to be_nil }
      end
    end
  end
end
