# FCBCurrencyService
Simple Swift currency converter using Yahoo Query Language (YQL).

### Installation
Simply drag the `Library` folder to your project.

### How to use
Use the `fetchQuoteWithBaseCurrency` method to pass the currency symbol you want to convert and the conversion result currency symbol.
If the method succeeds, it will return an `FCBQuote` optional.

If there's some connection issue, the block will return an error as `DownloadError`, or in case the currency is invalid or Yahoo can't figure it out the value, it will return `BadData` error.

``` swift
        let currencyService = FCBCurrencyService()
        currencyService.fetchQuoteWithBaseCurrency("USD", resultCurrency: "CAD") { (quote, error) in
            if let result = quote {
                print("Currency: \(result.name) value: \(result.rate)")
            } else if let resultError = error {
                switch resultError {
                case .DownloadError :
                    print("Downlaod error")
                case .BadData:
                    print("Invalid Currency")
                }
            }
        }
```
Output `Currency: USD/CAD value: 1.3111`

See `Example` project for more samples.

## Screenshots
![FCBCurrencyService](/Screenshot/screenshot.png?raw=true "FCBCurrencyService")

### License
FCBCurrencyService is released under the MIT license. See the LICENSE file for more info.
