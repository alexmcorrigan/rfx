Feature: Invalid Currency Pair Requests

    Scenario Outline: Request rate for invalid currency pair
        Given a base currency <base_currency_code>
            And a quote currency <quote_currency_code>
        When I request exchange rate for these two currencies
        Then "<error_message>" is returned

        Examples:
        | base_currency_code    | quote_currency_code   | error_message                                             |
        | G                     | USD                   | Base currency code 'G' invalid, must be 3 characters      |
        | GBPX                  | USD                   | Base currency code 'GBPX' invalid, must be 3 characters   |
        | GBP                   | U                     | Quote currency code 'U' invalid, must be 3 characters     |
        | GBP                   | USDX                  | Quote currency code 'USDX' invalid, must be 3 characters  |
        | ABC                   | USD                   | Base currency code 'ABC' not recognised                   |
        | GBP                   | ABC                   | Quote currency code 'ABC' not recognised                  |
