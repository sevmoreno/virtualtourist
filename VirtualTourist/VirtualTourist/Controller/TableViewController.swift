//
//  TableViewController.swift
//  VirtualTourist
//
//  Created by Juan Moreno on 6/11/19.
//  Copyright © 2019 Juan Moreno. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class TableViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, XMLParserDelegate, UINavigationBarDelegate {
  
    @IBOutlet weak var mapa: MKMapView!
    @IBOutlet weak var proCollection: UICollectionView!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var noPictures: UILabel!
    

    private let reuseIdentifier = "photoID"
    
    
    @IBOutlet weak var newcollectionButton: UIButton!
    
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(loadList), name: NSNotification.Name(rawValue: "load"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(activityInProgress), name: NSNotification.Name(rawValue: "download"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(activityEnd), name: NSNotification.Name(rawValue: "enddownload"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(nopic), name: NSNotification.Name(rawValue: "nopictures"), object: nil)
        
   //     DispatchQueue.main.async {
   //         self.proCollection.reloadData()
        
   //     }
        
    
    }
    
    @objc func nopic ()
    {
    
        noPictures.isEnabled = true
        
    
    }
    
    @objc func activityEnd(){
        
        newcollectionButton.isEnabled = true
        newcollectionButton.isHidden = false
        activityIndicator.isHidden = true
        activityIndicator.stopAnimating()
        
        
    }
    
    @objc func activityInProgress(){
        
       newcollectionButton.isEnabled = false
       newcollectionButton.isHidden = true
       activityIndicator.isHidden = false
       activityIndicator.startAnimating()
        
     
    }
    
    @objc func loadList(){
        
        DispatchQueue.main.async {
            
           self.proCollection.reloadData()
        }//load data here
        
    }

    override func viewDidLoad() {
       
   //     super.viewDidLoad()
        
        proCollection.dataSource = self
        proCollection.delegate = self
  
        
       // newcollectionButton.isHidden = true
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        
        // TO DO:
        // 1 - DISPLAY LOCATION IN THE MAP -----------
        
        let location = MKPointAnnotation()
        // london.title = "London"
        location.coordinate = CLLocationCoordinate2D(latitude: photoInfo.shared.lat, longitude: photoInfo.shared.lon)
        
        let viewRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: 20000, longitudinalMeters: 20000)
        mapa.setRegion(viewRegion, animated: false)
        mapa.showsPointsOfInterest = true
        mapa.addAnnotation(location)
        
        photoInfo.shared.collection.removeAll()
        photoInfo.shared.collectionImage.removeAll()
        // --------------------------------------------
        
        // 2 - CHECK IF THE SELECTED COORDINATE HAVE A
        // OBJET WITH PHOTOS
        
        let a = checkLocationContent(latitud: photoInfo.shared.lat, longitud: photoInfo.shared.lon)
        
        if a == true
        {
           newcollectionButton.isEnabled = true
           activityIndicator.isHidden = true

            
  
        //  LOAD DATA FROMM CORE DATA
            
            guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                    return
            }
            
            let managedContext =
                appDelegate.persistentContainer.viewContext
            
            let fetchrequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            let predicate = NSPredicate (format: "pin == %@" ,photoInfo.shared.pinSelected )
            fetchrequest.predicate = predicate
            
            if let listaPhotos = try? managedContext.fetch(fetchrequest)
            
            {
                print("Lista de fotos \(listaPhotos.count)")
                var  c = 0
                repeat {
              let temp = toSaveDisplay(Imagen: listaPhotos[c].imagen, ImagenURL: listaPhotos[c].imageURL, photoID: listaPhotos[c].photoID, userID: listaPhotos[c].userID)
                    photoInfo.shared.collectionImage.append(temp)
                 c = c + 1
                } while c < listaPhotos.count
              
            }
  
            
  
        // ------------------------
        }
            
        else
            
        {
            
            photoApi.collectionGenerator()
           // newcollectionButton.isEnabled = true
           // activityIndicator.isHidden = false
           // activityIndicator.startAnimating()
           // photoInfo.shared.collection.removeAll()
//            photoInfo.shared.collectionImage.removeAll()
//photoApi.collectionGenerator()
           // newcollectionButton.isEnabled = true
            
           /*
//----------------------------------------------------------
// IN CASE THAT DOESNT HAVE PARSE PHOTO FROM API

            photoApi.requestData { (data,response, error) in
            
            guard let data=data else {
                print("NO DATA ERROR")
                return
            }

            print("Data Cargo")
            print(data)
           
            photoApi.readData(data: data)
            
// ----------------------------------------------------------------------------------------------
            // GENERAR LINKS FL
            // USAR LINK BAJAR FOTO
            // GUARDAR FOTOS EN PERSISTENT STORE

            //   photoInfo.collectionGenerator()
//  ---------------------------------------------------------------------------------------------
            
            var c: Int = 0
            
 // mmmmmmmmmmm
                
                // ACCESO SEGURO AL CONTEXTO
                guard let appDelegate =
                    UIApplication.shared.delegate as? AppDelegate else {
                        return
                }
                
                let managedContext =
                    appDelegate.persistentContainer.viewContext
                
                
                
 // mmmmmmmmmmmmmmmmm
                
            print("Collection count: \(photoInfo.shared.collection.count)")
                
            for index in photoInfo.shared.collection {
                
                let ImagenURL = "https://farm\(photoInfo.shared.collection[c].farm).staticflickr.com/\(photoInfo.shared.collection[c].server)/\(photoInfo.shared.collection[c].id)_\(photoInfo.shared.collection[c].secret)_m.jpg"
                let imagenTemp = photoInfo.imageDownload(UrlString: ImagenURL)
                
                //  let imagenTemp = UIImage(named: "duck.jpg")

                
                let temp = toSaveDisplay(Imagen: imagenTemp.pngData(), ImagenURL: ImagenURL, photoID: photoInfo.shared.collection[c].id, userID: photoInfo.shared.collection[c].owner)
                photoInfo.shared.collectionImage.append(temp)
                
                    DispatchQueue.main.async {
                    self.proCollection.reloadData()
                    }
 
                // mmmmmmmmmmmmmmmm
                // SAVING TO CORE DATA
                
                var photof = Photo(context: managedContext)
                photof.pin = photoInfo.shared.pinSelected
               // photof.imagen = photoInfo.shared.collectionImage[c].Imagen?.
                photof.imagen = photoInfo.shared.collectionImage[c].Imagen
                photof.imageURL = photoInfo.shared.collectionImage[c].ImagenURL
                photof.photoID = photoInfo.shared.collectionImage[c].photoID
                photof.userID = photoInfo.shared.collectionImage[c].userID
                try? managedContext.save()
                
                // mmmmmmmmmmmmmmmmmmm
            
                
                
                print ("Saved \(c) photo")
                c+=1
                
            }
                //while c <  photoInfo.shared.collection.count - 1
      
  // ----------------------------------------------------------------------------------------------
            }
 
*/
            
        
        }
  // ----------------------------------------------------------------------------------------------
        // SAVE DATA IN PERSISTANT STORE
    print("Collection Image count \(photoInfo.shared.collectionImage.count)")
   //    saveDatainPersistanStore()
        
        
    }

  

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return photoInfo.shared.collectionImage.count
        //return The number of rows in section.
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "photoID", for: indexPath) as! CollectionViewCell
        
      
        let counter = indexPath.row
        if let data = photoInfo.shared.collectionImage[counter].Imagen
        {
            cell.photoOnline.image = UIImage (data: data)
        }
       // cell.photoOnline.image = photoInfo.shared.collectionImage[counter].Imagen
        cell.labelCox.textColor = UIColor.white
        cell.labelCox.text = photoInfo.shared.collectionImage[counter].photoID
        print(counter)
       // print(cell.labelCox.text?)
        
     //   print(cell.photoOnline.image)
        
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        shouldSelectItemAt indexPath: IndexPath) -> Bool {
    
        print("Seleccionada")
        let notetodelete = photoInfo.shared.collectionImage.remove(at: indexPath.row)
        
        DispatchQueue.main.async {
            self.proCollection.reloadData()
        }
        
        //  LOAD DATA FROMM CORE DATA
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
               return false
                
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        let fetchrequest: NSFetchRequest<Photo> = Photo.fetchRequest()
       // let predicate = NSPredicate (format: "pin == %@" ,photoInfo.shared.pinSelected)
       // fetchrequest.predicate = predicate
        
        let predicatephoto = NSPredicate(format: "pin == %@", photoInfo.shared.pinSelected)
        let predicateURL = NSPredicate(format: "photoID == %@", notetodelete.photoID!)
        
        let subpredicates: [NSPredicate]
        
        subpredicates = [ predicatephoto, predicateURL ]
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
        
        fetchrequest.predicate = compoundPredicate
        
        let fotoToDelete = try? managedContext.fetch(fetchrequest)
        
        if fotoToDelete == nil
        {
            
        } else {
                for each in fotoToDelete!
                    {
        
                            managedContext.delete(each)
        
                            try? managedContext.save()
        
                    }
        }
        return true
        
    }
    
