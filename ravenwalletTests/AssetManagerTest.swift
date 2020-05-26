//
//  AssetManagerTest.swift
//  RavencoinTests
//
//  Created by Austin Hill on 5/17/20.
//  Copyright © 2020 Medici Ventures. All rights reserved.
//

@testable import Ravencoin
import XCTest

class AssetManagerTest: XCTestCase {

    var assetManager: AssetManager!
    
    override func setUpWithError() throws {
        assetManager = AssetManager.shared
        assetManager.assetList.removeAll()
        assetManager.clearWhitelist()
        assetManager.clearBlacklist()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        assetManager.assetList.removeAll()
        assetManager.clearWhitelist()
        assetManager.clearBlacklist()
        assetManager = nil
    }

//    func testManual() throws {
//        XCTAssertEqual(assetManager.assetList.count, 0, "Starting whitelist should be empty")
//
//        let testAssets = ["test", "test1", "test2"]
//        for (index, assetname) in testAssets.enumerated() {
//            let asset = Asset(idAsset: index, name: assetname, amount: Satoshis(rawValue: 100), units: 1, reissubale: 0, hasIpfs: 0, ipfsHash: "", ownerShip: 0, hidden: 0, sort: 0)
//            assetManager.assetList.append(asset)
//        }
//
//        assetManager.setAssetFilter(.manual)
//        XCTAssertEqual(assetManager.assetList.count, testAssets.count, "Newly added assets should be only assets in manager")
//        XCTAssertEqual(assetManager.showedAssetList.count, assetManager.assetList.count, "All assets should be visible")
//
//        assetManager.assetList.removeAll()
//        XCTAssertEqual(assetManager.assetList.count, 0)
//        XCTAssertEqual(assetManager.showedAssetList.count, 0)
//
//        for (index, assetname) in testAssets.enumerated() {
//            let asset = Asset(idAsset: index, name: assetname, amount: Satoshis(rawValue: 100), units: 1, reissubale: 0, hasIpfs: 0, ipfsHash: "", ownerShip: 0, hidden: 1, sort: 0)
//            assetManager.assetList.append(asset)
//        }
//
//        XCTAssertEqual(assetManager.assetList.count, testAssets.count, "Newly added assets should be only assets")
//        XCTAssertEqual(assetManager.showedAssetList.count, 0, "All assets should be hidden")
//    }
    
    func testWhitelist() throws {
        XCTAssertEqual(assetManager.assetList.count, 0, "Starting whitelist should be empty")
        
        let testAssets = ["test", "test1", "test2"]
        for (index, assetname) in testAssets.enumerated() {
            let asset = Asset(idAsset: index, name: assetname, amount: Satoshis(rawValue: 100), units: 1, reissubale: 0, hasIpfs: 0, ipfsHash: "", ownerShip: 0, hidden: 0, sort: 0)
            assetManager.assetList.append(asset)
        }
        
        assetManager.setAssetFilter(.whitelist)
        XCTAssertEqual(assetManager.assetList.count, testAssets.count, "Newly added assets should be only assets in manager")
        XCTAssertEqual(assetManager.showedAssetList.count, 0, "All assets should be hidden")
        
        // Add test assets to whitelist
        for (index, assetName) in testAssets.enumerated() {
            assetManager.addToWhitelist(assetName: assetName)
            XCTAssertEqual(assetManager.assetList.count, testAssets.count, "All assets should still exist")
            XCTAssertEqual(assetManager.showedAssetList.count, index+1, "Should be one more visible asset than previous")
            XCTAssertNotNil(assetManager.showedAssetList.first(where: {$0.name == assetName}), "Asset with the current asset name should be visible")
        }
        
        XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count, "All assets have been added to the whitelist and should be visible")
        
        // Remove test assets from whitelist
        for (index, assetName) in testAssets.enumerated() {
            assetManager.removeFromWhitelist(assetName: assetName)
            XCTAssertEqual(assetManager.assetList.count, testAssets.count, "All assets should still exist")
            XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count - (index+1), "Should be one less visible asset than previous")
            XCTAssertNil(assetManager.showedAssetList.first(where: {$0.name == assetName}), "Asset with the current asset name should be hidden")
        }
        
        XCTAssertEqual(assetManager.showedAssetList.count, 0, "All assets have been removed from the whitelist and should be hidden")
    }
    
    func testBlacklist() throws {
        XCTAssertEqual(assetManager.assetList.count, 0, "Starting whitelist should be empty")
        
        let testAssets = ["test", "test1", "test2"]
        for (index, assetname) in testAssets.enumerated() {
            let asset = Asset(idAsset: index, name: assetname, amount: Satoshis(rawValue: 100), units: 1, reissubale: 0, hasIpfs: 0, ipfsHash: "", ownerShip: 0, hidden: 0, sort: 0)
            assetManager.assetList.append(asset)
        }
        
        assetManager.setAssetFilter(.blacklist)
        XCTAssertEqual(assetManager.assetList.count, testAssets.count, "Newly added assets should be only assets in manager")
        XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count, "All assets should be visible")
        
        // Add test assets to blacklist
        for (index, assetName) in testAssets.enumerated() {
            assetManager.addToBlacklist(assetName: assetName)
            XCTAssertEqual(assetManager.assetList.count, testAssets.count, "All assets should still exist")
            XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count - (index+1), "Should be one less visible asset than previous")
            XCTAssertNil(assetManager.showedAssetList.first(where: {$0.name == assetName}), "Asset with the current asset name should be hidden")
        }
        
        XCTAssertEqual(assetManager.showedAssetList.count, 0, "All assets have been added to the blacklist and should be hidden")
        
        // Remove test assets from blacklist
        for (index, assetName) in testAssets.enumerated() {
            assetManager.removeFromBlacklist(assetName: assetName)
            XCTAssertEqual(assetManager.assetList.count, testAssets.count, "All assets should still exist")
            XCTAssertEqual(assetManager.showedAssetList.count, index+1, "Should be one more visible asset than previous")
            XCTAssertNotNil(assetManager.showedAssetList.first(where: {$0.name == assetName}), "Asset with the current asset name should be visible")
        }
        
        XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count, "All assets have been removed from the blacklist and should be visible")
    }
    
    func testSwitchFilters() throws {
        XCTAssertEqual(assetManager.assetList.count, 0, "Starting whitelist should be empty")
        
        let testAssets = ["test", "test1", "test2"]
        for (index, assetname) in testAssets.enumerated() {
            let asset = Asset(idAsset: index, name: assetname, amount: Satoshis(rawValue: 100), units: 1, reissubale: 0, hasIpfs: 0, ipfsHash: "", ownerShip: 0, hidden: 0, sort: 0)
            assetManager.assetList.append(asset)
        }
        
        XCTAssertEqual(assetManager.assetList.count, testAssets.count, "Newly added assets should be only assets in manager")
        
//        assetManager.setAssetFilter(.manual)
//        XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count, "All assets should be visible")
        
        assetManager.setAssetFilter(.whitelist)
        XCTAssertEqual(assetManager.showedAssetList.count, 0, "Whitelist is empty, all assets should be hidden")
        
        assetManager.setAssetFilter(.blacklist)
        XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count, "Blacklist is empty, all assets should be visible")
        
//        assetManager.setAssetFilter(.manual)
//        XCTAssertEqual(assetManager.showedAssetList.count, testAssets.count, "All assets should be visible")
    }
}
