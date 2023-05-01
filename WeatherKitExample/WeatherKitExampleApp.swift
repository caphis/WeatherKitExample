//
//  WeatherKitExampleApp.swift
//  WeatherKitExample
//
//  Created by David Harkey on 2/5/23.
//

import SwiftUI

@main
struct WeatherKitExampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(WeatherKitService())
        }
    }
}
