//
//  HomeTableViewCell.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 28/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import UIKit
import Kingfisher

protocol HomeTableViewCellDelegate: class {
    func segmentedControlValueChangedWithCellTag(cellTag: Int)
    func didTapOnProductImageWith(imageIndex index:NSInteger, andTableCellIndex cellTag:Int)
}

class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet weak var filterSegmentControl: UISegmentedControl!
    @IBOutlet weak var productNameLabel: UILabel!
    @IBOutlet weak var productsCollectionView: UICollectionView!
    var products: [Products]?
    var productImages: [Results]?
    
    weak var delegate: HomeTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCollectionViewCells()
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(longPressGestureAction(longPressGesture:)))
        productsCollectionView.addGestureRecognizer(longPressGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        products = nil
        productsCollectionView.reloadData()
    }
    
    func registerCollectionViewCells() {
        productsCollectionView.register(UINib(nibName: HOME_PRODUCTS_COLLECTIONVIEW_CELL_NIBNAME, bundle: nil), forCellWithReuseIdentifier: HOME_PRODUCTS_COLLECTIONVIEW_CELL_IDENTIFIER)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func filterSegmentedControlValueChanged(_ sender: Any) {
        if filterSegmentControl.selectedSegmentIndex == 0 {
            products = products?.sorted(by: { (p1, p2) -> Bool in
                return p1.name?.compare(p2.name ?? "") == ComparisonResult.orderedAscending
            })
        } else {
            products = products?.sorted(by: { (p1, p2) -> Bool in
                return p1.cost ?? 0 < p2.cost ?? 0
            })
        }
        productsCollectionView.reloadData()
        delegate?.segmentedControlValueChangedWithCellTag(cellTag: self.tag)
    }
    
    @objc func longPressGestureAction(longPressGesture: UILongPressGestureRecognizer) {
        switch(longPressGesture.state) {
        case .began:
            guard let selectedIndexPath = productsCollectionView.indexPathForItem(at: longPressGesture.location(in: productsCollectionView)) else {
                return
            }
            productsCollectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        case .changed:
            productsCollectionView.updateInteractiveMovementTargetPosition(longPressGesture.location(in: longPressGesture.view!))
        case .ended:
            productsCollectionView.endInteractiveMovement()
            productsCollectionView.reloadData()
        default:
            productsCollectionView.cancelInteractiveMovement()
        }
    }
}

extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if products != nil {
            return products?.count ?? 0
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let productCollectionCell = collectionView.dequeueReusableCell(withReuseIdentifier: HOME_PRODUCTS_COLLECTIONVIEW_CELL_IDENTIFIER, for: indexPath) as? HomeProductsCollectionCell
        productCollectionCell?.productName.text = products![indexPath.row].name?.uppercased()
        productCollectionCell?.productPrice.text = "₹ \(products![indexPath.row].cost ?? 0)"
        if let image = products![indexPath.row].selectedImage {
            productCollectionCell?.productImage.image = image
        } else {
            if let productImage = productImages?.randomElement(){
                let imageUrl = productImage.urls?.thumb
                productCollectionCell?.productImage.kf.setImage(with: URL(string: imageUrl!))
            }
        }
        
        return productCollectionCell!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth = (UIScreen.main.bounds.size.width - 40)/3
        let cellHeight = cellWidth + 50
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didTapOnProductImageWith(imageIndex: indexPath.row, andTableCellIndex: self.tag)
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        print("\(sourceIndexPath.item)")
        print("\(destinationIndexPath.item)")
        
        let product = products![sourceIndexPath.item]
        products![sourceIndexPath.item] = products![destinationIndexPath.item]
        products![destinationIndexPath.item] = product
        
        productsCollectionView.reloadData()
    }
}



