//
//  PetsagramMapView.swift
//  Petsagram Map
//
//  Created by Vahe Toroyan on 11/28/20.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {

    let locationManager = CLLocationManager()

    func makeUIView(context: Context) -> MKMapView {
        MKMapView(frame: .zero)
    }

    func updateUIView(_ view: MKMapView, context: Context) {
        view.showsUserLocation = true
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.startUpdatingLocation()
        
        guard let location: CLLocationCoordinate2D = locationManager
                                                        .location?
                                                        .coordinate else { return }
        let span = MKCoordinateSpan(latitudeDelta: 0.24,
                                    longitudeDelta: 0.24)
        let region = MKCoordinateRegion(center: location,
                                        span: span)
        view.setRegion(region, animated: true)
        view.showsBuildings = true
        view.showsTraffic = true
        view.mapType = .hybridFlyover
    }
}

struct PetsagramMapView: View {

    
    @State private var offset = CGSize(width: 0,
                                       height: UIScreen.main.bounds.height * 0.6)
    @State var presented: Bool = false

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MapView()
                    .edgesIgnoringSafeArea(.all)
                    .onTapGesture {
                        self.presented = true
                    }
                
                AlertView(presented: self.$presented)
                    .zIndex(1)

                VStack {
                    Spacer()
                    FireSmokeStatusView()
                        .padding(.bottom, -15)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
        }
    }
}

struct PetsagramMapView_Previews: PreviewProvider {
    static var previews: some View {
        PetsagramMapView()
    }
}
