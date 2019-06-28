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
    
    var collection = [photo]()
    
    var collectionImage = [toSaveDisplay]()
    
    var pinSelected = Pin ()
    
    var lon: Double = 0.0
    var lat: Double = 0.0
    
    var page: Int = 0
    var pages: Int = 0

    /*
    init (photoID: String, farm: Int, server: String, secret: String) {
        self.photoID = photoID
        self.farm = farm
        self.server = server
        self.secret = secret
}
 */
    
    private init() { }
    
  class func collectionGenerator () {
        
        var c: Int = 0
    

    print("Collection count: \(photoInfo.shared.collection.count)")
       repeat {
        
        let ImagenURL = "https://farm\(photoInfo.shared.collection[c].farm).staticflickr.com/\(photoInfo.shared.collection[c].server)/\(photoInfo.shared.collection[c].id)_\(photoInfo.shared.collection[c].secret)_m.jpg"
       let imagenTemp = imageDownload(UrlString: ImagenURL)
        
      //  let imagenTemp = UIImage(named: "duck.jpg")
        print (c)
        c+=1
        
        let temp = toSaveDisplay(Imagen: imagenTemp.pngData(), ImagenURL: ImagenURL, photoID: photoInfo.shared.collection[c].id, userID: photoInfo.shared.collection[c].owner)
        photoInfo.shared.collectionImage.append(temp)
        
        //    DispatchQueue.main.async {
         //   TableViewController.proCollection.reloadData()
         //   }
        
        } while c <  photoInfo.shared.collection.count - 1
            
            
       
    
    }
    
    class func imageDownload (UrlString: String) -> UIImage  {
        
        let url = URL(string: UrlString)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        if let imagen = UIImage(data: data!)
        {
            return imagen
        }
        
        else {return UIImage(named: "duck")! }
        
   /*
        let request = URLRequest(url: URL(string: UrlString)!)
        var imagen = UIImage()
        print(UrlString)
        
        let session = URLSession.shared
        
        
        
        let task = session.dataTask(with: request) { data, response, error in
            
            guard let data=data else {
                
          //      complitionHandler (nil,response,error)
                return
                
            }
            
            print("DATA IMPRESION")
            print(data)
       //     complitionHandler (data,nil,nil)
            imagen = UIImage(data: data)!
            
        }
        
        task.resume()
        return imagen
    
    */
    }
}

