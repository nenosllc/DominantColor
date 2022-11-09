//
//  DominantColorTests.swift
//  DominantColorTests
//
//  Created by Sam Spencer on 11/9/22.
//

@testable import DominantColor
import XCTest

final class DominantColorTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
    }

    func testPerformanceExample() throws {
        let image = UIImage(named: "testimage.jpg", in: Bundle.module, compatibleWith: .current)
        XCTAssertNotNil(image)
        
        measure {
            let exp = expectation(description: "Finished")
            Task {
                let colors = await image!.dominantColors()
                XCTAssertGreaterThan(colors.count, 0)
                exp.fulfill()
            }
            wait(for: [exp], timeout: 200.0)
        }
    }

}
