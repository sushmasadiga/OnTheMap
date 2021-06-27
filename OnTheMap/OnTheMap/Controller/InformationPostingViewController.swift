//
//  InformationPostingViewController.swift
//  OnTheMap
//
//  Created by Sushma Adiga on 27/06/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class InformationPostingViewController: UIViewController {
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    var placemark:  CLPlacemark?
    var mapString: String?
    var mediaURL: String?
    
    @IBOutlet weak var locationTextField: UITextField!
    
    @IBOutlet weak var profileLinkTextField: UITextField!
    @IBOutlet weak var FindLocationButton: UIButton!
    
    var segueIdentifier: String = ""

    override func viewDidLoad() {
      super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(animated)
           locationTextField.text = ""
           profileLinkTextField.text = ""
           navigationController?.setNavigationBarHidden(false, animated: animated)
       }
    
    @IBAction func cancelAddLocation(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func findLocationTapped(_ sender: Any) {
        if (self.profileLinkTextField.text != "") {
            self.findLocation()
        }
        else {
            self.showFindLocationFailure(message: "Link is Empty")
        }
    }
    func findLocation() {
        CLGeocoder().geocodeAddressString((self.locationTextField.text ?? ""), completionHandler: handleFindLocation(placemarks:error:))
    }
    
    func handleFindLocation(placemarks: [CLPlacemark]?, error: Error?) {
        if (placemarks != nil) {
            appDelegate.placemark = placemarks?[0]
            appDelegate.mapString = self.locationTextField.text
            appDelegate.mediaURL = self.profileLinkTextField.text

            self.performSegue(withIdentifier: "tabAddLocation", sender: nil)
        }
        else {
            showFindLocationFailure(message: "Geocoding Failed")
        }
    }
    
    func showFindLocationFailure(message: String) {
        let alertVC = UIAlertController(title: "Find Location Failed", message: message, preferredStyle: .alert)
        alertVC.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(alertVC, animated:true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: (Any)?) {
        let alvc = segue.destination as! AddLocationViewController
        alvc.placemark = placemark
        alvc.mapString = mapString
        alvc.mediaURL = mediaURL
        alvc.segueIdentifier = segueIdentifier
    }
}
