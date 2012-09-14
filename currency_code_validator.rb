require 'rexml/document'

class CurrencyCodeValidator

    def initialize
        @currencies = load_currency_data
    end

    def validate currency
        @errors = []
        @currency_code = currency.code
        @currency_code_field_name = currency.field_name
        if !code_length_is_valid: return @errors end
        if !code_is_real: return @errors end
        @errors
    end

# --------------------------------------------------
    private
# --------------------------------------------------

    def code_length_is_valid
        if @currency_code.length != 3
            message = "#{@currency_code_field_name} currency code '#{@currency_code}' invalid, must be 3 characters"
            @errors << message
            return false
        end
        true
    end

    def code_is_real
        if @currencies.fetch(@currency_code, nil) == nil
            message = "#{@currency_code_field_name} currency code '#{@currency_code}' not recognised"
            @errors << message
            return false
        end
        true
    end

    def load_currency_data
        currencies = Hash.new
        doc = REXML::Document.new File.open("./resources/currencies.xml")
        doc.elements.each("currencies/currency") { | currency | currencies[currency.attributes['code']] = currency.attributes['name'] }
        currencies
    end

end
