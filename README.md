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

Then, run the following command from your rails root:

```bash
$ rails generate merchantprotector API_TOKEN
```

<!-- RemoveNextIfProject -->
Be sure to replace ```API_TOKEN``` with your project's ```api_token``` access token, which you can find on your merchantprotector.net seetings page.


That will create the file ```config/initializers/merchantprotector.rb```, which holds the configuration values (currently just your access token).

If you want to store your access token outside of your repo, run the same command without arguments:

```bash
$ rails generate merchantprotector
```

Then, create an environment variable ```MERCHANTPROTECTOR_API_TOKEN``` and set it to your server-side access token.

```bash
$ export MERCHANTPROTECTOR_API_TOKEN=API_TOKEN
```

### For Heroku users

```bash
$ heroku config:add MERCHANTPROTECTOR_API_TOKEN=API_TOKEN
```

That's all you need to use Merchant Protector with Rails and Stripe.

## Test your installation

To confirm that it worked, run:

```bash
$ rake merchantprotector:test
```

This will submit a test order to Merchant Protector. If it works, you'll see a notice in the console and a test order will appear in your dashboard.



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