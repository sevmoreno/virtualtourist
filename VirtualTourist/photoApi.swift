//
//  photoApi.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/13/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation

class photoApi {
    
    static let base: String = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=ccf37759e7bee52788af6106a005fa17"
    static var lat: String = "34.0194"
    static var lon: String = "-118.411"
    static let city = "&accuracy=11"
    
    
  
    
    class func requestData (complitionHandler: @escaping (Data?,URLResponse?,Error?) -> Void) {
        
        
        let photoURL = base + city + "&format=json" + "&lat=" + lat + "&lon=" + lon
        
        let request = URLRequest(url: URL(string: photoURL)!)
        
        print(photoURL)
        
        let session = URLSession.shared
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data=data else {
                
                complitionHandler (nil,response,error)
                return
                
            }
            
            print("DATA IMPRESION")
            print(data)
            complitionHandler (data,nil,nil)
            
            
        }
        
        task.resume()
    }
    
 
    class  func readData (data: Data)  {
    
        let decoder = JSONDecoder ()
        //       let resutlados: [StudentInformation]
        let data2=data.dropFirst(14)
        let data3=data2.dropLast(1)
        
        
    //    let decoData = try! decoder.decode(rspstat.self, from: data3)
        
        do {
           let decoData = try decoder.decode(rspstat.self, from: data3)
            print(decoData.stat)
            //  StudentInformation.shared.locations = decoData.results
            photoInfo.shared.collection = decoData.photos.photo
            
        } catch {
            
            print("Error decoding data")
         
        }
    
    }
    
}

