# Decidim::Ub

[![Gem Version](https://img.shields.io/gem/v/decidim-ub.svg)](https://badge.fury.io/rb/decidim-ub)
[![[CI] Lint](https://github.com/Platoniq/decidim-module-ub/actions/workflows/lint.yml/badge.svg)](https://github.com/Platoniq/decidim-module-ub/actions/workflows/lint.yml)
[![[CI] Test](https://github.com/Platoniq/decidim-module-ub/actions/workflows/test.yml/badge.svg)](https://github.com/Platoniq/decidim-module-ub/actions/workflows/test.yml)
[![Maintainability](https://api.codeclimate.com/v1/badges/c975a347c58389448503/maintainability)](https://codeclimate.com/github/Platoniq/decidim-module-ub/maintainability)
[![Coverage Status](https://coveralls.io/repos/github/Platoniq/decidim-module-ub/badge.svg?branch=main)](https://coveralls.io/github/Platoniq/decidim-module-ub?branch=main)

A Decidim module to sync users from Universitat de Barcelona who connect to the platform.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-ub"
```

And then execute:

```bash
bundle
bundle exec rails decidim_ub:install:migrations
bundle exec rails db:migrate
```

## Configuration

You need to configure some environment variables for the OAuth client:

| ENV              | Description                               | Example                     | Default                    |
|------------------|-------------------------------------------|-----------------------------|----------------------------|
| UB_CLIENT_ID     | The OAuth2 client ID                      | `your-client-id`            |                            |
| UB_CLIENT_SECRET | The OAuth2 client secret                  | `your-client-secret`        |                            |
| UB_SITE          | The OAuth2 site                           | `https://example.org/oauth` |                            |
| UB_AUTHORIZE_URL | The path for the authorization URL        | `/authorize`                |                            |
| UB_TOKEN_URL     | The path for the token URL                | `/token`                    |                            |
| UB_ICON          | The path for the icon shown in the button | `media/images/my_icon.svg`  | `media/images/ub_logo.svg` |

If you set the variables you don't see the OAuth button in the organization, you will need to create an initializer to configure this module. Just create a file in `config/initializers/decidim_ub.rb` with the content below:

```ruby
Decidim::Ub.configure do |config|
  config.omniauth = {
    enabled: ENV["UB_CLIENT_ID"].present?,
    icon_path: ENV.fetch("UB_ICON", "media/images/ub_logo.svg"),
    client_id: ENV["UB_CLIENT_ID"].presence,
    client_secret: ENV["UB_CLIENT_SECRET"].presence,
    site: ENV["UB_SITE"].presence,
    authorize_url: ENV["UB_AUTHORIZE_URL"].presence,
    token_url: ENV["UB_TOKEN_URL"].presence
  }
end
```

## Contributing

Contributions are welcome !

We expect the contributions to follow the [Decidim's contribution guide](https://github.com/decidim/decidim/blob/develop/CONTRIBUTING.adoc).

## Security

Security is very important to us. If you have any issue regarding security, please disclose the information responsibly by sending an email to __francisco.bolivar [at] nazaries [dot] com__ and not by creating a Github issue.

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
