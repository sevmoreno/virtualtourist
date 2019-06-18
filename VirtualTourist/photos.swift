//
//  photos.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/17/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation

struct photos: Codable {
    
    var page: Int?
    var pages: Int?
    var perpage: Int?
    var total: String?
    var photo: [photo]

//   private enum CodingKeys : String, CodingKey {
//   case perpage, page , total, photo, pages
 //  }
    
    
}

