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
    @IBOutlet weak var findLocationButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTextField.text = ""
        profileLinkTextField.text = ""
        self.activityIndicator.isHidden = true
        self.activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
            handleActivityIndicator(true)
            self.showFindLocationFailure(message: "Link is Empty")
        }
    }
    
    func findLocation() {
        handleActivityIndicator(true)
        CLGeocoder().geocodeAddressString((self.locationTextField.text ?? ""), completionHandler: handleFindLocation(placemarks:error:))
    }
    
    func handleFindLocation(placemarks: [CLPlacemark]?, error: Error?) {
        if (placemarks != nil) {
            handleActivityIndicator(false)
            appDelegate.placemark = placemarks?[0]
            appDelegate.mapString = self.locationTextField.text
            appDelegate.mediaURL = self.profileLinkTextField.text
            
            self.performSegue(withIdentifier: "tabAddLocation", sender: nil)
        }
        else {
            handleActivityIndicator(false)
            showFindLocationFailure(message: "Geocoding Failed")
        }
    }
    
    func handleActivityIndicator(_ isFinding: Bool) {
        isFinding ? activityIndicator.startAnimating() : activityIndicator.stopAnimating()
    }
}
