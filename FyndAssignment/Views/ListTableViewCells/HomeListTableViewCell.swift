//
//  HomeListTableViewCell.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 28/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import UIKit

class HomeListTableViewCell: UITableViewCell {
    @IBOutlet weak var productListNameLabel: UILabel!
    @IBOutlet weak var productListCostLabel: UILabel!
    @IBOutlet weak var productListImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productListImageView.layer.cornerRadius = 4.0
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
