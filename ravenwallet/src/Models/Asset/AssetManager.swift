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
    
    enum AssetFilter {
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
    
    func loadWhitelist(callback: ((Set<String>) -> Void)? = nil) {
        db?.loadWhitelist(callback: { [weak self] whitelist in
            
            self?.whitelist.removeAll(keepingCapacity: true)
            
            for asset in whitelist {
                self?.whitelist.insert(asset)
            }
            
            if let whitelist = self?.whitelist {
                callback?(whitelist)
            }
        })
    }
    
    func loadBlacklist(callback: ((Set<String>) -> Void)? = nil) {
        db?.loadBlacklist(callback: { [weak self] blacklist in

            self?.blacklist.removeAll(keepingCapacity: true)

            for asset in blacklist {
                self?.whitelist.insert(asset)
            }

            if let blacklist = self?.blacklist {
                callback?(blacklist)
            }
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
    
    func setFilter(_ assetFilter: AssetFilter) {
        self.assetFilter = assetFilter
    }
}
