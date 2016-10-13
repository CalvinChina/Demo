//
//  CoreLocationViewController.swift
//  Swift3Demo
//
//  Created by pisen on 16/10/12.
//  Copyright © 2016年 丁文凯. All rights reserved.
//

import UIKit
import CoreLocation
import MapKit

class CoreLocationViewController: UIViewController ,CLLocationManagerDelegate ,MKMapViewDelegate{
    
    @IBOutlet weak var CLMKMapView: MKMapView!
    
    let locationManager = CLLocationManager()
    var myLatitude:CLLocationDegrees!
    var myLongitude:CLLocationDegrees!
    var finalLatitude:CLLocationDegrees!
    var finalLongitude:CLLocationDegrees!
    var distance:CLLocationDistance!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        let tap = UITapGestureRecognizer(target:self ,action:#selector(action(_ :)))
        CLMKMapView.addGestureRecognizer(tap)
        // Do any additional setup after loading the view.
    }

    func action(_ tap:UITapGestureRecognizer){
        let touchPoint = tap.location(in: self.CLMKMapView)
        let newCoord = CLMKMapView.convert(touchPoint, toCoordinateFrom: self.CLMKMapView)
        let getLat:CLLocationDegrees = newCoord.latitude
        let getLon = newCoord.longitude
        
        let newCoord2 = CLLocation(latitude:getLat ,longitude:getLon)
        let newCoord3 = CLLocation(latitude:myLatitude , longitude:myLongitude)
        
        finalLatitude = newCoord2.coordinate.longitude
        finalLongitude = newCoord2.coordinate.longitude
        print("Original Latitude: \(myLatitude)")
        print("Original Longitude: \(myLongitude)")
        print("Final Latitude: \(finalLatitude)")
        print("Final Longitude: \(finalLongitude)")
        
        
        let distance = newCoord2.distance(from: newCoord3)
        print("Distance between two points: \(distance)")
        let newAnnotation = MKPointAnnotation()
        newAnnotation.coordinate = newCoord
        newAnnotation.title = "ABC"
        newAnnotation.subtitle = "abc"
        CLMKMapView.addAnnotation(newAnnotation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        CLGeocoder().reverseGeocodeLocation(manager.location!) { (placemarks, error) in
            if(error != nil){
                print("reverseGeocodeLocation error:" + error!.localizedDescription)
                return
            }
            
            if  placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark
                self.displayLocationInfo(pm)
            }else{
                print("Problem with the data received from geocoder")
            }
        }
    }
    // 地址信息解析
    func displayLocationInfo(_ placemark:CLPlacemark?){
    
        if let containsPlacemark = placemark{
            locationManager.stopUpdatingLocation()
            
            let locality = (containsPlacemark.locality != nil) ? containsPlacemark.locality : ""
            let postalCode = (containsPlacemark.postalCode != nil) ? containsPlacemark.postalCode : ""
            let administrativeArea = (containsPlacemark.administrativeArea  != nil) ? containsPlacemark.country : ""
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : ""
            myLongitude = (containsPlacemark.location!.coordinate.longitude)
            myLatitude = (containsPlacemark.location!.coordinate.latitude)
            
            print("Locality: \(locality)")
            print("PostalCode: \(postalCode)")
            print("Area: \(administrativeArea)")
            print("Country: \(country)")
            print(myLatitude)
            print(myLongitude)
            
            let theSpan:MKCoordinateSpan = MKCoordinateSpanMake(0.1, 0.1)
            let location:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude:myLatitude,longitude:myLongitude)
            let theRegion:MKCoordinateRegion = MKCoordinateRegionMake(location,theSpan)
            
            CLMKMapView.setRegion(theRegion, animated: true)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error){
         print("Error while updating location " + error.localizedDescription)
    }
    
    func degreesToRadians(_ degrees: Double) -> Double { return degrees * M_PI / 180.0 }
    func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / M_PI }
    
    func getBearingBetweenTwoPoints1(_ point1:CLLocation , point2:CLLocation)  -> Double {
        let lat1 = degreesToRadians(point1.coordinate.latitude)
        let lon1 = degreesToRadians(point1.coordinate.longitude)
        let lat2 = degreesToRadians(point2.coordinate.latitude);
        let lon2 = degreesToRadians(point2.coordinate.longitude);
        
        print("Start latitude: \(point1.coordinate.latitude)")
        print("Start longitude: \(point1.coordinate.longitude)")
        print("Final latitude: \(point2.coordinate.latitude)")
        print("Final longitude: \(point2.coordinate.longitude)")
        
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y ,x)
        return radiansToDegrees(radiansBearing)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
