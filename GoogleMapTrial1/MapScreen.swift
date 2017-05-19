//
//  ViewController.swift
//  GoogleMapTrial1
//
//  Created by Khaled Elfakharany on 5/18/17.
//  Copyright © 2017 Khaled Elfakharany. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import YelpAPI
import BrightFutures
import CoreLocation

class MapScreen: UIViewController , GMSMapViewDelegate {
    let appId = "q63Cg4PkPST1DGuumIFkrg"
    let appSecret = "zV2guR6QyCJVS3X7sYdSRJoBkFTHHKtXIqTGTyF3HthkUEWxlwxHEGudF9hPXDKg"
    var places = [Place]()
    let locationManager = CLLocationManager()
    var lat : Double!
    var long : Double!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activity.startAnimating()
        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()
        
        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self as? CLLocationManagerDelegate
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        long = Double((locationManager.location?.coordinate.longitude)!)
        lat = Double((locationManager.location?.coordinate.latitude)!)
        
        downloadPlaces(long: long, lat: lat) {
            self.activity.stopAnimating()
            self.loadingView.isHidden = true
            let camera = GMSCameraPosition.camera(withLatitude: self.lat, longitude: self.long, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.isMyLocationEnabled = true
            self.view = mapView
            for item in self.places {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)
                marker.map = mapView
            }
            mapView.delegate = self
        }
        
    }
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        mapView.selectedMarker = marker
        return true
    }
    func mapView(_ mapView: GMSMapView, markerInfoContents marker: GMSMarker) -> UIView? {
        let infoView = UIView()
        infoView.frame = CGRect(x: 0, y: 0, width: 100, height: 80)
        let nameLbl = UILabel()
        nameLbl.frame = CGRect(x: 0, y: 0, width: 100, height: 40)
        nameLbl.font = UIFont(name: "Avenir-Black", size: 12)
        nameLbl.numberOfLines = 2
        infoView.addSubview(nameLbl)
        let ratingLbl = UILabel()
        ratingLbl.frame = CGRect(x: 0, y: 40, width: 30, height: 10)
        ratingLbl.font = UIFont(name: "Avenir", size: 9)
        infoView.addSubview(ratingLbl)
        let addressLbl = UILabel()
        addressLbl.frame = CGRect(x: 0, y: 55, width: 100, height: 10)
        addressLbl.font = UIFont(name: "Avenir", size: 9)
        infoView.addSubview(addressLbl)
        let address2Lbl = UILabel()
        address2Lbl.frame = CGRect(x: 0, y: 70, width: 80, height: 10)
        address2Lbl.font = UIFont(name: "Avenir", size: 9)
        infoView.addSubview(address2Lbl)
        let ratingImage = UIImageView()
        ratingImage.frame = CGRect(x: 10, y: 40, width: 70, height: 10)
        ratingImage.contentMode = UIViewContentMode.scaleAspectFit
        infoView.addSubview(ratingImage)
        for item in places {
            if item.long == marker.position.longitude && item.lat == marker.position.latitude {
                nameLbl.text = item.name
                ratingLbl.text = item.rating
                addressLbl.text = item.address
                ratingImage.image = UIImage(named: "\(item.rating)")
                if item.rating == "4.5" {
                    ratingImage.image = UIImage(named: "45")
                }
                if item.rating == "3.5" {
                    ratingImage.image = UIImage(named: "35")
                }
                if item.rating == "2.5" {
                    ratingImage.image = UIImage(named: "25")
                }
                if item.rating == "1.5" {
                    ratingImage.image = UIImage(named: "15")
                }
                if item.rating == "0.5" {
                    ratingImage.image = UIImage(named: "05")
                }
                address2Lbl.text = item.address2
            }
        }
        return infoView
        
    }
    
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "markerView") as! markerView
        for item in places {
            if item.long == marker.position.longitude && item.lat == marker.position.latitude {
                vc.place = item
            }
        }
        self.present(vc, animated: true, completion: nil)
    }
    
    func mapView(_ mapView: GMSMapView, didChange position: GMSCameraPosition) {
        mapView.clear()
        places.removeAll()
        self.downloadPlaces(long: position.target.longitude, lat: position.target.latitude){
            for item in self.places {
                let marker = GMSMarker()
                marker.position = CLLocationCoordinate2D(latitude: item.lat, longitude: item.long)
                marker.map = mapView
            }
        }
    }
    
    func downloadPlaces(long: Double, lat: Double, completed: @escaping ()->()){
        let coor : YLPCoordinate = YLPCoordinate.init(latitude: lat, longitude: long)
        let query = YLPQuery(coordinate: coor)
        query.term = "Food"
        query.limit = 10
        
        YLPClient.authorize(withAppId: appId, secret: appSecret).flatMap { client in
            client.search(withQuery: query)
            
            }.onSuccess { search in
                
                if search.businesses.first != nil {
                    for x in 0..<search.businesses.count {
                        let place = Place()
                        place.name = search.businesses[x].name
                        place.id = search.businesses[x].identifier
                        place.category = search.businesses[x].categories[0].name
                        place.rating = "\(search.businesses[x].rating)"
                        place.reviewCount = "\(search.businesses[x].reviewCount)"
                        place.long = (search.businesses[x].location.coordinate?.longitude)!
                        place.lat = (search.businesses[x].location.coordinate?.latitude)!
                        if search.businesses[x].isClosed{
                            place.state = "Closed"
                        }else{
                            place.state = "Open"
                        }
                        if search.businesses[x].location.address.count > 0 {
                            place.address = search.businesses[x].location.address[0]
                            if search.businesses[x].location.address.count > 1 {
                                place.address2 = search.businesses[x].location.address[1]
                            }
                        }
                        if let phone = search.businesses[x].phone {
                            place.phone = phone
                        }
                        if let imageURL = search.businesses[x].imageURL {
                            place.imageURL = "\(imageURL)"
                        }
                        self.places.append(place)
                        
                    }
                    completed()
                } else {
                    print("No businesses found")
                }
            }.onFailure { error in
                print("Search errored: \(error)")
        }
        
    }
    
}

