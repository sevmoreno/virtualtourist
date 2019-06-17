//
//  autentica.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/12/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//


import OAuthSwift

import ARKit



class autentica: UIViewController {
    
    override func viewDidLoad() {
        share()
    }
    
    
    func share ()
    
    {
        
        let oauthswift = OAuth1Swift(
            consumerKey:    "ccf37759e7bee52788af6106a005fa17",
            consumerSecret: "bb035adc7faf55eb",
            requestTokenUrl: "https://www.flickr.com/services/oauth/request_token",
            authorizeUrl:    "https://www.flickr.com/services/oauth/authorize",
            accessTokenUrl:  "https://www.flickr.com/services/oauth/access_token"
        )
        // authorize
        let handle = oauthswift.authorize(
        withCallbackURL: URL(string: "oauth-swift://oauth-callback/twitter")!) { result in
            switch result {
            case .success(let (credential, response, parameters)):
                print(credential.oauthToken)
                print(credential.oauthTokenSecret)
                print(parameters["user_id"])
            // Do your request
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
        
    }
}
