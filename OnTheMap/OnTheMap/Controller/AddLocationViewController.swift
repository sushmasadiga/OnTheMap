//
//  AddLocationViewController.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation
import UIKit
import MapKit

class AddLocationViewController: UIViewController, MKMapViewDelegate {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var placemark:  CLPlacemark?
    var mapString: String?
    var mediaURL: String?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var finishAddLocation: UIButton!
    
    var firstName: String = ""
    var lastName: String = ""
    var segueIdentifier: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        self.drawMap()
        self.getPublicUserInformation()
    }
    
    @IBAction func AddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishAddLocation(_ sender: Any) {
        self.createStudentLocation()
    }
    
    func createStudentLocation() {
        OTMClient.createStudentLocation(firstName: firstName, lastName: lastName, mapString: appDelegate.mapString ?? "", mediaURL: appDelegate.mediaURL ?? "", latitude: (appDelegate.placemark?.location!.coordinate.latitude)!, longitude: (appDelegate.placemark?.location!.coordinate.longitude)!, completion: self.handleCreateStudentLocation(success:error:))
    }
    
    func handleCreateStudentLocation(success: Bool, error: Error?) {
        if (success) {
            performSegue(withIdentifier: segueIdentifier, sender: self)
            self.dismiss(animated: true, completion: nil)
        }
        else {
            showFailure(failureType: "Can not create Student Location", message: error?.localizedDescription ?? "")
        }
    }
    
    func getPublicUserInformation() {
        OTMClient.getPublicUserData(completion: self.handleGetPublicUserData(response:error:))
    }
    
    func handleGetPublicUserData(response: User?, error: Error?) {
        if (response != nil) {
            firstName = response!.firstName
            lastName = response!.lastName
        }
        else {
            showFailure(failureType: "Unable to get Public User Data", message: error?.localizedDescription ?? "")
        }
    }
    
    func drawMap() {
        
        var annotations = [MKPointAnnotation]()
        let annotation = MKPointAnnotation()
        if( appDelegate.placemark?.location?.coordinate != nil) {
            annotation.coordinate = (appDelegate.placemark?.location?.coordinate)!
        }
        annotation.title = appDelegate.mapString
        annotations.append(annotation)
        
        self.mapView.addAnnotations(annotations)
        self.mapView.setRegion(MKCoordinateRegion(center:annotation.coordinate, latitudinalMeters: 0.01, longitudinalMeters: 0.01), animated:true)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        let reuseId = "pin"
        
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: reuseId) as? MKPinAnnotationView
        
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
            pinView!.canShowCallout = true
            pinView!.pinTintColor = .red
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            let app = UIApplication.shared
            if let toOpen = view.annotation?.subtitle! {
                app.open(URL(string: toOpen)!)
            }}
    }
    
    func showFailure(failureType: String, message: String) {
        let alertVC = UIAlertController(title: failureType, message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }
    
    @IBAction func backToMap(_ sender: Any) {
        performSegue(withIdentifier: "unwindToMap", sender: self)
    }
    
    @IBAction func backToList(_ sender: Any) {
        performSegue(withIdentifier: "unwindToList", sender: self)
    }
    
}
