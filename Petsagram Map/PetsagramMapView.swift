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
                
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                MapView().edgesIgnoringSafeArea(.all)
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



//.offset(self.offset)
//.animation(.spring())
//.gesture(DragGesture()
//            .onChanged{ gesture in
//                self.offset.height = gesture.translation.height
//            }
//            .onEnded {
//                if $0.translation.height < 50 {
//                    self.offset.height = UIScreen.main.bounds.height * 0.6
//                } else {
//                    self.offset.height = 65
//                }
//            }
//)
