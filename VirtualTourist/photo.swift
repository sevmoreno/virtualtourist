//
//  photo.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/17/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import Foundation

struct photo: Codable {
    
    var id: String
    var owner: String
    var secret: String
    var server: String
    var farm: Int
    var title: String
    var ispublic: Int
    var isfriend: Int
    var isfamily: Int
    
 //private enum CodingKeys : String, CodingKey {
// case id, owner, secret, server, title, farm, ispublic, isfriend, isfamily
 //  }
    
    
}
