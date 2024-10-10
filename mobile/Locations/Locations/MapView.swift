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
            VStack(spacing: 0) {
                Map(position: $cameraPosition) {
                    ForEach(viewModel.locations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(location.displayColor)
                                    .font(.title)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        withAnimation {
                                            selectedLocation = location
                                        }
                                    }
                            }
                        }
                    }
                }
                
                /// It is interesting that this animates as part of a VStack fading in and out but
                /// as part of a ZStack fading out does not animate.
                if selectedLocation != nil {
                    LocationDetailView(location: $selectedLocation)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    LocationFilterMenu(mapViewModel: viewModel)
                }
                ToolbarItem(placement: .principal) {
                    Text("Locations")
                        .textStyle(.primaryStyle)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.backGroundColor, for: .navigationBar)
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
