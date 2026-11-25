# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # No pending onboarding action for users registered with the UB OAuth method
      "/app/services/decidim/onboarding_manager.rb" => "60265d7020d896d3b7ab89657b6bf982",
      # Show "Universitat de Barcelona" in the OAuth button
      "/app/helpers/decidim/omniauth_helper.rb" => "0eed5497d063eb2fa8bf8b996721e480",
      # Add methods to work with UB identities
      "/app/models/decidim/user.rb" => "2e470cc67129852bc0dd061a57ed754c"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    next unless spec

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{Gem::Specification.find_by_name(item[:package]).gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
