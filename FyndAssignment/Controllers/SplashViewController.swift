//
//  SplashViewController.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 28/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import UIKit

enum API {
    case home
    case images
}

class SplashViewController: UIViewController {
    
    let dispatchGroup = DispatchGroup()
    var homeData: [HomeData]?
    var productImages: [Results]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        weak var weakSelf = self
        
        callWebService(apiType: .home)
        callWebService(apiType: .images)
        dispatchGroup.notify(queue: DispatchQueue.main) {[weak self] in
            if let homeResponse = self?.homeData, let imagesResponse = weakSelf?.productImages {
                weakSelf?.pushToHomeVC(withResponse: homeResponse, andProductImages: imagesResponse)
            } else {
                weakSelf?.showAlert()
            }
            
        }
    }
    
    func callWebService(apiType: API) {
        var url = ""
        switch apiType {
        case .home:
            url = HOME_URL
        case .images:
            url = PRODUCT_IMAGES_URL
        }
        dispatchGroup.enter()
        WebServiceManager.sharedInstance.fetchData(url) { (data, error) in
            weak var weakSelf = self
            if error != nil {
                print(error?.localizedDescription ?? "Error")
                return
            }
            if data != nil {
                do {
                    let decoder = JSONDecoder()
                    switch apiType {
                    case .home:
                        weakSelf?.homeData = try decoder.decode([HomeData].self, from: data!)
                        weakSelf?.dispatchGroup.leave()
                    case .images:
                        let images = try decoder.decode(ProductImages.self, from: data!)
                        weakSelf?.productImages = images.results
                        weakSelf?.dispatchGroup.leave()
                    }
                } catch {
                    weakSelf?.showAlert()
                }
            }
        }
    }
    
    func showAlert()  {
        let alertVC = UIAlertController.init(title: "Error", message: "Unable to fetch data. Try again later", preferredStyle: .alert)
        let okAction = UIAlertAction.init(title: "OK", style: .default) { (action) in
            
        }
        alertVC.addAction(okAction)
        self.present(alertVC, animated: true, completion: nil)
    }
    
    func pushToHomeVC(withResponse homeDataResponse: [HomeData], andProductImages images:[Results]) {
        let homeVC = UIStoryboard(name: STORYBOARD_NAME, bundle: nil).instantiateViewController(identifier: HOME_VC_IDENTIFIER) as! HomeViewController
        homeVC.homeData = homeDataResponse.filter({ (homeData) -> Bool in
            return homeData.products?.count ?? 0 > 0
        })
        homeVC.productImages = images
        homeVC.modalPresentationStyle = .fullScreen
        self.present(homeVC, animated: false, completion: nil)
    }
    
}
