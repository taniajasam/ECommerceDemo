//
//  HomeViewController.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 28/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import UIKit
import TOCropViewController

class HomeViewController: UIViewController {
    var homeData: [HomeData]?
    var productImages: [Results]?
    var presentedTableViewCellIndex: Int?
    var presentedProductImageIndex: Int?
    var selectedSectionIndex: Int?
    var selectedRowIndex: Int?
    var cropVC : TOCropViewController?
    
    var homeView: HomeView?
    
    @IBOutlet weak var switchButton: UIButton!
    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        homeView = .grid
        switchButton.layer.cornerRadius = 4.0
        switchButton.layer.borderColor = UIColor.white.cgColor
        switchButton.layer.borderWidth = 2.0
        homeTableView.allowsSelection = false
        registerTableViewCell()
    }
    
    
    func registerTableViewCell() {
        homeTableView.register(UINib(nibName: HOME_TABLEVIEW_CELL_NIBNAME, bundle: nil), forCellReuseIdentifier: HOME_TABLEVIEW_CELL_IDENTIFIER)
        homeTableView.register(UINib(nibName: HOME_LIST_CELL_VIEW_NIBNAME, bundle: nil), forCellReuseIdentifier: HOME_LIST_CELL_IDENTIFIER)
    }
    
    @objc func sectionViewTapped(tapGesture: UITapGestureRecognizer)  {
        if let tapView = tapGesture.view {
            print(tapView.tag)
            for i in 0 ..< homeData!.count {
                if i != tapView.tag {
                    homeData![i].isExpanded = false
                    
                }
            }
            homeData![tapView.tag].isExpanded = !homeData![tapView.tag].isExpanded
            homeTableView.reloadData()
        }
    }
    @IBAction func didClickOnSwitchButton(_ sender: Any) {
        if homeView == .grid {
            homeView = .list
            switchButton.setTitle("Grid View", for: .normal)
            homeTableView.allowsSelection = true
        } else {
            homeView = .grid
            switchButton.setTitle("List View", for: .normal)
            homeTableView.allowsSelection = false
        }
        homeTableView.reloadData()
    }
    
    func presentProductImageVC(selectedImage: UIImage) {
        let productImageVC = UIStoryboard(name: STORYBOARD_NAME, bundle: nil).instantiateViewController(identifier: PRODUCT_IMAGE_VC_IDENTIFIER) as? ProductImageViewController
        productImageVC?.selectedImage = selectedImage
        productImageVC?.delegate = self
        productImageVC?.modalPresentationStyle = .fullScreen
        productImageVC?.modalTransitionStyle = .flipHorizontal
        present(productImageVC!, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if homeView == .grid {
            return 1
        } else {
            if homeData != nil {
                return homeData?.count ?? 0
            }
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if homeView == .grid {
            if homeData != nil {
                return homeData?.count ?? 0
            }
            return 0
        } else {
            if homeData![section].isExpanded {
                return homeData![section].products?.count ?? 0
            }
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if homeView == .list {
            return 65
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: homeTableView.frame.size.width, height: 65))
        headerView.backgroundColor = .white
        headerView.tag = section
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(sectionViewTapped(tapGesture:)))
        headerView.addGestureRecognizer(tapGesture)
        let underlineView = UIView(frame: CGRect(x: 0, y: 64, width: homeTableView.frame.size.width, height: 1))
        underlineView.backgroundColor = .gray
        let headerLabel = UILabel(frame: CGRect(x: 8, y: 16, width: 100, height: 30))
        let imageViewFrame = CGRect(x: homeTableView.frame.size.width - 46, y: headerView.frame.size.height/2-15, width: 30, height: 30)
        let imageView = UIImageView(frame: imageViewFrame)
        imageView.image = UIImage(named: "downArrow")
        headerLabel.text = homeData![section].name
        headerView.addSubview(headerLabel)
        headerView.addSubview(underlineView)
        headerView.addSubview(imageView)
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if homeView == .grid {
            return 420
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if homeView == .grid {
            let homeTableCell = tableView.dequeueReusableCell(withIdentifier: HOME_TABLEVIEW_CELL_IDENTIFIER, for: indexPath) as? HomeTableViewCell
            homeTableCell?.filterSegmentControl.selectedSegmentIndex = homeData![indexPath.row].selectedFilterIndex
            homeTableCell?.tag = indexPath.row
            homeTableCell?.delegate = self
            homeTableCell?.productNameLabel.text = homeData![indexPath.row].name
            let products = homeData![indexPath.row].products
            if homeTableCell?.filterSegmentControl.selectedSegmentIndex == 0 {
                homeTableCell?.products = products?.sorted(by: { (p1, p2) -> Bool in
                    return p1.name?.compare(p2.name ?? "") == ComparisonResult.orderedAscending
                })
            } else {
                homeTableCell?.products = products?.sorted(by: { (p1, p2) -> Bool in
                    return p1.cost ?? 0 < p2.cost ?? 0
                })
            }
            homeTableCell?.productImages = productImages
            return homeTableCell!
        }
        else {
            let homeListTableCell = tableView.dequeueReusableCell(withIdentifier: HOME_LIST_CELL_IDENTIFIER, for: indexPath) as? HomeListTableViewCell
            let product = homeData![indexPath.section].products
            homeListTableCell?.productListNameLabel.text = product![indexPath.row].name
            homeListTableCell?.productListCostLabel.text = "₹ \(product![indexPath.row].cost ?? 0)"
            if let image = product![indexPath.row].selectedImage {
                homeListTableCell?.productListImageView.image = image
            } else {
                if let productImage = productImages?.randomElement(){
                    let imageUrl = productImage.urls?.thumb
                    homeListTableCell?.productListImageView.kf.setImage(with: URL(string: imageUrl!))
                }
            }
            return homeListTableCell!
        }
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSectionIndex = indexPath.section
        selectedRowIndex = indexPath.row
        let selectedCell = homeTableView.cellForRow(at: indexPath) as? HomeListTableViewCell
        let selectedImage = selectedCell?.productListImageView.image
        presentProductImageVC(selectedImage: selectedImage!)
    }
}

extension HomeViewController: HomeTableViewCellDelegate {
    
    func segmentedControlValueChangedWithCellTag(cellTag: Int) {
        homeData![cellTag].selectedFilterIndex = homeData![cellTag].selectedFilterIndex == 0 ? 1 : 0
    }
    
    func didTapOnProductImageWith(imageIndex index: NSInteger, andTableCellIndex cellTag: Int) {
        presentedTableViewCellIndex = cellTag
        presentedProductImageIndex = index
        
        guard let tableCell = homeTableView.cellForRow(at: IndexPath(row: cellTag, section: 0)) as? HomeTableViewCell else {
            return
        }
        let productCollectionCell = tableCell.productsCollectionView.cellForItem(at: IndexPath(item: index, section: 0)) as? HomeProductsCollectionCell
        let selectedImage = productCollectionCell?.productImage.image
        
        presentProductImageVC(selectedImage: selectedImage!)
        
    }
}

extension HomeViewController: ProductImageViewControllerDelegate {
    
    func didCropImage(croppedImage: UIImage) {
        if homeView == .grid {
            let selectedProductCategory = homeData![presentedTableViewCellIndex ?? 0].products
            var selectedProduct = selectedProductCategory![presentedProductImageIndex ?? 0]
            selectedProduct.selectedImage = croppedImage
            homeData![presentedTableViewCellIndex ?? 0].products?[presentedProductImageIndex ?? 0] = selectedProduct
            homeTableView.reloadRows(at: [IndexPath(row: presentedTableViewCellIndex ?? 0, section: 0)], with: .fade)
        } else {
            let selectedCategory = homeData![selectedSectionIndex ?? 0].products
            var selectedItem = selectedCategory![selectedRowIndex ?? 0]
            selectedItem.selectedImage = croppedImage
            homeData![selectedSectionIndex ?? 0].products?[selectedRowIndex ?? 0] = selectedItem
            homeTableView.reloadRows(at: [IndexPath(row: selectedRowIndex ?? 0, section: selectedSectionIndex ?? 0)], with: .fade)
        }
        
    }
    
}

