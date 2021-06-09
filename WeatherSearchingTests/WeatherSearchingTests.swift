//
//  WeatherSearchingTests.swift
//  WeatherSearchingTests
//
//  Created by Andres Chan on 5/6/2021.
//

import XCTest
@testable import WeatherSearching

class WeatherSearchingTests: XCTestCase {
    var userDefaultManager: UserDefaultsManager!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        try super.setUpWithError()

        userDefaultManager = UserDefaultsManager()
        userDefaultManager.searches = []
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        userDefaultManager.searches = []
        userDefaultManager = nil
        try super.tearDownWithError()

    }

    func testAddNilSearch() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let originalCount = userDefaultManager.searches.count
        
        let resultCount = userDefaultManager.addSearch(WeatherModel(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, snow: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: nil, cod: nil)).count
        
        XCTAssertEqual(resultCount, originalCount, "adding searches with nil name is wrong")
    }
    
    func testAddEmptySearch() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        let originalCount = userDefaultManager.searches.count
        
        let resultCount = userDefaultManager.addSearch(WeatherModel(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, snow: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "", cod: nil)).count
        
        XCTAssertEqual(resultCount, originalCount, "adding searches with empty string name is wrong")
    }
    
    func testAddSearch() {
        let weatherModel = WeatherModel(coord: nil, weather: nil, base: nil, main: nil, visibility: nil, wind: nil, rain: nil, snow: nil, dt: nil, sys: nil, timezone: nil, id: nil, name: "Hong Kong", cod: nil)
        
        let fastReturn = userDefaultManager.addSearch(weatherModel)
        
        XCTAssertEqual(fastReturn.first, userDefaultManager.searches.first, "adding searches fail")
        
        XCTAssertEqual(userDefaultManager.searches.first, weatherModel, "adding searches fail")
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
