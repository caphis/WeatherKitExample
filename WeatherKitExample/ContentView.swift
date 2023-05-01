//
//  ContentView.swift
//  WeatherKitExample
//
//  Created by David Harkey on 2/5/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var ws: WeatherKitService
    @State private var loadingText = "Loading Weather..."
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                if let weather = ws.currentWeather {
                    HStack {
                        Image(systemName: "\(weather.currentWeather.symbolName)")
                            .font(.largeTitle)
                            .fontWeight(.bold)
                        
                        VStack {
                            Text("\(weather.currentWeather.temperature.converted(to: .fahrenheit).value.rounded(.toNearestOrAwayFromZero).formatted(.number))°")
                                .font(.title2)
                                .fontWeight(.semibold)
                            
                            Text("\(weather.currentWeather.condition.description)")
                                .font(.title3)
                                .fontWeight(.semibold)
                        }
                    }
                    if let location = ws.userLocation {
                        Text("at")
                            .font(.subheadline)
                        Text("\(location)")
                            .multilineTextAlignment(.center)
                            .font(.headline)
                            .fontWeight(.semibold)
                    }

                } else {
                    ProgressView()
                    Text(loadingText)
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        loadingText = "Updating Weather..."
                        ws.currentWeather = nil
                        ws.getUserLocation()
                    } label: {
                        Image(systemName: "arrow.counterclockwise")
                            .fontWeight(.bold)
                    }
                }
            }
            .navigationTitle("Simple Weather")
            .onAppear {
                ws.getUserLocation()
        }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(WeatherKitService())
    }
}
