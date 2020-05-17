//
//  AssetManagerTest.swift
//  RavencoinTests
//
//  Created by Austin Hill on 5/17/20.
//  Copyright © 2020 Medici Ventures. All rights reserved.
//

import XCTest
import Foundation

@testable import Ravencoin

class AssetManagerTest: XCTestCase {
    
    let db = CoreDatabase()

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let lock = DispatchSemaphore(value: 1)
        
        lock.wait()
        db.clearBlacklist {
            lock.signal()
        }
        
        lock.wait()
        db.clearWhitelist {
            lock.signal()
        }
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDbWhitelist() throws {
        let db = CoreDatabase()
        let loadExpectation = self.expectation(description: "Load empty whitelist")
        db.loadWhitelist { whitelist in
            XCTAssertEqual(whitelist.count, 0, "whitelist should be empty")
            loadExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        var whitelist = ["Test", "Test2", "Test3"]
        let lock = DispatchSemaphore(value: 1)
        for asset in whitelist {
            lock.wait()
            db.addToWhitelist(assetName: asset) { _ in
                lock.signal()
            }
        }
        
        let reloadExpectation = self.expectation(description: "Load populated whitelist")
        db.loadWhitelist { returnList in
            XCTAssertEqual(returnList.count, whitelist.count, "whitelist should have \(whitelist.count) values")
            reloadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        
        lock.wait()
        db.addToWhitelist(assetName: "Test3") { success in
            XCTAssertFalse(success, "Duplicate assets should not be added")
            lock.signal()
        }
        
        let recoundExpectation = self.expectation(description: "Load whitelist again to see if there are changes")
        db.loadWhitelist { list in
            XCTAssertEqual(list.count, whitelist.count, "Last whitelist addition should not have made it into the db")
            recoundExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testDbBlacklist() throws {
        let db = CoreDatabase()
        let loadExpectation = self.expectation(description: "Load empty blacklist")
        db.loadBlacklist { blacklist in
            XCTAssertEqual(blacklist.count, 0, "blacklist should be empty")
            loadExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
        
        var blacklist = ["Test", "Test2", "Test3"]
        let lock = DispatchSemaphore(value: 1)
        for asset in blacklist {
            lock.wait()
            db.addToBlacklist(assetName: asset) { _ in
                lock.signal()
            }
        }
        
        let reloadExpectation = self.expectation(description: "Load populated blacklist")
        db.loadBlacklist { returnList in
            XCTAssertEqual(returnList.count, blacklist.count, "blacklist should have \(blacklist.count) values")
            reloadExpectation.fulfill()
        }
        waitForExpectations(timeout: 1.0)
        
        
        lock.wait()
        db.addToBlacklist(assetName: "Test3") { success in
            XCTAssertFalse(success, "Duplicate assets should not be added")
            lock.signal()
        }
        
        let recoundExpectation = self.expectation(description: "Load blacklist again to see if there are changes")
        db.loadBlacklist { list in
            XCTAssertEqual(list.count, blacklist.count, "Last blacklist addition should not have made it into the db")
            recoundExpectation.fulfill()
        }
        
        waitForExpectations(timeout: 1.0)
    }
    
    func testAssetManagerWhitelist() {
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
