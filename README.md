# Merchantprotector for Ruby / Stripe apps

SUPER IMPORTANT NOTE: This gem is under heavy development!

<!-- RemoveNext -->
Merchant Protector protectos online stores against fraud. The Merchant Protector ruby gem works with Stripe to gather fraud screening attributes for extended screening. More details at (https://www.merchantprotector.net).

<!-- Sub:[TOC] -->

## Installation

Add this line to your application's Gemfile:

    gem 'merchantprotector'

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install merchantprotector
```

### Then configure the gem


Create the file ```config/initializers/merchantprotector.rb``` to hold the configuration values (currently just your access token).  If you want your Merchant Protector API key outside of your repo (recommended!) use an environment variable:

```bash
Merchantprotector.configure do |config|
  config.api_token = ENV['MERCHANTPROTECTOR_API_TOKEN']
end
```

Heroku users can set the environment variable using the heroku CLI

```bash
$ heroku config:add MERCHANTPROTECTOR_API_TOKEN=YOUR_API_TOKEN
```

That's all you need to use Merchant Protector with Rails and Stripe.


### Finally, use the gem to report your orders

Add this line to the controller method that creates a charge with Stripe
```ruby
Merchantprotector.report_transaction($STRIPE_CHARGE_ID, request)
```
Here it is in a sample controller:
```ruby
class ChargesController < ApplicationController
  require 'pp'
  def index
    @charges = Charge.order('created_at DESC').limit(25)
  end 

  def new
    @charge = Charge.new
  end

  def create
      stripe_charge = Stripe::Charge.create(
        :amount => 2000,
        :currency => "usd",
        :card => params[:stripeToken],
        :description => params[:stripeEmail]
      )

      Merchantprotector.report_transaction(stripe_charge.id, request)

      redirect_to charges_path, notice: 'Thank You'

  end
end
```

## Help / Support

If you run into any issues, please email us at [will@merchantprotector.net](mailto:will@merchantprotector.net)


For bug reports, please [open an issue on GitHub](https://github.com/wronco/merchantprotector-gem/issues/new).

## Contributing

1. Fork it
2. Create your feature branch (```git checkout -b my-new-feature```).
3. Commit your changes (```git commit -am 'Added some feature'```)
4. Push to the branch (```git push origin my-new-feature```)
5. Create new Pull Request

We're using RSpec for testing. Run the test suite with ```rake spec```. Tests for pull requests are appreciated but not required. (If you don't include a test, we'll write one before merging.)

## Thank You
Thank you to the fine folks at [Rollbar](https://rollbar.com), whose beautifully documented gem is the basis for this one.
