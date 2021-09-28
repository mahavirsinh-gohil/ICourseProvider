//
//  ICourseProviderTests.swift
//  ICourseProviderTests
//
//  Created by Yudiz Solutions Pvt. Ltd. on 28/09/21.
//

import XCTest
@testable import ICourseProvider

class ICourseProviderTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testConversationRate() throws {
        let conversationRate = UserDefaults.standard.double(forKey: "eurExRate")
        XCTAssertNotNil(conversationRate)
    }
    
    func testPositiveInput() throws {
        let eurAmount = ConverterWrapper.shared.getEURAmount(usd: -100)
        XCTAssertEqual(eurAmount, "0")
        
        let usdAmount = ConverterWrapper.shared.getUSDAmiunt(eur: -100)
        XCTAssertEqual(usdAmount, "0")
    }

}
