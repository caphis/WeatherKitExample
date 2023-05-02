//
//  WeatherKitService.swift
//  WeatherKitExample
//
//  Created by David Harkey on 2/5/23.
//

import SwiftUI
import CoreLocation 
import WeatherKit

class WeatherKitService: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var userLocation: String?
    @Published var currentWeather: Weather? = nil
    let locationManager = CLLocationManager()
    let service = WeatherService()
    
    func getUserLocation() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        locationManager.startUpdatingLocation()
    }
    
    @MainActor
    func getWeather(location: CLLocation) {
        Task {
            do {
                let result = try await service.weather(for: location)
                currentWeather = result
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        locationManager.stopUpdatingLocation()
        getLocationDescription(location: location)
        Task {
            await getWeather(location: location)
        }
    }
    
    func getLocationDescription(location: CLLocation) {
        let geocoder = CLGeocoder()
        var descriptionString = ""
        geocoder.reverseGeocodeLocation(location) { [weak self] placemarks, error in
            if let placemark = placemarks?.first {
                if let num = placemark.subThoroughfare, let str = placemark.thoroughfare, let cit = placemark.locality, let st = placemark.administrativeArea, let zipcode = placemark.postalCode {
                    descriptionString = num + " " + str + "\n" + cit + ", " + st + " " + zipcode
                    self?.userLocation = descriptionString
                }
            } else {
                self?.userLocation = nil
            }
        }
    }
}
