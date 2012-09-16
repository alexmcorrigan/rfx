require 'rubygems'
require 'json'
require 'net/http'
require 'currency_code_validator'

class YahooFXServer

    def initialize
        @yqlHost = 'http://query.yahooapis.com/v1/public/'
        @currency_code_validator = CurrencyCodeValidator.new
    end

    def fetch_for base_currency, quote_currency
        perform_validation_on base_currency
        perform_validation_on quote_currency
        get_request = URI(@yqlHost + create_query_for_currency_pair(base_currency.code, quote_currency.code))
        execute_request(get_request)
        return extract_rate(@body)
    end

# ---------------------------------------------------------------------
    private
# ---------------------------------------------------------------------

    def create_query_for_currency_pair(base_currency_code, quote_currency_code)
        "yql?q=select%20*%20from%20yahoo.finance.xchange%20where%20pair%20%3D%20%22#{base_currency_code}#{quote_currency_code}%22&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys&callback="
    end

    def extract_rate(body)
        body['query']['results']['rate']['Rate'].to_f
    end

    def execute_request get_request
        Net::HTTP.start(get_request.host, get_request.port) do | http |
            response = http.request(Net::HTTP::Get.new(get_request.request_uri))
            @body = JSON.parse(response.body)
        end
    end

    def perform_validation_on currency
        currency.validate(@currency_code_validator)
    end

end

