# frozen_string_literal: true

require "spec_helper"

describe OmniAuth::Strategies::Ub do
  subject do
    described_class.new({}, client_id, client_secret, client_options:).tap do |strategy|
      allow(strategy).to receive_messages(request:, session: [])
    end
  end

  let(:client_id) { "test-client-id" }
  let(:client_secret) { "test-client-secret" }
  let(:client_options) { { site: "https://test.example.org", authorize_url: "/authorize", token_url: "/token" } }
  let(:request) { double("Request", params: {}, cookies: {}, env: {}, scheme: "https", url: "") }

  let(:id) { "314159" }
  let(:nickname) { "mr_john_doe" }
  let(:email) { "john.doe@example.org" }
  let(:name) { "John Doe" }
  let(:roles) { %w(PAS PDI) }

  let(:raw_info) { { employeenumber: [id], cn: [name], mail: [email], uidnet: [nickname], colect2: roles }.stringify_keys }

  describe "client options" do
    it "has correct name" do
      expect(subject.options.name).to eq("ub")
    end

    it "has correct client id" do
      expect(subject.options.client_id).to eq(client_id)
    end

    it "has correct client secret" do
      expect(subject.options.client_secret).to eq(client_secret)
    end

    it "has correct site" do
      expect(subject.options.client_options.site).to eq(client_options[:site])
    end

    it "has correct authorize_url" do
      expect(subject.options.client_options.authorize_url).to eq(client_options[:authorize_url])
    end

    it "has correct token_url" do
      expect(subject.options.client_options.token_url).to eq(client_options[:token_url])
    end
  end

  describe "info" do
    before do
      # rubocop: disable RSpec/SubjectStub
      allow(subject).to receive(:raw_info).and_return(raw_info)
      # rubocop: enable RSpec/SubjectStub
    end

    it "returns the uid" do
      expect(subject.uid).to eq(id)
    end

    it "returns the nickname" do
      expect(subject.info[:nickname]).to eq(nickname)
    end

    it "returns the email" do
      expect(subject.info[:email]).to eq(email)
    end

    it "returns the name" do
      expect(subject.info[:name]).to eq(name)
    end

    it "returns the roles" do
      expect(subject.info[:roles]).to eq(roles)
    end

    context "when the name is invalid" do
      let(:name) { "John+Doe" }

      it "is sanitized" do
        expect(subject.info[:name]).to eq("JohnDoe")
      end
    end

    context "when the nickname is invalid" do
      let(:nickname) { "john.doe" }

      it "is sanitized" do
        expect(subject.info[:nickname]).to eq("john_doe")
      end
    end
  end
end
