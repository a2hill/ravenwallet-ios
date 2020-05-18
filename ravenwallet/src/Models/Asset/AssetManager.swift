//
//  AssetManager.swift
//  ravenwallet
//
//  Created by Ben on 15/10/18.
//  Copyright (c) 2018 Ravenwallet Team


import Foundation
import UIKit
import SystemConfiguration

class AssetManager {
    
    enum AssetFilter: String {
        case manual
        case whitelist
        case blacklist
    }
    
    static let shared = AssetManager()

    var db: CoreDatabase?
    var assetList:[Asset] = []
    var showedAssetList:[Asset] {
        get {
            switch assetFilter {
            case .manual:
                return assetList.filter({$0.isHidden == false})
                
            case .whitelist:
                return assetList.filter({whitelist.contains($0.name)})
                
            case .blacklist:
                return assetList.filter({!blacklist.contains($0.name)})
            }
        }
    }
    
    private var assetFilter: AssetFilter {
        didSet {
            UserDefaults.assetFilter = assetFilter
        }
    }
    private var whitelist: Set<String> = []
    private var blacklist: Set<String> = []
    
    private init() {
        db = CoreDatabase()
        assetFilter = UserDefaults.assetFilter
        loadAsset()
        loadWhitelist()
        loadBlacklist()
    }
    
    func loadAsset(callBack: (([Asset]) -> Void)? = nil) {
        db = CoreDatabase()
        db?.loadAssets(callback: { assets in
            self.assetList = assets
            if callBack != nil {
                callBack!(assets)
            }
        })
    }
    
    private func loadWhitelist(callback: (() -> Void)? = nil) {
        db?.loadWhitelist(callback: { [weak self] whitelist in
            
            self?.whitelist.removeAll(keepingCapacity: true)
            
            for asset in whitelist {
                self?.whitelist.insert(asset)
            }
            
            callback?()
        })
    }
    
    private func loadBlacklist(callback: (() -> Void)? = nil) {
        db?.loadBlacklist(callback: { [weak self] blacklist in

            self?.blacklist.removeAll(keepingCapacity: true)

            for asset in blacklist {
                self?.blacklist.insert(asset)
            }

            callback?()
        })
    }

    
    func updateAssetOrder(assets:[Asset]) {
        var orderId = assets.count
        for var asset in assets {
            asset.sort = orderId
            db?.updateSortAsset(asset, where: asset.idAsset)
            orderId = orderId - 1
        }
    }
    
    func hideAsset(asset:Asset, where idOldValue:Int, callback: ((Bool)->Void)? = nil) {
        db?.updateHideAsset(asset, where: idOldValue, callback: callback)
    }
    
    func isAssetNameExiste(name:String, callback: @escaping (AssetName?, Bool)->Void) {
        db?.isAssetNameExiste(name: name, callback: { (assetName, isExiste) in
            callback(assetName, isExiste)
        })
    }
    
    //MARK: Asset Filter
    
    func setAssetFilter(_ assetFilter: AssetFilter) {
        self.assetFilter = assetFilter
    }
    
    //MARK: Asset Filter - Whitelist
    
    func addToWhitelist(assetName: String) {
        let result = whitelist.insert(assetName)
        
        guard result.0 else { return } // Check that the name was inserted
        
        db?.addToWhitelist(assetName: assetName) { [weak self] success in
            
            // Reload the whitelist if the transaction is not successful so that we stay in coordination with the db
            if !success {
                self?.loadWhitelist()
            }
        }
    }
    
    func removeFromWhitelist(assetName: String) {
        guard let _ = whitelist.remove(assetName) else { return }
            
        db?.removeFromWhitelist(assetName: assetName)
    }
    
    func clearWhitelist() {
        db?.clearWhitelist {
            //TODO: Is this necessary?
        }
    }
    
    //MARK: Asset Filter - Blacklist
    
    func addToBlacklist(assetName: String) {
        let result = blacklist.insert(assetName)
        
        guard result.0 else { return } // Check that the name was inserted
        
        db?.addToBlacklist(assetName: assetName) { [weak self] success in
            
            // Reload the whitelist if the transaction is not successful so that we stay in coordination with the db
            if !success {
                self?.loadBlacklist()
            }
        }
    }
    
    func removeFromBlacklist(assetName: String) {
        guard let _ = blacklist.remove(assetName) else { return }
            
        db?.removeFromBlacklist(assetName: assetName)
    }
    
    func clearBlacklist() {
        db?.clearBlacklist {
            //TODO: Is this necessary?
        }
    }
}
