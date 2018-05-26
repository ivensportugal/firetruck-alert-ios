//
//  ViewController.swift
//  FiretruckAlert
//
//  Created by iportuga on 2018-05-26.
//  Copyright © 2018 Ivens Portugal. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: Properties
    
    @IBOutlet weak var requestTextField: UITextField!
    @IBOutlet weak var responseTextField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    
    let URL_WEB_SERVER = "http://192.168.56.101:8000/api/trucks"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //MARK: Actions
    
    // Sends information to the web server
    @IBAction func sendRequest(_ sender: UIButton) {
        
        // create NSURL
        let requestURL = URL(string: URL_WEB_SERVER)
        
        // create NSMutableURLRequest
        var request = URLRequest(url: requestURL!)
        
        // set the method to POST
        request.httpMethod = "GET"
        
        // get values from textField
        let letter = requestTextField.text!
        
        // set the POST parameters
        //let postParameters = "letter="+letter
        let postParameters = "name=Ivens&email=ivensportugal&previewAccess=yes&theme=UWaterloo"
        
        // set parameters to body
        //request.httpBody = postParameters.data(using: String.Encoding.utf8)
        
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
                    //response = parseJSON["capitalizedLetter"] as! String?
                    
                    print("answer")
                    print(parseJSON)
                    /*
                    // add response to textfield
                    DispatchQueue.main.async {
                        self.responseTextField.text = response
                    }*/
                }
            } catch {
                print(error)
            }
        }
        
        // execute the task
        task.resume()
    }
}

