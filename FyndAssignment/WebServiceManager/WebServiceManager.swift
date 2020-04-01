//
//  WebServiceManager.swift
//  FyndAssignment
//
//  Created by Tania Jasam on 27/03/20.
//  Copyright © 2020 CodeIt. All rights reserved.
//

import Foundation

final class WebServiceManager {
    
    static let sharedInstance: WebServiceManager = {
        let instance = WebServiceManager()
        return instance
    }()

    func fetchData(_ homeUrl: String, completionHandler: @escaping (_ result : Data?, _ error: Error?) -> Void) {

        let dataTask = URLSession.shared.dataTask(with: URL.init(string: homeUrl)!, completionHandler: { (data, response, error) in

            completionHandler(data, error)

        })
        dataTask.resume()
    }
}


