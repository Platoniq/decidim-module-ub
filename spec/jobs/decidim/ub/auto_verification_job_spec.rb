# frozen_string_literal: true

require "spec_helper"

module Decidim
  module Ub
    describe AutoVerificationJob do
      subject { described_class }

      shared_examples_for "no authorization is created" do
        it "does not create an authorization" do
          expect { subject.perform_now(params) }.not_to change(Decidim::Authorization, :count)
        end
      end

      shared_examples_for "authorizations for the roles are created or removed" do |number|
        it "creates authorizations for the roles" do
          expect { subject.perform_now(params) }.to change(Decidim::Authorization, :count).by(number)
        end

        it "creates authorizations for the roles provided" do
          subject.perform_now(params)
          expect(Decidim::Authorization.where(user:).map(&:name)).to match_array(Decidim::Ub.roles_to_auth_name(roles & Decidim::Ub::ROLES))
        end
      end

      describe "queue" do
        it "is queued to events" do
          expect(subject.queue_name).to eq "default"
        end
      end

      describe "perform" do
        let(:roles) { %w(PAS PDI) }
        let(:user) { create(:user, ub_roles: roles) }
        let(:params) { user.id }

        before do
          allow(Rails.logger).to receive(:info).and_call_original
          allow(Rails.logger).to receive(:error).and_call_original
        end

        it_behaves_like "authorizations for the roles are created or removed", 2

        context "when the user already has the authorization for the roles" do
          let!(:authorization_pas) { create(:authorization, name: "ub_pas", user:) }
          let!(:authorization_pdi) { create(:authorization, name: "ub_pdi", user:) }

          it_behaves_like "no authorization is created"

          context "when the roles are different from the user roles" do
            let(:roles) { %w(ANT EST PEX) }

            it_behaves_like "authorizations for the roles are created or removed", 1

            context "when the authorization cannot be removed" do
              before do
                # rubocop: disable RSpec/AnyInstance
                allow_any_instance_of(Decidim::Verifications::DestroyUserAuthorization).to receive(:authorization).and_return(nil)
                # rubocop: enable RSpec/AnyInstance
              end

              it "writes an error log" do
                subject.perform_now(params)
                expect(Rails.logger).to have_received(:error).with(/AutoVerificationJob: ERROR: not removed auth ub_pas/)
                expect(Rails.logger).to have_received(:error).with(/AutoVerificationJob: ERROR: not removed auth ub_pdi/)
              end
            end

            context "when the authorization cannot be created" do
              before do
                # rubocop: disable RSpec/AnyInstance
                allow_any_instance_of(Decidim::AuthorizationHandler).to receive(:invalid?).and_return(true)
                # rubocop: enable RSpec/AnyInstance
              end

              it "writes an error log" do
                subject.perform_now(params)
                expect(Rails.logger).to have_received(:error).with(/AutoVerificationJob: ERROR: not created auth ub_ant/)
                expect(Rails.logger).to have_received(:error).with(/AutoVerificationJob: ERROR: not created auth ub_est/)
                expect(Rails.logger).to have_received(:error).with(/AutoVerificationJob: ERROR: not created auth ub_pex/)
              end
            end
          end

          context "when the roles are removed" do
            let(:roles) { [] }

            it_behaves_like "authorizations for the roles are created or removed", -2
          end

          context "when the role does not exist" do
            let(:roles) { %w(FOO) }

            it_behaves_like "authorizations for the roles are created or removed", -2
          end
        end

        context "when the user does not exist" do
          let(:params) { -1 }

          it_behaves_like "no authorization is created"

          it "writes an error log" do
            subject.perform_now(params)
            expect(Rails.logger).to have_received(:error).with(/AutoVerificationJob: ERROR: model not found for user/)
          end
        end
      end
    end
  end
end
