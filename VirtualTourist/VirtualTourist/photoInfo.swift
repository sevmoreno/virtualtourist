//
//  photoInfo.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/12/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit

class photoInfo {
    
    
    // Singleton POWER
    
    static let shared = photoInfo()
    
    var collection = [photoInfo]()
    
    var thumbnail: UIImage?
    var largeImage: UIImage?
    let photoID: String = ""
    let farm: Int = 0
    let server: String = ""
    let secret: String = ""

    /*
    init (photoID: String, farm: Int, server: String, secret: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
}
 */
    
    private init() { }
    
func flickrImageURL(_ size: String = "m") -> URL? {
        if let url =  URL(string: "https://farm\(farm).staticflickr.com/\(server)/\(photoID)_\(secret)_\(size).jpg") {
            return url
        }
        return nil
    }
    
}

