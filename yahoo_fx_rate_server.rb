require 'net/http'
require 'rexml/document'

class YahooFXServer

    def initialize
        now = Time.now
        timestamp = now.strftime("%Y%m%d-%H%M%S")
        FileUtils.mkdir_p './logs/'
        file = File.open("./logs/YahooFXServer-#{timestamp}.log", File::WRONLY | File::APPEND | File::CREAT)
        @log = Logger.new(file)
        @log.level = Logger::INFO
        @yqlHost = 'http://query.yahooapis.com/v1/public/'
        load_currency_data
    end

    def fetchFor base_currency_code, quote_currency_code
        if fails_validation(base_currency_code, quote_currency_code)
            @log.info "Failed validation, will not request exchange rate."
            return @error.join("\n")
        end
        get_request = URI(@yqlHost + create_query_for_currency_pair(base_currency_code, quote_currency_code))
        execute_request(get_request)
        extract_rate(@body)
    end

    private

    def create_query_for_currency_pair base_currency_code, quote_currency_code
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

    def fails_validation base_currency_code, quote_currency_code
        @error = Array.new
        if currency_code_wrong_length(base_currency_code, quote_currency_code)
            return true
        end
        if currency_code_not_known(base_currency_code, quote_currency_code)
            return true
        end
        return false
    end

    def currency_code_wrong_length base_currency_code, quote_currency_code
        @log.info "Validating currency code lengths"
        did_fail = false
        if base_currency_code.length != 3
            message = "Base currency code '#{base_currency_code}' invalid, must be 3 characters"
            @log.info message
            @error.push(message)
            did_fail = true
        end
        if quote_currency_code.length != 3
            message = "Quote currency code '#{quote_currency_code}' invalid, must be 3 characters"
            @log.info message
            @error.push(message)
            did_fail = true
        end
        did_fail
    end

    def load_currency_data
        @currencies = Hash.new
        doc = REXML::Document.new File.open("./resources/currencies.xml")
        doc.elements.each("currencies/currency") { | currency | @currencies[currency.attributes['code']] = currency.attributes['name'] }
    end

    def currency_code_not_known(base_currency_code, quote_currency_code)
        did_fail = false
        if @currencies.fetch(base_currency_code, nil) == nil
            message = "Base currency code '#{base_currency_code}' not recognised"
            @log.info message
            @error.push(message)
            did_fail = true
        end
        if @currencies.fetch(quote_currency_code, nil) == nil
            message = "Quote currency code '#{quote_currency_code}' not recognised"
            @log.info message
            @error.push(message)
            did_fail = true
        end
        did_fail
    end

end
