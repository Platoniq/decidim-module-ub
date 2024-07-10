# frozen_string_literal: true

require "spec_helper"

describe "OmniAuth button" do
  let!(:organization) { create(:organization) }

  before do
    organization.omniauth_settings = omniauth_settings.transform_values do |v|
      Decidim::OmniauthProvider.value_defined?(v) ? Decidim::AttributeEncryptor.encrypt(v) : v
    end
    organization.save

    switch_to_host(organization.host)
    visit decidim.new_user_session_path
  end

  context "when ub enabled" do
    let(:omniauth_settings) do
      {
        omniauth_settings_ub_enabled: true,
        omniauth_settings_ub_icon_path: "media/images/ub_logo.svg",
        omniauth_settings_ub_client_id: "test-client-id",
        omniauth_settings_ub_client_secret: "test-client-secret",
        omniauth_settings_ub_site: "https://test.example.org",
        omniauth_settings_ub_authorize_url: "/authorize",
        omniauth_settings_ub_token_url: "/token"
      }
    end

    it "has button" do
      expect(page).to have_content "Universitat De Barcelona"
    end
  end

  context "when ub disabled" do
    let(:omniauth_settings) do
      {
        omniauth_settings_ub_keycloak_enabled: false
      }
    end

    it "has no button" do
      expect(page).to have_no_content "Universitat De Barcelona"
    end
  end
end
