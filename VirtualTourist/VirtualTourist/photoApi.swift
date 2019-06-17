//
//  photoApi.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/13/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation

class photoApi {
    
    let base: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ccf37759e7bee52788af6106a005fa17"
    var lat: String = ""
    var lon: String = ""
    let city = "&accuracy=11"
  
    func requestData (complitionHandler: @escaping (Data?,URLResponse?,Error?) -> Void) {
        
        let photoURL = base + city + "&" + lat + "&" + lon
        
        var request = URLRequest(url: URL(string: photoURL)!)
        
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data=data else {
                complitionHandler (nil,response,error)
                return
                
            }
            
            
            complitionHandler (data,nil,nil)
            
            
        }
        
        task.resume()
    }
    
}