// --------------------------- DELETE ALL DATA --------------------------
// -----------------------------------------------------------------------
    
    @IBAction func deleteCollection(_ sender: Any) {
        
        
        // DELET DATA FORM ARRAY AND STORE
        photoInfo.shared.collectionImage.removeAll()
        
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        DispatchQueue.main.async {
            self.proCollection.reloadData()
        }
        
        
        let fetchrequest: NSFetchRequest<Photo> = Photo.fetchRequest()
        let predicate = NSPredicate (format: "pin == %@" ,photoInfo.shared.pinSelected )
        fetchrequest.predicate = predicate
        
        if let listaPhotos = try? managedContext.fetch(fetchrequest)
        {
            for index in listaPhotos{
            managedContext.delete(index)
            }
             try? managedContext.save()
        }
        
        else {
            print("No se pudo borrar")
        }
        
        
        // -----------------------------------
        // NEW DATA REQUEST.
        
        photoApi.collectionGenerator()
    }
    
    
 // --------------------------------------------------------------
    
    func checkLocationContent (latitud: Double, longitud: Double) -> Bool?
    
    {
        
        var checkConent: Bool = false
        
        // ACCESO SEGURO AL CONTEXTO
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        
        // CREAMOS UN TIPO FETCH REQUEST PARA BUSCAR DENTRO DE PIN
        let fetchrequest: NSFetchRequest<Pin> = Pin.fetchRequest()
        

        // CREAMOS PARAMETROS PARA BUSCAR EN EL FETCH
        // EN ESTAS LINEAS SE CONVIERTE A NSNumber para tener precision
        // https://knowledge.udacity.com/questions/41334
        
        let latitudeNumber = NSNumber.init(value: latitud)
        let longitudeNumber = NSNumber.init(value: longitud)
 
        let predicateLatitude = NSPredicate(format: "latitud == %@", latitudeNumber)
        let predicateLongtitude = NSPredicate(format: "longitud == %@", longitudeNumber)
        
       // Simpre predicate no funciona ya que tenemos que comparar dos elementos
       // fetchrequest.predicate = predicateLatitude
        
        // A compound predicate created directly
        let subpredicates: [NSPredicate]
        
        subpredicates = [ predicateLongtitude, predicateLatitude ]
        
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: subpredicates)
 
        fetchrequest.predicate = compoundPredicate

        // DESDE EL CONTEX EJECUTAMOS EL FETCH
        //---------------------------------------------------------------------------------------
        
        if let resultado = try? managedContext.fetch(fetchrequest)
        {
            print("Resultado \(resultado)")
            // we STORE THE SELECTED PIN TO USE IT
            
            photoInfo.shared.pinSelected = resultado[0]
            
           
            
            // TENEMOS UN OBJETO PIN AHORA BUSCAMOS LOS PHOTO DE CORE DATA asocioados con ese PIN
            // ----------------------------------------------------------------------------------
            
            let fetchrequest: NSFetchRequest<Photo> = Photo.fetchRequest()
            let predicate = NSPredicate (format: "pin == %@" ,photoInfo.shared.pinSelected )
            fetchrequest.predicate = predicate
            
            if let listaPhotos = try? managedContext.fetch(fetchrequest)
            
            {
                if listaPhotos.isEmpty
                    {
                print("Que Encontro \(checkConent)")
                checkConent = false
                    }
               else
                
                    {
                print("PHOTO CONTENT IN CORE DATA")
                print(listaPhotos.count)
                print(listaPhotos)
                checkConent = true
           
                    }
            }
        else {
            print("Problems in Fetch")
        }
        print(checkConent)
        
    }
    return checkConent
    
    }
    
    
    
}




