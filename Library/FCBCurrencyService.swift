/*
 The MIT License (MIT)
 
 Copyright (c) 2016 Fernando Bunn
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import Foundation

enum FCBCurrencyServiceError {
    case DownloadError
    case BadData
}

struct FCBCurrencyService {
    
    
    // MARK: Public Methods
    
    func fetchQuoteWithBaseCurrency(baseCurrency: String, resultCurrency: String, completion: (quote: FCBQuote?, error: FCBCurrencyServiceError?) -> Void) {
        let baseURL = "https://query.yahooapis.com/v1/public/yql"
        let env = "store://datatables.org/alltableswithkeys"
        let format = "json"
        let currency = "\(baseCurrency)\(resultCurrency)=x"
        let query = "select * from yahoo.finance.quotes where symbol in (\"\(currency)\")"
        
        guard let urlComponents = NSURLComponents(string: baseURL) else {
            completion(quote: nil, error: .BadData)
            return
        }
        
        urlComponents.queryItems = [
            NSURLQueryItem(name: "q", value: query),
            NSURLQueryItem(name: "env", value: env),
            NSURLQueryItem(name: "format", value: format)
        ]
        
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithURL(urlComponents.URL!, completionHandler: {(dataResponse, reponse, error) in
            guard error == nil, let data = dataResponse else {
                completion(quote: nil, error: .DownloadError)
                return
            }

            let jsonData = try? NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments) as! NSDictionary
            guard let quoteDictionary = self.dictionaryValue(jsonData, keys: ["query", "results", "quote"]),
                let quote = FCBQuote(dictionary: quoteDictionary) else {
                    completion(quote: nil, error: .BadData)
                    return
            }
            completion(quote: quote, error: nil)
        })
        task.resume()
    }
    
    
    // MARK: Private Methods
    
    private func dictionaryValue(dic: NSDictionary?, keys: [String]) -> NSDictionary? {
        guard var dictionary = dic else { return nil }
        for key in keys {
            if let newValue = dictionary[key] as? NSDictionary {
                dictionary = newValue
            } else {
                return nil
            }
        }
        return dictionary
    }
}