//
//  MapView.swift
//  TransactionsDemo
//
//  Created by Monalisa.Swain on 02/09/24.
//

import SwiftUI
import MapKit

struct LocationAnnotation: Identifiable {
    let id = UUID()
    var coordinate: CLLocationCoordinate2D
}

struct MapView: View {
    var coordinate: CLLocationCoordinate2D
    
    @State private var region = MKCoordinateRegion()
    
    var body: some View {
        let annotations = [LocationAnnotation(coordinate: coordinate)]
        Map(coordinateRegion: $region, annotationItems: annotations) { annotation in
            MapAnnotation(coordinate: annotation.coordinate) {
                Image("Atmicon")
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .shadow(radius: 5)
            }
        }
        .onAppear {
            setRegion(coordinate)
        }
        .navigationTitle("ATM Location")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
    }
}

//#Preview {
////    MapView()
//}
