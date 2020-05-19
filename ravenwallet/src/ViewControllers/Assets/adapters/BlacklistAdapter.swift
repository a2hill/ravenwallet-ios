//
//  BlacklistAdapter.swift
//  Ravencoin
//
//  Created by Austin Hill on 5/19/20.
//  Copyright © 2020 Medici Ventures. All rights reserved.
//

import Foundation

class BlacklistAdapter: AssetFilterAdapterProtocol {
    
    private var assetManager: AssetManager
    
    var includedList: [String] {
        assetManager.blacklist.sorted()
    }
    var excludedList: [String] {
        var assetSet = Set<String>(assetManager.assetList.map({$0.name}))
        assetSet.subtract(assetManager.blacklist)
        return Array(assetSet)
    }
    
    init(assetManager: AssetManager) {
        self.assetManager = assetManager
    }
    
    func addToList(_ assetName: String) {
        assetManager.addToBlacklist(assetName: assetName)
    }
    
    func removeFromList(_ assetName: String) {
        assetManager.removeFromBlacklist(assetName: assetName)
    }
    
    func titleForList() -> String {
        S.Asset.blacklistTitle
    }
    
    func emptyListText() -> String {
        S.Asset.blacklistEmpty
    }
}
