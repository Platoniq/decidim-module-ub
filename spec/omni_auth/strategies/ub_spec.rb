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

  let(:full_host) { "https://test.example.org" }
  let(:callback_path) { "/auth/ub/callback" }

  let(:raw_info) { { employeenumber: [id], cn: [name], mail: [email], uidnet: [nickname], colect2: roles }.stringify_keys }
  let(:access_token) { OpenStruct.new(token: "secret-token", response: OpenStruct.new(parsed: OpenStruct.new(token_type: "Bearer"))) }

  before do
    allow_any_instance_of(described_class).to receive(:full_host).and_return(full_host)
    allow_any_instance_of(described_class).to receive(:callback_path).and_return(callback_path)
    allow_any_instance_of(described_class).to receive(:access_token).and_return(access_token)
    stub_request(:get, "https://test.example.org/api/adas/oauth2/tokendata").to_return(status: 200, body: raw_info.to_json)
  end

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

  describe "callback_url" do
    it "returns the full callback url" do
      expect(subject.callback_url).to eq("#{full_host}#{callback_path}")
    end
  end

  describe "info" do
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