//
//  ViewController.swift
//  FiretruckAlert
//
//  Created by iportuga on 2018-05-26.
//  Copyright © 2018 Ivens Portugal. All rights reserved.
//

import UIKit
import MapKit


class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var carNameTextField: UITextField!
    let URL_WEB_SERVER = "http://192.168.56.101:8000/api/cars/name"
    var carID: String!
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Actions
    
    // Starts communication with the web server
    @IBAction func sendRequest(_ sender: UIButton) {
        
        // get values from textField
        if let carName = carNameTextField.text {
            sendCarNameToServer(carName: carName)
        }
        self.carNameTextField.text = ""
    }

    
    @IBAction func unwindFromRegularCarVC(_ segue: UIStoryboardSegue) {
        let regularCarViewController: RegularCarViewController = segue.source as! RegularCarViewController
        regularCarViewController.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func unwindFromEmergencyCarVC(_ segue: UIStoryboardSegue) {
        
    }
    
    
    
    
    
    //MARK: Private methods
    // Sends data to the webserver
    func sendCarNameToServer(carName: String) {
        
        // create NSURL
        let requestURL = URL(string: URL_WEB_SERVER)
        
        // create NSMutableURLRequest
        var request = URLRequest(url: requestURL!)
        
        // set the method to POST
        request.httpMethod = "POST"
        
        // set the POST parameters
        let postParameters = "name="+carName
        
        
        // set parameters to body
        request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
        // create a task to send POST requests
        let task = URLSession.shared.dataTask(with: request) {
            data, response, error in
            
            if error != nil {
                print("error is \(error ?? "could not read the error" as! Error)")
                return
            }
            
            // parse the response
            do {
                
                // convert response to NSDictionary
                let myJSON = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? NSDictionary
                
                // parse the JSON
                if let parseJSON = myJSON {
                    
                    var carType: String!
                    carType = parseJSON["carType"] as! String?
                    
                    let id: Int = parseJSON["id"] as! Int
                    self.carID = String(id)
                    
                    
                    if carType == "regular" {
                        DispatchQueue.main.async {self.performSegue(withIdentifier: "toRegularCarViewController", sender: self)}
                    }
                    else if carType == "emergency" {
                        DispatchQueue.main.async {self.performSegue(withIdentifier: "toEmergencyCarViewController", sender: self)}
                    }
                    
                }
            } catch {
                print(error)
            }
            
        }
        
        // execute the task
        task.resume()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let destinationViewController = segue.destination as? RegularCarViewController {
            destinationViewController.carID = self.carID
            destinationViewController.locationManager = self.locationManager
        } else if let destinationViewController = segue.destination as? EmergencyCarViewController {
            destinationViewController.carID = self.carID
            destinationViewController.locationManager = self.locationManager
        }
    }
}

