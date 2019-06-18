//
//  ViewController.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/10/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, MKMapViewDelegate {
    
    
    // TO DO
    // 1 - EL MAP RECIBE UN ARRAY DE CLLLOCATIONS
    // TENGO QUE TRAER DE CORE DATA Y LLENAR UN ARRAY CON LA INFO DE CADA PIN
    // CON ESO LEO LO QUE TENGO
    
    // 2 - DETERMINAR QUE PASA CUANDO UNO HACE CLICK EN LA LOCACION
    // BAJAR LAS FOTOS DE LA LOCACION
    // https://www.flickr.com/services/api/flickr.photos.geo.photosForLocation.html
    // https://www.flickr.com/services/api/misc.urls.html
    
    

   var pins: [NSManagedObject] = []
   
   var annotations = [MKPointAnnotation]()
    
    @IBOutlet weak var mapConnection: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapConnection.delegate = self
        loadPins()
    //    let london = MKPointAnnotation()
    //    london.title = "London"
     //   london.coordinate = CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275)
        mapConnection.addAnnotations(annotations)
        
        // Generate long-press UIGestureRecognizer.
        let myLongPress: UILongPressGestureRecognizer = UILongPressGestureRecognizer()
        myLongPress.addTarget(self, action: #selector(recognizeLongPress(_:)))
        
        // Added UIGestureRecognizer to MapView.
        mapConnection.addGestureRecognizer(myLongPress)
        
    
        
    }

    @objc func recognizeLongPress(_ sender: UILongPressGestureRecognizer) {
        // Do not generate pins many times during long press.
        if sender.state != UIGestureRecognizer.State.began {
            return
        }
        
        // Get the coordinates of the point you pressed long.
        let location = sender.location(in: mapConnection)
        
        // Convert location to CLLocationCoordinate2D.
        let myCoordinate: CLLocationCoordinate2D = mapConnection.convert(location, toCoordinateFrom: mapConnection)
        
        // Generate pins.
        let myPin: MKPointAnnotation = MKPointAnnotation()
        
        // Set the coordinates.
        myPin.coordinate = myCoordinate
        
        // Set the title.
     //   myPin.title = "title"
        
        // Set subtitle.
      //  myPin.subtitle = "subtitle"
        
        // Added pins to MapView.
        mapConnection.addAnnotation(myPin)
        save(latitud: myCoordinate.latitude, longitud: myCoordinate.longitude)
        
    }
 
    /*
    // Delegate method called when addAnnotation is done.
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        let myPinIdentifier = "PinAnnotationIdentifier"
        
        // Generate pins.
        let myPinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: myPinIdentifier)
        
        // Add animation.
        myPinView.animatesDrop = true
        
        // Display callouts.
        myPinView.canShowCallout = true
        
        // Set annotation.
        myPinView.annotation = annotation
        
        print("latitude: \(annotation.coordinate.latitude), longitude: \(annotation.coordinate.longitude)")
        
        return myPinView
    }

   */
    
    func save(latitud: Double, longitud: Double) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Pin",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        // 3
        person.setValue(latitud, forKeyPath: "latitud")
        person.setValue(longitud, forKeyPath: "longitud")
        
        // 4
        do {
            try managedContext.save()
            pins.append(person)
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    
    func loadPins ()
    {
        
        //1
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "Pin")
        
        //3
        do {
            pins = try managedContext.fetch(fetchRequest)
            
            print("Cantidad de Elementos \(pins.count)")
            var position = 0
            
            
            repeat {
                
            let lat1 = pins[position].value(forKeyPath: "latitud") as? Double
            let long1 = pins[position].value(forKeyPath: "longitud") as? Double
            
                
            print("ELEMENTO \(position)")
                print(lat1!)
                print(long1!)
                
            let coordinate = CLLocationCoordinate2D(latitude: lat1!, longitude: long1!)
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
         //   annotation.title = "\(first) \(last)"
       //     annotation.subtitle = mediaURL
        
                
            self.annotations.append(annotation)

            
            position = position + 1
                
            } while position < pins.count
            
            
        
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
    }
    
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        
          print("Latitud intem seleccionado")
          performSegue(withIdentifier: "toGallery", sender: nil)
            
        
    }
   // func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
     //   let urlLink = view.annotation!.coordinate.latitude as Double
        
     //   print("Latitud intem seleccionado \(urlLink)")
        
        
   // let urlString = "http://" + urlLink
  //      if let url = URL(string: urlString ) {
  //          UIApplication.shared.open(url, options: [:])
  //      }
        
   // }

}


