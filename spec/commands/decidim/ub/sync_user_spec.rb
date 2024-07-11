# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Ub
    describe SyncUser do
      subject { described_class.new(user, roles) }

      let(:user) { create(:user) }
      let!(:identity) { create(:identity, user:, provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME) }
      let(:roles) { %w(PAS PDI) }

      context "when everything is ok" do
        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "updates the roles" do
          expect { subject.call }.to change(user, :ub_roles).from([]).to(roles)
        end

        context "when user already has roles" do
          let(:old_roles) { %w(EST) }
          let!(:user) { create(:user, ub_roles: old_roles) }

          it "updates the roles" do
            sleep(1)
            expect { subject.call }.to change(user, :ub_roles).from(old_roles).to(roles)
          end
        end
      end

      context "when user has no ub identity" do
        before do
          allow(user).to receive(:ub_identity?).and_return(false)
        end

        it "broadcasts ok" do
          expect { subject.call }.to broadcast(:ok)
        end

        it "does not update the roles" do
          expect { subject.call }.not_to change(user, :ub_roles)
        end
      end

      context "when an exception is raised" do
        before do
          allow(user).to receive(:ub_identity?).and_raise(StandardError)
        end

        it "broadcasts invalid" do
          expect { subject.call }.to broadcast(:invalid)
        end

        it "does not update the roles" do
          expect { subject.call }.not_to change(user, :ub_roles)
        end
      end
    end
  end
end
