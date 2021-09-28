//
//  ICourseProviderVC.swift
//  ICourseProvider
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/09/21.
//

import Foundation
import UIKit
class ICourseProviderVC: UIViewController {
    
    ///Oultale(S)
    @IBOutlet weak var lblEcRate: UILabel!
    @IBOutlet weak var txtUSD: UITextField!
    @IBOutlet weak var txtEUR: UITextField!
    
    ///Variables
    let exRateAPI = "https://v6.exchangerate-api.com/v6/c386e7789e435b76eab1c036/latest/USD"
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareUI()
    }
}

//MARK:- UI Related Methode(s)
extension ICourseProviderVC {
    func prepareUI() {
        guard let toUpdate = defaults.string(forKey: "time_next_update_utc") else {
            getExchangeRates()
            return
        }
        let eurRate = defaults.double(forKey: "eurExRate")
        
        switch Date().compare(stringWith(dateFormate: "E, d MMM yyyy HH:mm:ss Z", fromDate: toUpdate)) {
        case .orderedDescending:
            getExchangeRates()
            break
        default:
            txtUSD.text = "1"
            txtEUR.text = eurRate.formatted()
            lblEcRate.text = "\(eurRate.formatted()) Euro"
            break
        }
    }
    
    // supporting functions
    func stringWith(dateFormate format: String, fromDate date: String, abbreviation: String? = nil) -> Foundation.Date! {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US")
        if let abbreviation = abbreviation, !abbreviation.isEmpty {
            formatter.timeZone = TimeZone(abbreviation: abbreviation)
        }else{
            formatter.timeZone = TimeZone(secondsFromGMT: 0)
        }
        return formatter.date(from: date)!
    }
}

//MARK:- Action Related Methode(s)
extension ICourseProviderVC {
    @IBAction func editingChanged(_ sender: UITextField) {
        guard let amt = sender.text, let curr = Double(amt) else { return }
        if sender == txtUSD {
            txtEUR.text = ConverterWrapper.shared.getEURAmount(usd: curr)
        } else {
            txtUSD.text = ConverterWrapper.shared.getUSDAmount(eur: curr)
        }
    }
}

//MARK:- API Related Methode(s)
extension ICourseProviderVC {
    func getExchangeRates() {
        guard let exRateURL = URL(string: exRateAPI) else {
            return
        }
        
        let task =  URLSession.shared.dataTask(with: exRateURL) { [weak self] data, response, error in
            guard let weakSelf = self else { return }
            
            if error == nil, let httpResponse = response as? HTTPURLResponse {
                guard httpResponse.statusCode == 200, let someData = data else {
                    return
                }
                
                do {
                    guard let dict = try JSONSerialization.jsonObject(with: someData, options: []) as? [String: Any],
                          let conversationRatesDict = dict["conversion_rates"] as? [String: Double],
                          let eurRate = conversationRatesDict["EUR"],
                          let time_next_update = dict["time_next_update_utc"] else { return }
                    
                    weakSelf.defaults.set(time_next_update, forKey: "time_next_update_utc")
                    weakSelf.defaults.set(eurRate, forKey: "eurExRate")
                    
                    DispatchQueue.main.async {
                        weakSelf.lblEcRate.text = "\(eurRate.formatted()) Euro"
                        weakSelf.txtUSD.text = "1"
                        weakSelf.txtEUR.text = eurRate.formatted()
                    }
                    
                } catch {
                    
                }
                
            }
        }
        task.resume()
    }
}

extension Double {
    func formatted() -> String {
        return String(format: "%.02f", self)
    }
}
