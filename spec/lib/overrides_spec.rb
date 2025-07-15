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
      "/app/controllers/concerns/decidim/devise_authentication_methods.rb" => "4135a9244830bab55b50434938482c3c",
      # Show "Universitat de Barcelona" in the OAuth button
      "/app/helpers/decidim/omniauth_helper.rb" => "e5c0f3ebb052f76dc50c4db8a2548686",
      # Add methods to work with UB identities
      "/app/models/decidim/user.rb" => "8565f4239eaf94212d05501eed46d08f"
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
