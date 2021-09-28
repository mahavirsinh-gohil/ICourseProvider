//
//  ConverterWrapper.swift
//  ICourseProvider
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/09/21.
//

import Foundation
class ConverterWrapper {
    static var shared  = ConverterWrapper()
    
    func getEURAmount(usd: Double) -> String {
        if usd < 0 {
            return "0"
        }
        let usdToEurRate = UserDefaults.standard.double(forKey: "eurExRate")
        return Converter.shared.convertToUSD(usd, rate: usdToEurRate).formatted()
    }
    
    func getUSDAmount(eur: Double) -> String {
        if eur < 0 {
            return "0"
        }
        let usdToEurRate = UserDefaults.standard.double(forKey: "eurExRate")
        return Converter.shared.convertToUSD(eur, rate: 1 / usdToEurRate).formatted()
    }
}
