#!/usr/bin/ruby
require 'yahoo_fx_rate_server'
require 'currency'

begin
    raise ArgumentError, 'Require three arguments -amount_to_convert, -base_currency_code, -quote_currency_code' if ARGV.size != 3
    amount_to_convert = ARGV[0].to_f
    base_currency = Currency.new("Base",ARGV[1])
    quote_currency = Currency.new("Quote",ARGV[2])
    fx_server = YahooFXServer.new
    rate = fx_server.fetch_for base_currency, quote_currency
    conversion = amount_to_convert * rate
    p "Rate of conversion is #{rate}."
    p "%.2f #{base_currency.code} is equivalent to %.2f #{quote_currency.code}." % [amount_to_convert, conversion]
rescue => e
    p e.message
end
