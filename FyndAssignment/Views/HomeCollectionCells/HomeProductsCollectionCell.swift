//
//  HomeProductsCollectionCell.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 28/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import UIKit

class HomeProductsCollectionCell: UICollectionViewCell {
    @IBOutlet weak var productName: UILabel!
    @IBOutlet weak var productPrice: UILabel!
    @IBOutlet weak var productImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        productImage.layer.cornerRadius = 8.0
    }
    
}
