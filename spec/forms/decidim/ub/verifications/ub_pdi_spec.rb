# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Ub
    module Verifications
      describe UbPdi do
        subject { described_class.from_params(attributes) }

        let(:attributes) do
          {
            "user" => user
          }
        end
        let(:roles) { %w(PDI) }
        let(:user) { create(:user, ub_roles: roles) }
        let(:identity) { create(:identity, user:, provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME) }

        it "returns the valid role" do
          expect(subject.send(:role)).to eq("PDI")
        end

        context "when everything is ok" do
          it { is_expected.to be_valid }

          it "returns valid organization" do
            expect(subject.send(:organization)).to eq(user.organization)
          end

          it "returns valid user" do
            expect(subject.send(:user)).to eq(user)
          end
        end

        context "when the user does not have the role" do
          let(:roles) { %w(ANT) }

          it { is_expected.not_to be_valid }
        end
      end
    end
  end
end
