# frozen_string_literal: true

source "https://rubygems.org"

ruby RUBY_VERSION

DECIDIM_VERSION = "~> 0.28.0"

gem "decidim", DECIDIM_VERSION
gem "decidim-ub", path: "."

gem "bootsnap", "~> 1.4"

gem "puma", ">= 6.3.1"

group :development, :test do
  gem "byebug", "~> 11.0", platform: :mri
  gem "mdl"

  gem "decidim-dev", DECIDIM_VERSION
end

group :development do
  gem "faker", "~> 3.2"
  gem "letter_opener_web", "~> 2.0"
  gem "listen", "~> 3.1"
  gem "rack-mini-profiler", require: false
  gem "spring", "~> 2.0"
  gem "spring-watcher-listen", "~> 2.0"
  gem "web-console", "~> 4.2"
end
