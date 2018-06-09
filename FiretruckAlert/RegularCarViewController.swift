//
//  RegularCarViewController.swift
//  FiretruckAlert
//
//  Created by iportuga on 2018-06-09.
//  Copyright © 2018 Ivens Portugal. All rights reserved.
//

import UIKit
import MapKit

class RegularCarViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    let URL_WEB_SERVER = "http://192.168.56.101:8000/api/cars/createCar"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ask for authorization.
        self.locationManager.requestAlwaysAuthorization()
        
        // Allows background location updates.
        locationManager.allowsBackgroundLocationUpdates = true
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
        locationManager.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - CLLocationManagerDelegate methods
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Captures coordination points
        if let location: CLLocation = manager.location {
            print("locations = \(location.coordinate.latitude) \(location.coordinate.longitude)")
            
            // Converts location to road name.
            lookUpCurrentLocation(location: manager.location!, completionHandler: sendPostDataToServer)
            
        }
    }
    
    func lookUpCurrentLocation(location: CLLocation, completionHandler: @escaping (String) -> Void) {
        let geocoder = CLGeocoder()
        
        // Look up the location and pass it to the completion handler
        geocoder.reverseGeocodeLocation(location, completionHandler: {(placemarks, error) in
            if error == nil {
                if let street = placemarks?[0].thoroughfare {
                    completionHandler(street)
                }
            }
        })
    }
    
    
    
    //MARK: Private methods
    // Sends data to the webserver
    func sendPostDataToServer(street: String) {
        
        // create NSURL
        let requestURL = URL(string: URL_WEB_SERVER)
        
        // create NSMutableURLRequest
        var request = URLRequest(url: requestURL!)
        
        // set the method to POST
        request.httpMethod = "POST"
        
        // set the POST parameters
        let postParameters = "street="+street
        
        
        // set parameters to body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        // create a task to send POST requests
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error is \(error ?? "could not read the error" as! Error)")
                return
            }

        }
        
        // execute the task
        task.resume()
    }
 
    

}
