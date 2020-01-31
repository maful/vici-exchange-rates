# Vici::ExchangeRates

> A Simple and Rich for Exchange Rates

![CI](https://github.com/maful/vici-exchange-rates/workflows/CI/badge.svg?branch=master)
[![Gem Version](https://badge.fury.io/rb/vici-exchange-rates.svg)](https://badge.fury.io/rb/vici-exchange-rates)
[![GitHub license](https://img.shields.io/github/license/maful/vici-exchange-rates)](https://github.com/maful/vici-exchange-rates/blob/master/LICENSE.txt)

**Vici::ExchangeRates** is an unofficial SDK for the [ExchangeRatesAPI](https://exchangeratesapi.io). Exchange rates API is a free service for current and historical foreign exchange rates [published by the European Central Bank](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html).

### Note
- This app requires JSON. If you're using JRuby < 1.7.0
  you'll need to add `gem "json"` to your Gemfile or similar.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'vici-exchange-rates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install vici-exchange-rates

## Usage

Currency code must be one of the [supported currency codes](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html).

**Basic usage**

```ruby
require 'vici/exchange_rates'

rates = Vici::ExchangeRates.new
# or you can retrieve JSON response
rates = Vici::ExchangeRates.new(true) 
rates.fetch
```

**Historical rates for any day since 1999**

```ruby
rates.at_date('2018-02-02')
rates.fetch
# OR
rates.at_date('2018-02-02').fetch 
```

**Latest exchange rates with different base currency (Euro by default)**

```ruby
rates.base_currency('IDR')
rates.fetch 
```

**Specific exchange rates**

```ruby
rates.rates('IDR')

# multi exchange rates
rates.rates(['IDR', 'USD']) 
rates.fetch 
# => {"rates"=>{"USD"=>1.1052, "IDR"=>15091.51}, "base"=>"EUR", "date"=>"2020-01-31"}
```

**Historical rates for a time period**

```ruby
rates.period(date_from: '2018-01-03', date_to: '2018-02-05') 
rates.fetch 
```

**Limit to specific exchange rates**

```ruby
rates.rates(['IDR', 'JPY']).period(date_from: '2018-01-03', date_to: '2018-02-05') 
rates.fetch 
```

**Historical rates with different currency**

```ruby
rates.base_currency('JPY').period(date_from: '2018-01-03', date_to: '2018-02-05') 
rates.fetch
```

## Supported Currencies

The library supports any currency currently available on the European Central Bank's web service, please refer to [here](https://www.ecb.europa.eu/stats/policy_and_exchange_rates/euro_reference_exchange_rates/html/index.en.html).

## Contributing

1. Fork [the repo](https://github.com/maful/vici-exchange-rates)
2. Grab dependencies: `bundle install`
3. Make sure everything is working: `bundle exec rake spec`
4. Make your changes
5. Test your changes
5. Create a Pull Request
6. Celebrate!!!!!

This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## Copyright

Copyright (c) 2020 Maful Prayoga A. See LICENSE for further details.
