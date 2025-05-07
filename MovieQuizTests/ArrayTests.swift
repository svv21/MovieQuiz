//
//  ArrayTests.swift
//  MovieQuizTests
//
//  Created by Vladislava Scherbo on 1.05.25.
//

import XCTest
@testable import MovieQuiz

class ArrayTest: XCTestCase {
    func testGetValueInRange () throws {
        let array = [1, 1, 2, 4, 5]
        let value = array[safe: 3]
        
        XCTAssertNotNil(value)
        XCTAssertEqual(value, 4)
    }
    
    func testGetValueOutOfRange () throws {
        let array = [1, 1, 2, 4, 5]
        let value = array[safe: 9]
        
        XCTAssertNil(value)
    }
}
