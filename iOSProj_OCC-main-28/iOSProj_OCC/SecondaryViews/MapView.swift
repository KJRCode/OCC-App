//
//  MapView.swift
//  Week06 Country Capitals Solution
//
//  Created by SarahSmalley on 10/26/24.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: UIViewRepresentable {
    @Binding var showMap : Bool
    var zipCode: String
      
    @State private var region : MKCoordinateRegion = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 39.999733, longitude: -98.678503),
        span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
    )
    
    @State private var closestPOI: MKPointAnnotation?
    
    private var locationManager = CLLocationManager()
    
    init(showMap: Binding<Bool>, zipCode: String) {
        self._showMap = showMap
        self.zipCode = zipCode
        locationManager.requestWhenInUseAuthorization()
    }
    
    // Handle the location permission changes
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedWhenInUse || status == .authorizedAlways {
            locationManager.startUpdatingLocation()
        } else {
            
            print("Location permission denied")
        }
    }
    
    func fetchCoordinates(from zipCode: String, completion: @escaping (CLLocationCoordinate2D?) -> Void) {
        let geoCoder = CLGeocoder()
        geoCoder.geocodeAddressString(zipCode) { placemarks, error in
            if let error = error {
                print("Error geocoding zip code: \(error.localizedDescription)")
                completion(nil)
                return
            }
            guard let placemark = placemarks?.first,
                  let location = placemark.location else {
                completion(nil)
                return
            }
            completion(location.coordinate)
        }
    }

    func updateRegion(for zipCode: String) {
        fetchCoordinates(from: zipCode) { coordinate in
            guard let coordinate = coordinate else {
                print("Failed to fetch coordinates for zip code")
                return
            }
            
           
            let newRegion = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            
           
            self.region = newRegion
            
            
            findClosestPOI(from: coordinate)
        }
    }

    func findClosestPOI(from userLocation: CLLocationCoordinate2D) {
        var closestDistance: CLLocationDistance = Double.infinity
        var closestAnnotation: MKPointAnnotation?
        
        for poi in point_of_interest {
            let poiLocation = CLLocation(latitude: poi.coordinate.latitude, longitude: poi.coordinate.longitude)
            let userLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
            
            let distance = userLocation.distance(from: poiLocation)
            
            if distance < closestDistance {
                closestDistance = distance
                closestAnnotation = poi
            }
        }
        closestPOI = closestAnnotation
    }
    
    var point_of_interest : [MKPointAnnotation] {
        var locs = [MKPointAnnotation]()
        var loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 35.221694, longitude: -80.839734)
        loc.title = "Charlotte"
        locs.append(loc)
        
        loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 36.217933, longitude: -78.217114)
        loc.title = "Boone"
        locs.append(loc)
        
        loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 32.959025, longitude: -97.030385)
        loc.title = "Coppell, TX"
        locs.append(loc)
        
        loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 41.986174, longitude: -87.971156)
        loc.title = "Elk Grove Village, IL"
        locs.append(loc)
        
        loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 33.748188, longitude: -84.390865)
        loc.title = "Atlanta, GA"
        locs.append(loc)
        
        loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 33.920234, longitude: -117.926584)
        loc.title = "Fullerton, CA"
        locs.append(loc)
        
        loc = MKPointAnnotation()
        loc.coordinate = CLLocationCoordinate2D(latitude: 39.560689, longitude: -104.836622)
        loc.title = "Englewood, CO"
        locs.append(loc)
        
        return locs
    }
    
    
    func makeUIView(context: Context) -> MKMapView {
        var map = MKMapView()
        map.delegate = context.coordinator
        
        updateRegion(for: zipCode)
        locationManager.delegate = context.coordinator
        
        return map
    }
    
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        
        uiView.addAnnotations(point_of_interest)
        
        if let closestPOI = closestPOI {
            let newRegion = MKCoordinateRegion(
                center: closestPOI.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            uiView.setRegion(newRegion, animated: true)
            
            uiView.addAnnotation(closestPOI)
            uiView.selectAnnotation(closestPOI, animated: true)
        }
    }
    
    
    static func dismantleUIView(_ uiView: MKMapView, coordinator: ()) {
        uiView.removeAnnotations(uiView.annotations)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(map: self)
    }
    
    // define a delegate
    class Coordinator : NSObject, MKMapViewDelegate, CLLocationManagerDelegate {
        var map: MapView
        
        init(map: MapView) {
            self.map = map
        }
        
       
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if let pointAnnotation = annotation as? MKPointAnnotation {
                let annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: nil)
                
                if pointAnnotation == map.closestPOI {
                    annotationView.markerTintColor = .red
                } else {
                    annotationView.markerTintColor = .blue
                }
                
                annotationView.canShowCallout = true
                annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
                
                return annotationView
            }
            return nil
        }
        
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let annotation = view.annotation else { return }
            
            
            let mapItem = MKMapItem(placemark: MKPlacemark(coordinate: annotation.coordinate))
            
            
            mapItem.name = annotation.title ?? "Unknown Location"
            
            
            mapItem.openInMaps(launchOptions: [
                MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeDriving
            ])
        }
        
        
        func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            if status == .authorizedWhenInUse || status == .authorizedAlways {
                manager.startUpdatingLocation()
            } else {
               
                print("Location permission denied")
            }
        }
    }
}

#Preview {
    @State var showMap = false
    MapView(showMap: $showMap, zipCode: "90001")
}
