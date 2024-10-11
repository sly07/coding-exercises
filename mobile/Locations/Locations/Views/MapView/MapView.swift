//
//  MapView.swift
//  Locations
//
//  Created by Mike Sly on 10/8/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject var viewModel = MapViewModel()
    @State private var selectedLocation: Location? = nil
    
    // Set map over the San Francisco area
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.77406949130089, longitude: -122.41974229680551),
            span: MKCoordinateSpan(latitudeDelta: 0.02890107214263793, longitudeDelta: 0.016865616607546485)
        )
    )
    
    var body: some View {
        NavigationView {
            ZStack {
                Map(position: $cameraPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(location.displayColor)
                                    .font(.title)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .scaleEffect(selectedLocation == location ? 1.25 : 1.0)
                                    .onTapGesture {
                                        withAnimation {
                                            selectedLocation = location
                                        }
                                    }
                                    .animation(.easeInOut, value: selectedLocation)
                            }
                        }
                    }
                }
                .onMapCameraChange { context in
                    print("Camera moved to region: \(context.region)")
                }
                
                // Details Footer
                VStack {
                    Spacer()
                    LocationDetailView(location: $selectedLocation)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LocationFilterMenuView(mapViewModel: viewModel)
                }
                ToolbarItem(placement: .principal) {
                    Text("San Francisco Locations")
                        .textStyle(.titleStyle)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.locationsBackground, for: .navigationBar)
            .preferredColorScheme(.dark)
        }
    }
}

#Preview {
    MapView()
}

extension Location {
    var displayColor: Color {
        switch locationType {
        case .bar:
                .yellow
        case .cafe:
                .brown
        case .landmark:
                .blue
        case .park:
                .green
        case .museum:
                .purple
        case .restaurant:
                .red
        case .unknown:
                .white
        }
    }
}
