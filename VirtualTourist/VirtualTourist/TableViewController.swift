//
//  TableViewController.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/11/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import MapKit

class TableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
 
   
    
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var proCollection: UICollectionView!
    
    private let reuseIdentifier = "photoID"
    
    let dummyData = ""
    
    let apiKey = "ccf37759e7bee52788af6106a005fa17"
    
    private let itemsPerRow: CGFloat = 3

    override func viewDidLoad() {
        
        super.viewDidLoad()
        proCollection.dataSource = self
        proCollection.delegate = self
        
    }

     //var searches: [] = []
     //let flickr = Flickr()

    
    // let sectionInsets = UIEdgeInsets(top: 50.0,
     //                                        left: 20.0,
     //                                        bottom: 50.0,
      //                                       right: 20.0)

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 8
        //return The number of rows in section.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoID", for: indexPath) as! CollectionViewCell
        
        cell.labelCox.textColor = UIColor.white
        cell.labelCox.text = "Temporario"
        
        
        return cell
        
    }
    
    
    
}




/*

// MARK: - Private
extension TableViewController {
   
    
  
        //1
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 4
   //         return photoInfo.shared.collection.count
        }
        
      //2
    func collectionView(_ collectionView: UICollectionView,
                                     numberOfItemsInSection section: Int) -> Int {
            return 1
        }
 
    
        //3
    func collectionView(
            _ collectionView: UICollectionView,
            cellForItemAt indexPath: IndexPath
            ) -> UICollectionViewCell {
            let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
            cell.backgroundColor = .black
            // Configure the cell
            return cell
        }
  
    // ------

    //1
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //2
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    //3
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // 4
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
  
    



}
*/
