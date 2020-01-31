require 'active_support/core_ext/object'
require 'faraday'
require 'json'

require 'vici/exchange_rates/version'

module Vici
  class ExchangeRates
    class Error < StandardError; end

    BASE_URI = 'https://api.exchangeratesapi.io'.freeze
    CURRENCIES = %w[USD GBP EUR JPY BGN CZK DKK HUF PLN RON SEK CHF ISK NOK HRK RUB TRY AUD BRL CAD CNY HKD IDR ILS INR KRW MXN MYR NZD BHP SGD THB ZAR].freeze
    CURRENCY_REGEX = /^[A-Z]{3}$/.freeze
    DATE_REGEX = /^[0-9]{4}-(0[1-9]|1[0-2])-(0[1-9]|[1-2][0-9]|3[0-1])$/.freeze

    def initialize(json = false)
      @client = Faraday.new BASE_URI
      @options = {}
      @endpoint = 'latest'
      @rates = []
      @date = nil
      @date_from = nil
      @date_to = nil
      @base = nil
      @return_json = json
    end

    def base_currency(code)
      currency_code = sanitize_curreny_code(code)
      verify_currency_code(currency_code)
      @base = code
      self
    end

    def at_date(date)
      @date = validate_date(date)
      self
    end

    def rates(currencies)
      if currencies.is_a?(Array)
        currencies.each do |currency|
          currency_code = sanitize_curreny_code(currency)

          verify_currency_code(currency_code)

          @rates << currency_code
        end
      else
        currency_code = sanitize_curreny_code(currencies)

        verify_currency_code(currency_code)

        @rates << currency_code
      end
      self
    end

    def period(date_from:, date_to:)
      @date_from = validate_date(date_from)
      @date_to = validate_date(date_to)
      self
    end

    def fetch
      if @date_from.present? && @date_to.present?
        @endpoint = 'history'
        @options.merge!(start_at: @date_from, end_at: @date_to)
      elsif @date.present?
        @endpoint = @date
      else
        @endpoint
      end

      @options['base'] = @base if @base.present?

      @options['symbols'] = @rates.join(',') if @rates.length.positive?

      request = @client.get(@endpoint, @options)
      response = JSON.parse(request.body)

      if @return_json
        JSON.generate(response)
      else
        response
      end
    end

    private

    def verify_currency_code(code)
      currency_code = sanitize_curreny_code(code)

      unless currency_valid?(currency_code)
        raise 'The specified currency code is invalid. Please use ISO 4217 notation (e.g. IDR).'
      end

      unless currency_supported?(currency_code)
        raise 'The specified currency code is not currently supported.'
      end
    end

    def currency_valid?(code)
      if code.present?
        return false if code.length != 3

        return false unless CURRENCY_REGEX.match?(code)

        return true
      end
      false
    end

    def currency_supported?(code)
      CURRENCIES.include?(code)
    end

    def validate_date(date)
      unless date_valid?(date)
        raise ArgumentError, 'The specified date is invalid. Please use ISO 8601 notation (e.g. YYYY-MM-DD).'
      end

      date
    end

    def date_valid?(date)
      return DATE_REGEX.match?(date) if date.present?

      false
    end

    def sanitize_curreny_code(code)
      code.strip.upcase
    end
  end
end
