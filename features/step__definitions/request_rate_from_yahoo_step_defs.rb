require 'yahoo_fx_rate_server'

Before do
    @fxServer = YahooFXServer.new
end

Given /^(\d+) (.+)$/ do | @amount_to_convert, @base_currency_code | end
Given /^I want to convert to (.+)$/ do | @quote_currency_code | end
Given /^a base currency (.+)$/ do | @base_currency_code | end
Given /^a quote currency (.+)$/ do | @quote_currency_code | end

When /^I request exchange rate for these two currencies$/ do
    @rate = @fxServer.fetchFor @base_currency_code, @quote_currency_code
end

Then /^I receive a valid decimal exchange rate$/ do
    @rate.should be > 0
    @rate.class.should be Float
end

Then /^"(.+)" is returned$/ do | expected_error_message |
    @rate.should eq(expected_error_message)
end
