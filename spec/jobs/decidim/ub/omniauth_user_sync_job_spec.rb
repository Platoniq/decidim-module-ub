# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Ub
    describe OmniauthUserSyncJob do
      subject { described_class }

      describe "queue" do
        it "is queued to events" do
          expect(subject.queue_name).to eq "default"
        end
      end

      describe "perform" do
        let(:roles) { %w(PAS PDI) }
        let(:user) { create(:user, ub_roles: roles) }
        let(:params) { { user_id: user.id, raw_data: { info: { roles: } } } }

        before do
          allow(Rails.logger).to receive(:info).and_call_original
          allow(Rails.logger).to receive(:error).and_call_original
          subject.perform_now(params)
        end

        context "when the user has no identity" do
          it "does not call the sync job" do
            expect(Decidim::Ub::SyncUser).not_to receive(:call)
          end

          it "does not enqueue job" do
            expect { subject.perform_now(params) }.not_to have_enqueued_job(Decidim::Ub::AutoVerificationJob)
          end
        end

        context "when the user has identity" do
          let!(:identity) { create(:identity, user:, provider: Decidim::Ub::OMNIAUTH_PROVIDER_NAME) }

          context "when the sync runs successfully" do
            it "writes an info log" do
              subject.perform_now(params)
              expect(Rails.logger).to have_received(:info).with(/OmniauthUserSyncJob: Success/)
            end

            it "enqueues one job" do
              expect { subject.perform_now(params) }.to have_enqueued_job(Decidim::Ub::AutoVerificationJob).exactly(1)
            end
          end

          context "when the sync fails" do
            before do
              allow_any_instance_of(Decidim::Ub::SyncUser).to receive(:update_user!).and_raise
            end

            it "writes an error log" do
              subject.perform_now(params)
              expect(Rails.logger).to have_received(:error).with(/OmniauthUserSyncJob: ERROR/)
            end
          end
        end
      end
    end
  end
end
