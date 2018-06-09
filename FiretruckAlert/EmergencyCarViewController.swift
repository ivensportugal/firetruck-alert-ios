//
//  EmergencyCarViewController.swift
//  FiretruckAlert
//
//  Created by iportuga on 2018-06-09.
//  Copyright © 2018 Ivens Portugal. All rights reserved.
//

import UIKit
import MapKit

class EmergencyCarViewController: UIViewController, CLLocationManagerDelegate {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    
    let URL_WEB_SERVER = "http://192.168.56.101:8000/api/cars/createCar"

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Ask for authorization.
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
