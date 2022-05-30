//
//  RegistrUITestsLaunchTests.swift
//  RegistrUITests
//
//  Created by Christoffer Detlef on 06/05/2022.
//

import XCTest

class UILaunchTests: XCTestCase {
  func testLaunchPerformance() {
    if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
      measure(metrics: [XCTApplicationLaunchMetric()]) {
          let app = XCUIApplication()
          app.launch()
      }
    }
  }
    
    func testLaunchLoggedInPerformance() {
      if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            let app = XCUIApplication()
            app.launch()
            
            let childName = expectation(description: "Delay for 5 sec")
            if app.staticTexts["Emma Hansen"].exists {
                childName.fulfill()
            }
            _ = XCTWaiter.wait(for: [childName], timeout: 5)
        }
      }
    }
}
