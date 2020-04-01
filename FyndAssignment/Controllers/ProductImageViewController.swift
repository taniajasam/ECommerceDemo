//
//  ProductImageViewController.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 29/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import UIKit
import TOCropViewController

protocol ProductImageViewControllerDelegate: class {
    func didCropImage(croppedImage: UIImage)
}

class ProductImageViewController: UIViewController {
    
    var cropVC : TOCropViewController?
    var selectedImage: UIImage?
    
    weak var delegate: ProductImageViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if selectedImage != nil {
            cropVC = TOCropViewController(image: selectedImage!)
            cropVC!.delegate = self
            addChild(cropVC!)
            
            cropVC!.view.frame = self.view.bounds
            self.view.addSubview(cropVC!.view)
            
            cropVC!.didMove(toParent: self)
        }
    }
}

extension ProductImageViewController: TOCropViewControllerDelegate
{
    func cropViewController(_ cropViewController: TOCropViewController, didCropTo image: UIImage, with cropRect: CGRect, angle: Int) {
        cropVC?.dismiss(animated: true) {
            self.delegate?.didCropImage(croppedImage: image)
        }
    }
}
