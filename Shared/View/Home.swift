//
//  Home.swift
//  MapRoutes (iOS)
//
//  Created by Balaji on 03/01/21.
//

import SwiftUI
import MapKit
import CoreLocation

struct Home: View {

    @StateObject var mapData = MapViewModel()
    // Location Manager....
    @State var locationManager = CLLocationManager()
    @State var showMapAlert = false

    var body: some View {
        ZStack{
            // MapView...
            MapView(mapType: mapData.mapType,
                    showMapAlert: $showMapAlert)
                .environmentObject(mapData)
                .ignoresSafeArea(.all, edges: .all)
            
            AlertView(presented: self.$showMapAlert)
                .zIndex(1)
            
            VStack {
                VStack(spacing: 10) {
                    HStack {
                        Button(action: {
                            self.showMapAlert = true
                        }, label: {
                            Image(systemName: "exclamationmark.icloud.fill")
                                .font(.system(size: 27))
                                .foregroundColor(.red)
                    })
                        
                HStack {
                    Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        
                    TextField("Search", text: $mapData.searchTxt)
                            .colorScheme(.light)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                    }
                     .frame(width: UIScreen.main.bounds.width/2 + 50,
                            height: 18,
                            alignment: .center)
                     .padding(.vertical,10)
                     .padding(.horizontal)
                     .background(Color.white)
                     .cornerRadius(5)
                     .clipped()

                       Button(action: mapData.focusLocation, label: {
                                Image(systemName: "location.fill")
                                    .padding(9)
                                    .background(Color.red)
                                    .foregroundColor(Color.white)
                                    .clipShape(Circle())
                            })
                }
                    // Displaying Results...
                    if !mapData.places.isEmpty && mapData.searchTxt != "" {
                        ScrollView {
                            VStack(spacing: 15) {
                                ForEach(mapData.places) { place in
                                    ZStack {
                                        Color(UIColor.systemGray6)
                                        Button {
                                            mapData.selectPlace(place: place)
                                        } label: {
                                            HStack {
                                                Text(place.placemark.name ?? "")
                                                    .bold()
                                                    .foregroundColor(.gray)
                                                    .padding(.leading, 15)
                                                Spacer()
                                                Text(place.placemark.administrativeArea ?? "")
                                                    .bold()
                                                    .font(.system(size: 10))
                                                    .foregroundColor(.black)
                                                    .padding(.trailing, 15)
                                            }
                                        }
                                    }
                                    Divider()
                                        .background(Color.red)
                                }
                            }
                            .padding(.top)
                        }
                        .background(Color.white.opacity(0.7))
                        .cornerRadius(5)
                    }
                Spacer()
                    Picker("", selection: $mapData.mapType) {
                        Text("Standard").tag(MKMapType.standard)
                        Text("Satellite").tag(MKMapType.satellite)
                        Text("Hybrid").tag(MKMapType.hybrid)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .offset(y: -15)
                    .font(.largeTitle)
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding()
            }
        }
        .onAppear(perform: {
            // Setting Delegate...
            locationManager.delegate = mapData
            locationManager.requestWhenInUseAuthorization()
        })
        .onChange(of: mapData.searchTxt, perform: { value in
            
            // Searching Places...
            
            // You can use your own delay time to avoid Continous Search Request...
            let delay = 0.3
            DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                if value == mapData.searchTxt {
                    // Search...
                    self.mapData.searchQuery()
                }
            }
        })
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}
