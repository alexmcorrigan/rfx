Feature: Request rate from Yahoo
    In order to convert money amounts from one currency to another
    As a someone to convert currencies
    I want to get the latest exchange rate for the conversion

    Scenario: Request rate for valid currency pair
        Given 50 GBP
        And I want to convert to USD
        When I request exchange rate for these two currencies
        Then I receive a valid decimal exchange rate
