# frozen_string_literal: true

require "decidim/dev/common_rake"
require "fileutils"

def install_initializer(path, env)
  Dir.chdir(path) do
    FileUtils.cp(
      "#{__dir__}/lib/generators/app_templates/#{env}/initializer.rb",
      "config/initializers/decidim_ub_config.rb"
    )
  end
end

def seed_db(path)
  Dir.chdir(path) do
    system("bundle exec rake db:seed")
  end
end

desc "Generates a dummy app for testing"
task test_app: "decidim:generate_external_test_app" do
  ENV["RAILS_ENV"] = "test"
  install_initializer("spec/decidim_dummy_app", "test")
end

desc "Generates a development app."
task development_app: "decidim:generate_external_development_app"
