//
//  PetsagramMapView.swift
//  Petsagram Map
//
//  Created by Vahe Toroyan on 11/28/20.
//

import SwiftUI
import MapKit

struct MapViewContent: View {
    // 1
    @State var coordinate = CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 40.61900, longitude: -74.14053)

    @State private var region = MKCoordinateRegion(center: CLLocationManager().location?.coordinate ?? CLLocationCoordinate2D(latitude: 40.61900, longitude: -74.14053),
                                                   span: MKCoordinateSpan(latitudeDelta: 0.24, longitudeDelta: 0.24))
    // 2
    @State private var mapType: MKMapType = .standard
    @State var locationManager = CLLocationManager()
    @State var showMapAlert = false


    var body: some View {
        ZStack {
            // 3
            MapView(locationManager: $locationManager,
                    showMapAlert: $showMapAlert,
                    coordinate: self.$coordinate,
                    region: region,
                    mapType: mapType)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Spacer()
                // 4
                Picker("", selection: $mapType) {
                    Text("Standard").tag(MKMapType.standard)
                    Text("Satellite").tag(MKMapType.satellite)
                    Text("Hybrid").tag(MKMapType.hybrid)
                }
                .pickerStyle(SegmentedPickerStyle())
                .offset(y: -40)
                .font(.largeTitle)
            }
        }.onAppear {
            self.region =  MKCoordinateRegion(center: coordinate,
                                              span: MKCoordinateSpan(latitudeDelta: 0.24, longitudeDelta: 0.24))
        }
    }
}

struct MapView: UIViewRepresentable {
    @Binding var locationManager: CLLocationManager
    @Binding var showMapAlert: Bool
    @Binding var coordinate: CLLocationCoordinate2D
    
    let region: MKCoordinateRegion
    let mapType : MKMapType

     ///Creating map view at startup
     func makeUIView(context: Context) -> MKMapView {
       locationManager.delegate = context.coordinator
       let map = MKMapView()
       return map
     }

    func updateUIView(_ mapView: MKMapView, context: Context) {
          mapView.mapType = mapType
          mapView.showsUserLocation = true
          mapView.userTrackingMode = .follow
          mapView.setRegion(region, animated: false)
      }

     ///Use class Coordinator method
     func makeCoordinator() -> MapView.Coordinator {
        return Coordinator(mapView: self,
                           coordinate: self.$coordinate)
     }

     //MARK: - Core Location manager delegate
     class Coordinator: NSObject, CLLocationManagerDelegate {

       var mapView: MapView
        @Binding var coordinate: CLLocationCoordinate2D

        init(mapView: MapView,
             coordinate: Binding<CLLocationCoordinate2D>) {
         self.mapView = mapView
         self._coordinate = coordinate
       }

       ///Switch between user location status
       func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
         switch status {
         case .restricted:
           break
         case .denied:
           mapView.showMapAlert.toggle()
           return
         case .notDetermined:
           mapView.locationManager.requestWhenInUseAuthorization()
           return
         case .authorizedWhenInUse:
            self.coordinate = CLLocationManager().location!.coordinate
           return
         case .authorizedAlways:
           mapView.locationManager.allowsBackgroundLocationUpdates = true
           mapView.locationManager.pausesLocationUpdatesAutomatically = false
            self.coordinate = CLLocationManager().location!.coordinate
           return
         @unknown default:
           break
         }
         mapView.locationManager.startUpdatingLocation()
       }
      }
}

struct PetsagramMapView: View {
    
    @State var presented: Bool = false

    var body: some View {
        ZStack(alignment: .zAlignmentTopLeading) {
            MapViewContent()
                    .edgesIgnoringSafeArea(.all)
            VStack {
                    Spacer()
                    FireSmokeStatusView()
                        .padding(.bottom, -15)
            }.edgesIgnoringSafeArea(.bottom)
             .disabled(true)

            AlertView(presented: self.$presented)
                .zIndex(1)
        
            Button(action: {
                self.presented = true
            }, label: {
                Image(systemName: "exclamationmark.icloud.fill")
                    .resizable()
                    .foregroundColor(.red)
            }).alignmentGuide(HorizontalAlignment.zAlignmentTopLeading)
                { d in d[HorizontalAlignment.leading] - 40}
            .alignmentGuide(VerticalAlignment.zAlignmentTopLeading)
                { d in d[VerticalAlignment.top] - 20}
            .frame(width: 44,
                   height: 35)
        }
    }
}

struct PetsagramMapView_Previews: PreviewProvider {
    static var previews: some View {
        PetsagramMapView()
    }
}

extension HorizontalAlignment {
  
    enum ZHorizontal: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat
                 { d[HorizontalAlignment.leading] }
    }

    static let zAlignmentTopLeading =
                 HorizontalAlignment(ZHorizontal.self)
}

extension VerticalAlignment {
    enum ZVertical: AlignmentID {
        static func defaultValue(in d: ViewDimensions) -> CGFloat
                 { d[VerticalAlignment.top] }
    }
  
    static let zAlignmentTopLeading = VerticalAlignment(ZVertical.self)
}

extension Alignment {
    static let zAlignmentTopLeading = Alignment(horizontal: .zAlignmentTopLeading,
                                                vertical:.zAlignmentTopLeading)
}
