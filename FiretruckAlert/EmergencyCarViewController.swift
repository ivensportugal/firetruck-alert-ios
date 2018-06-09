//
//  EmergencyCarViewController.swift
//  FiretruckAlert
//
//  Created by iportuga on 2018-06-09.
//  Copyright © 2018 Ivens Portugal. All rights reserved.
//

import UIKit
import MapKit

class EmergencyCarViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: - Properties
    let locationManager = CLLocationManager()
    @IBOutlet weak var mapView: MKMapView!
    var destinationPlacemark: MKPlacemark?
    var route: MKRoute?
    
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
        
        // Zoom map on the user location
        mapView.showsUserLocation = true
        let userRegion: MKCoordinateRegion = MKCoordinateRegion(center: mapView.userLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2))
        mapView.setRegion(userRegion, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Private Methods
    
    func getFinalDestination(gestureRecognizer: UILongPressGestureRecognizer) {
        if gestureRecognizer.state != UIGestureRecognizerState.ended {
            let touchLocation = gestureRecognizer.location(in: mapView)
            let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
            destinationPlacemark = MKPlacemark(coordinate: locationCoordinate)
            return
        }
        if gestureRecognizer.state != UIGestureRecognizerState.began {
            return
        }
    }
    
    
    // Displays routes on the map
    func plotPolyline(route: MKRoute) {
        mapView.add(route.polyline)
        mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)
    }
    
    
    // Shows the routes
    func showRoute(route: MKRoute) {
        plotPolyline(route: route)
    }
    

    // Sends data to the webserver
    func sendStreetNamesToServer(streetNames: [String]) {
        
        // create NSURL
        let requestURL = URL(string: URL_WEB_SERVER)
        
        // create NSMutableURLRequest
        var request = URLRequest(url: requestURL!)
        
        // set the method to POST
        request.httpMethod = "POST"
        
        // set the POST parameters
        var postParameters = "path=["
        for s in streetNames {
            postParameters.append("," + s)
        }
        postParameters.append("]")
        
        
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
    
    
    
    // MARK: - Actions
    
    @IBAction func calculateRoute(_ sender: UIButton) {
        
        let request: MKDirectionsRequest = MKDirectionsRequest()
        request.source = MKMapItem(placemark: MKPlacemark(coordinate: mapView.userLocation.coordinate))
        request.destination = MKMapItem(placemark: destinationPlacemark!)
        
        request.requestsAlternateRoutes = false
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate(completionHandler: ({ (response, error) in
            if let routeResponse = response?.routes {
                self.route = routeResponse.sorted(by: {$0.expectedTravelTime < $1.expectedTravelTime})[0]
                self.showRoute(route: self.route!)
            } else if let _ = error {
                
            }
            }))
    }
    
    @IBAction func confirmRoute(_ sender: Any) {
        
        // Get points
        let pointCount = self.route!.polyline.pointCount
        var cArray = UnsafeMutablePointer<CLLocationCoordinate2D>.allocate(capacity: pointCount)
        route!.polyline.getCoordinates(cArray, range: NSMakeRange(0, pointCount))
        
        // Iterate on points and get street names
        var addressSet: Set<String> = Set<String>()
        for c in UnsafeBufferPointer(start: cArray, count: pointCount) {
            addressSet.insert(MKPlacemark(coordinate: c).thoroughfare!)
        }
        
        // Send street names to server
        
    }
    
    
    
    // MARK: - MapViewDelegate
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polylineRenderer = MKPolylineRenderer(overlay: overlay)
        if overlay is MKPolyline {
            polylineRenderer.strokeColor = UIColor.green.withAlphaComponent(0.75)
        }
        
        return polylineRenderer
    }
    
    

}
