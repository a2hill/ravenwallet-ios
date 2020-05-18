//
//  AssetWhitelistTableViewController.swift
//  Ravencoin
//
//  Created by Austin Hill on 5/17/20.
//  Copyright © 2020 Medici Ventures. All rights reserved.
//

import UIKit

class AssetWhitelistTableViewController: UITableViewController {
    
    enum Section: Int, CaseIterable {
        case whitelist = 0
        case nonWhitelist = 1
        
        init?(for indexPath: IndexPath) {
            if let section = Section(rawValue: indexPath.section) {
                self = section
            }else {
                return nil
            }
        }
    }
    
    private let emptyMessage = UILabel.wrapping(font: .customBody(size: 16.0), color: .grayTextTint)
    private let assetManager = AssetManager.shared
    
    private var whitelistNames: [String] {
        assetManager.whitelist.sorted()
    }
    private var nonWhitelistNames: [String] {
        assetManager.assetList.compactMap { asset in
            if !assetManager.whitelist.contains(asset.name) {
                return asset.name
            }else {
                return nil
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(AssetManageCell.self, forCellReuseIdentifier: AssetManageCell.cellIdentifier)

        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = 60.0
        tableView.rowHeight = UITableView.automaticDimension
        tableView.backgroundColor = .whiteTint
        tableView.isEditing = true

        emptyMessage.textAlignment = .center
        emptyMessage.text = S.Asset.emptyMessage
        
        setContentInset()
    }
    
    private func setContentInset() {
        let insets = UIEdgeInsets(top: manageAssetHeaderHeight - 64.0 - (E.isIPhoneXOrLater ? 28.0 : 0.0), left: 0, bottom: C.padding[2], right: 0)
        tableView.contentInset = insets
        tableView.scrollIndicatorInsets = insets
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WhitelistTableViewCell.reuseIdentifier, for: indexPath) as! WhitelistTableViewCell
        
        guard let section = Section(for: indexPath) else { return cell }
        
        let assetName: String
        
        switch section {
        case .whitelist:
            assetName = whitelistNames[indexPath.row]
            
        case .nonWhitelist:
            assetName = nonWhitelistNames[indexPath.row]
        }
        
        cell.assetName = assetName
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = Section(rawValue: section) else { return nil }
        
        switch section {
        case .whitelist:
            return "Whitelisted Assets"
            
        case .nonWhitelist:
            return "Available Assets"
        }
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - Table view data source
extension AssetWhitelistTableViewController {

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return Section.allCases.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
        guard let section = Section(rawValue: section) else { return 0 }
        
        switch section {
        case .whitelist:
            return whitelistNames.count
            
        case .nonWhitelist:
            return nonWhitelistNames.count
        }
    }
}

// MARK: - Table view interaction handler
extension AssetWhitelistTableViewController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = Section(for: indexPath) else { return }
        
        switch section {
        case .whitelist:
            tableView.beginUpdates()
            let assetName = whitelistNames[indexPath.row]
            assetManager.removeFromWhitelist(assetName: assetName)
            tableView.endUpdates()
            
        case .nonWhitelist:
            tableView.beginUpdates()
            let assetName = nonWhitelistNames[indexPath.row]
            assetManager.addToWhitelist(assetName: assetName)
            tableView.endUpdates()
        }
    }
}
