//
//  MapVC.swift
//  FoursquareClone
//
//  Created by Melih Yuvacı on 24.04.2022.
//

import UIKit
import MapKit
import Parse

class MapVC: UIViewController, MKMapViewDelegate , CLLocationManagerDelegate{

    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager = CLLocationManager()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItem.Style.plain, target: self, action: #selector(saveButtonClicked))
        navigationController?.navigationBar.topItem?.leftBarButtonItem=UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(backButtonClicked))
        
        mapView.delegate = self
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        let recognizer = UILongPressGestureRecognizer(target: self, action: #selector(chooseLocation(gestureRecognizer:)))
        recognizer.minimumPressDuration = 3
        mapView.addGestureRecognizer(recognizer)
        
    }
    
    @objc func chooseLocation(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touches = gestureRecognizer.location(in: self.mapView)
            let coordinates = self.mapView.convert(touches, toCoordinateFrom: self.mapView)
            
            let annatation = MKPointAnnotation()
            annatation.coordinate = coordinates
            annatation.title = PlaceModel.sharedInstance.placeName
            annatation.subtitle = PlaceModel.sharedInstance.placeType
            
            self.mapView.addAnnotation(annatation)
            
            PlaceModel.sharedInstance.placeLatitude = String (coordinates.latitude)
            PlaceModel.sharedInstance.placeLongitude = String(coordinates.longitude)
            
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.035, longitudeDelta: 0.035)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
    }
    
    @objc func saveButtonClicked(){
        //PARSE
        let placeModel = PlaceModel.sharedInstance
        
        let object = PFObject(className: "Places")
        object["name"] = placeModel.placeName
        object["type"] = placeModel.placeType
        object["atmosphere"] = placeModel.placeAtmosphere
        object["latitude"] = placeModel.placeLatitude
        object["longitude"] = placeModel.placeLongitude
        
        if let imageData = placeModel.placeImage.jpegData(compressionQuality: 0.5){
            object["image"] = PFFileObject(name: "image.jpg", data: imageData)
        }
        
        object.saveInBackground { success, error in
            if error != nil{
                let alert = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: UIAlertController.Style.alert)
                let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
                alert.addAction(okButton)
                self.present(alert, animated: true, completion: nil)
            }else{
                self.performSegue(withIdentifier: "fromMapVCtoPlacesVC", sender: nil)
            }
        }
    }
    @objc func backButtonClicked(){
        //navigationController?.popViewController(animated: true)
        self.dismiss(animated: true,completion: nil)
    }
}
