//
//  ResultsMapViewController.swift
//  Yelp
//
//  Created by Liqiang Ye on 9/24/17.
//  Copyright © 2017 Timothy Lee. All rights reserved.
//

import UIKit
import MapKit

class ResultsMapViewController: UIViewController {

    @IBOutlet weak var resultsMapView: MKMapView!
    
    var businesses: [Business]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // set the region to display, this also sets a correct zoom level
        // set starting center location in San Francisco
        let centerLocation = CLLocation(latitude: 37.7833, longitude: -122.4167)
        goToLocation(location: centerLocation)
        var corrdinate = CLLocationCoordinate2D(latitude: 37.7833, longitude: -122.4167)
        
        for (index, business) in businesses.enumerated() {
            
            if let latitude = business.latitude, let longitude = business.longitude {
                corrdinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                addAnnotationAtCoordinate(coordinate: corrdinate, title: "\(index)")
            }
        }
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Map view functions
    
    func goToLocation(location: CLLocation) {
        let span = MKCoordinateSpanMake(0.1, 0.1)
        let region = MKCoordinateRegionMake(location.coordinate, span)
        resultsMapView.setRegion(region, animated: false)
    }
    
    // add an Annotation with a coordinate: CLLocationCoordinate2D
    func addAnnotationAtCoordinate(coordinate: CLLocationCoordinate2D, title: String) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = title
        resultsMapView.addAnnotation(annotation)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
