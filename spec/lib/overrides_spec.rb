# frozen_string_literal: true

require "spec_helper"

# We make sure that the checksum of the file overridden is the same
# as the expected. If this test fails, it means that the overridden
# file should be updated to match any change/bug fix introduced in the core
checksums = [
  {
    package: "decidim-core",
    files: {
      # Do not show first_login page if the user has registered with the UB OAuth method
      "/app/controllers/concerns/decidim/devise_authentication_methods.rb" => "9d4bd40211243cca819e83bb2344972c",
      # Show "Universitat de Barcelona" in the OAuth button
      "/app/helpers/decidim/omniauth_helper.rb" => "5c310ce2f67a173e802c8cb5c0918f31",
      # Add methods to work with UB identities
      "/app/models/decidim/user.rb" => "81da9f2f82f6336a92b948d827bd0fb3"
    }
  }
]

describe "Overridden files", type: :view do
  checksums.each do |item|
    spec = Gem::Specification.find_by_name(item[:package])
    next unless spec

    item[:files].each do |file, signature|
      it "#{spec.gem_dir}#{file} matches checksum" do
        expect(md5("#{spec.gem_dir}#{file}")).to eq(signature)
      end
    end
  end

  private

  def md5(file)
    Digest::MD5.hexdigest(File.read(file))
  end
end
