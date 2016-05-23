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

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var pickerView: UIPickerView!
    @IBOutlet weak var resultLabel: UILabel!
    let currencies = ["BRL", "USD", "EUR", "CAD", "GBP", "GYD", "BAD", "GEL"]
    let service = FCBCurrencyService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func fetchValuesWithBaseCurrency(baseCurrency: String, resultCurrency: String) {
        service.fetchQuoteWithBaseCurrency(baseCurrency, resultCurrency: resultCurrency) { (quote, error) in
            dispatch_async(dispatch_get_main_queue(), {
                if let result = quote {
                    self.resultLabel.text = "\(result.name) \(result.rate)"
                } else if let resultError = error {
                    switch resultError {
                    case .DownloadError :
                        self.resultLabel.text = "Download Error"
                    case .BadData:
                        self.resultLabel.text = "Currency Error"
                    }
                }
            })
        }
    }
}


extension ViewController : UIPickerViewDataSource, UIPickerViewDelegate {
    
    
    // MARK: UIPickerViewDataSource
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 2
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencies.count
    }
    
    
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencies[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        print(pickerView.selectedRowInComponent(0))
        print(pickerView.selectedRowInComponent(1))
        
        let baseCurrency = currencies[pickerView.selectedRowInComponent(0)]
        let resultCurrency = currencies[pickerView.selectedRowInComponent(1)]
        
        fetchValuesWithBaseCurrency(baseCurrency, resultCurrency: resultCurrency)
    }
    
}
    