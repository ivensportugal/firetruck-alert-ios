//
//  ViewController.swift
//  FiretruckAlert
//
//  Created by iportuga on 2018-05-26.
//  Copyright © 2018 Ivens Portugal. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    
    // MARK: - Properties
    @IBOutlet weak var carNameTextField: UITextField!
    let URL_WEB_SERVER = "http://192.168.56.101:8000/api/cars/createCar"
    
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
        let postParameters = "carName="+carName
        
        
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
                    
                    var response: String!
                    response = parseJSON["carName"] as! String?
                    
                    if response == "regular" {
                        self.performSegue(withIdentifier: "toRegularCarViewController", sender: self)
                    }
                    else if response == "emergency" {
                        self.performSegue(withIdentifier: "toEmergencyCarViewController", sender: self)
                    }
                    
                }
            } catch {
                print(error)
            }
            
        }
        
        // execute the task
        task.resume()
    }
}

