//
//  WhitelistAdapter.swift
//  Ravencoin
//
//  Created by Austin Hill on 5/18/20.
//  Copyright © 2020 Medici Ventures. All rights reserved.
//

import Foundation

class WhitelistAdapter: AssetFilterAdapterProtocol {
    
    var includedList: [String] {
        assetManager.whitelist.sorted()
    }
    var excludedList: [String] {
        var assetSet = Set<String>(assetManager.assetList.compactMap({$0.name}))
        assetSet.subtract(assetManager.whitelist)
        return assetSet.sorted()
    }
    
    private var assetManager: AssetManager
    
    init(assetManager: AssetManager) {
        self.assetManager = assetManager
    }
    
    func addToList(_ assetName: String) {
        assetManager.addToWhitelist(assetName: assetName)
    }
    
    func removeFromList(_ assetName: String) {
        assetManager.removeFromWhitelist(assetName: assetName)
    }
    
    func titleForList() -> String {
        S.Asset.whitelistTitle
    }
    
    func emptyListText() -> String {
        S.Asset.whitelistEmpty
    }
}
