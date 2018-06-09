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
    @IBOutlet weak var sendButton: UIButton!
    
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
            if carName == "a" {
                
            }
            
            if carName == "b" {
                performSegue(withIdentifier: "toEmergencyCarViewController", sender: self)
            }
        }
        self.carNameTextField.text = ""
    }

    
    @IBAction func unwindFromRegularCarVC(_ segue: UIStoryboardSegue) {
        let regularCarViewController: RegularCarViewController = segue.source as! RegularCarViewController
        regularCarViewController.locationManager.stopUpdatingLocation()
    }
    
    @IBAction func unwindFromEmergencyCarVC(_ segue: UIStoryboardSegue) {
        
    }
}

