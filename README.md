# Decidim::Ub

A Decidim module to sync users from Universitat de Barcelona who connect to the platform.

## Installation

Add this line to your application's Gemfile:

```ruby
gem "decidim-ub", git: "https://github.com/Platoniq/decidim-module-ub"
```

And then execute:

```bash
bundle
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

## Contributing

Contributions are welcome !

We expect the contributions to follow the [Decidim's contribution guide](https://github.com/decidim/decidim/blob/develop/CONTRIBUTING.adoc).

## Security

Security is very important to us. If you have any issue regarding security, please disclose the information responsibly by sending an email to __francisco.bolivar [at] nazaries [dot] com__ and not by creating a Github issue.

## License

This engine is distributed under the GNU AFFERO GENERAL PUBLIC LICENSE.
