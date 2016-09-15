//
//  stockTableViewCell.swift
//  Portfolio Rebalancing
//
//  Created by Weirui Kong on 2016-07-28.
//  Copyright © 2016 uwaterloo. All rights reserved.
//

import UIKit

class StockTableViewCell: UITableViewCell {
    
    // MARK: Properties
    @IBOutlet weak var labelTicker: UILabel!
    @IBOutlet weak var labelPrice: UILabel!
    @IBOutlet weak var labelChange: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
