//
//  MapView.swift
//  MapRoutes (iOS)
//
//  Created by Balaji on 03/01/21.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    
    let mapType : MKMapType
    @Binding var showMapAlert: Bool
    @EnvironmentObject var mapData: MapViewModel

    func makeCoordinator() -> Coordinator {
        return MapView.Coordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        
        let map = mapData.mapView
        map.showsUserLocation = true
        map.delegate = context.coordinator
        map.showsCompass = false
        map.isRotateEnabled = true
        map.isPitchEnabled = true

        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.mapType = mapType
        uiView.isRotateEnabled = true
        uiView.isPitchEnabled = true
    }
    
    class Coordinator: NSObject,MKMapViewDelegate{
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard !annotation.isKind(of: MKUserLocation.self) else { return nil }
        
            if let annotation = annotation as? ImageAnnotation {
                let identifier = "identifier"
                let annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView.image = annotation.image
                annotationView.canShowCallout = true
                return annotationView
            }
            return nil
        }
    }
}


class ImageAnnotationView: MKAnnotationView {
    private var imageView: UIImageView!

    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)

        self.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        self.imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        self.addSubview(self.imageView)

        self.imageView.layer.cornerRadius = 5.0
        self.imageView.layer.masksToBounds = true
    }

    override var image: UIImage? {
        get {
            return self.imageView.image
        }

        set {
            self.imageView.image = newValue
        }
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class ImageAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    var image: UIImage? = nil

    init(title: String, subtitle: String, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        //self.image
        super.init()
    }
}
