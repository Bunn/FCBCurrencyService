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
    case downloadError
    case badData
}

struct FCBCurrencyService {
    
    
    // MARK: Public Methods
    
    func fetchQuoteWithBaseCurrency(_ baseCurrency: String, resultCurrency: String, completion: @escaping (_ quote: FCBQuote?, _ error: FCBCurrencyServiceError?) -> Void) {
        let baseURL = "https://query.yahooapis.com/v1/public/yql"
        let env = "store://datatables.org/alltableswithkeys"
        let format = "json"
        let currency = "\(baseCurrency)\(resultCurrency)=x"
        let query = "select * from yahoo.finance.quotes where symbol in (\"\(currency)\")"
        
        guard var urlComponents = URLComponents(string: baseURL) else {
            completion(nil, .badData)
            return
        }
        
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "env", value: env),
            URLQueryItem(name: "format", value: format)
        ]
        
        let session = URLSession.shared

        session.dataTask(with: urlComponents.url!, completionHandler: {(dataResponse, reponse, error) in
            guard error == nil, let data = dataResponse else {
                completion(nil, .downloadError)
                return
            }
            
            if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                guard let query = json?["query"] as? [String : Any],
                    let results = query["results"] as? [String : Any],
                    let quoteDictionary = results["quote"] as? [String :Any] else {
                        completion(nil, .badData)
                        return
                }
                
                do {
                    let quote = try FCBQuote(json: quoteDictionary)
                    completion(quote,nil)
                } catch {
                    print(error)
                    completion(nil, .badData)
                }
            } else {
                completion(nil, .badData)
            }
        }).resume()
    }
}



