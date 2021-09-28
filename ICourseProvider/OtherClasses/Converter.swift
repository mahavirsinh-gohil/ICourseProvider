//
//  Converter.swift
//  ICourseProvider
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/09/21.
//

import Foundation
class Converter {
    static var shared = Converter()
    
    func convertToUSD(_ euro: Double, rate: Double) -> Double {
        return euro * rate
    }
    
    func convertToEUR(_ usd: Double, rate: Double) -> Double {
        return usd * rate
    }
}
