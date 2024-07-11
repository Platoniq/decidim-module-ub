# frozen_string_literal: true

require "spec_helper"

describe "Automatic verification after oauth sign up" do
  let!(:user) { create(:user) }

  context "when a user is registered with omniauth" do
    it "runs the OmniauthUserSyncJob" do
      expect do
        ActiveSupport::Notifications.publish(
          "decidim.user.omniauth_registration",
          user_id: user.id,
          identity_id: 1234,
          provider: "ub",
          uid: "aaa",
          email: user.email,
          name: "Ub User",
          nickname: "ub_user",
          avatar_url: "https://example.org/foo.jpg",
          raw_data: {}
        )
      end.to have_enqueued_job(Decidim::Ub::OmniauthUserSyncJob)
    end
  end

  context "when a ub user is updated" do
    it "runs the AutoVerificationJob" do
      expect do
        ActiveSupport::Notifications.publish(
          "decidim.ub.user.updated",
          user.id
        )
      end.to have_enqueued_job(Decidim::Ub::AutoVerificationJob)
    end
  end
end
