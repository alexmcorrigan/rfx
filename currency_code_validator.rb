require 'rexml/document'

class CurrencyCodeValidator

    def initialize
        @currencies = load_currency_data
    end

    def validate currency
        currency_code = currency.code
        currency_code_field_name = currency.field_name
        raise BadCurrencyCodeException, "#{currency_code_field_name} currency code '#{currency_code}' invalid, must be 3 characters" if currency_code.length != 3
        raise BadCurrencyCodeException, "#{currency_code_field_name} currency code '#{currency_code}' not recognised" if @currencies.fetch(currency_code, nil) == nil
    end

# --------------------------------------------------
    private
# --------------------------------------------------

    def load_currency_data
        currencies = Hash.new
        doc = REXML::Document.new File.open("./resources/currencies.xml")
        doc.elements.each("currencies/currency") { | currency | currencies[currency.attributes['code']] = currency.attributes['name'] }
        currencies
    end

end

class BadCurrencyCodeException < StandardError; end
