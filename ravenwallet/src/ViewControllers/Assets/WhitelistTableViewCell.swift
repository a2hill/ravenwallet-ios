//
//  WhitelistTableViewCell.swift
//  Ravencoin
//
//  Created by Austin Hill on 5/17/20.
//  Copyright © 2020 Medici Ventures. All rights reserved.
//

import UIKit

class WhitelistTableViewCell: UITableViewCell {
    static var reuseIdentifier = "whitelistTableViewCell"
    
    var assetName: String? {
        didSet {
            guard let assetName = assetName else { return }
            self.textLabel?.text = assetName
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
