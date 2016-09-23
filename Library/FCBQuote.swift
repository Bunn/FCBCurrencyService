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

struct FCBQuote {
    var name: String
    var yearHigh: String
    var yearLow: String
    var rate: String
}

enum SerializationError: Error {
    case missing(String)
}

extension FCBQuote {
    init(json: [String: Any]) throws {
        
        guard let name = json["Name"] as? String else {
            throw SerializationError.missing("Name")
        }
        
        guard let rate = json["Bid"] as? String else {
            throw SerializationError.missing("Bid")
        }
        
        guard let yearHigh = json["YearHigh"] as? String else {
            throw SerializationError.missing("YearHigh")
        }
        
        guard let yearLow = json["YearLow"] as? String else {
            throw SerializationError.missing("YearLow")
        }
    
        self.name = name
        self.rate = rate
        self.yearLow = yearLow
        self.yearHigh = yearHigh
    }
}

/*
ASK AND BID
The Ask price is what sellers are willing to take for it.
If you are selling a stock, you are going to get the Bid price, if you are buying a stock you are going to get the ask price.
*/
