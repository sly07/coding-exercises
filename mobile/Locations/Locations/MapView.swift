//
//  MapView.swift
//  Locations
//
//  Created by Mike Sly on 10/8/24.
//

import SwiftUI
import MapKit

struct MapView: View {
    @State private var cameraPosition: MapCameraPosition = .region(
        MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.77406949130089, longitude: -122.41974229680551), // San Francisco area
            span: MKCoordinateSpan(latitudeDelta: 0.02890107214263793, longitudeDelta: 0.016865616607546485)
        )
    )
    
    @State var locations: [Location] = []
    @State var filteredLocations: [Location] = []
    @State private var selectedLocation: Location? = nil
    @State var showFilterActionSheet = false
    
    var body: some View {
        NavigationView {
            VStack {
                Map(position: $cameraPosition) {
                    ForEach(filteredLocations) { location in
                        Annotation(location.name, coordinate: location.coordinate) {
                            VStack {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(getColorByLocationType(location: location))
                                    .font(.title)
                                    .background(.white)
                                    .clipShape(Circle())
                                    .onTapGesture {
                                        withAnimation {
                                            selectedLocation = location
                                        }
                                    }
                                Text(location.name)
                                    .font(.caption)
                            }
                        }
                    }
                }
                
                if selectedLocation != nil {
                    LocationDetailView(location: $selectedLocation)
                            .frame(height: 200)
                }
            }
            .edgesIgnoringSafeArea(.bottom)
            .task {
                await fetchLocations()
            }
            .onMapCameraChange { context in
                print("Camera moved to region: \(context.region)")
            }
            .navigationBarItems(trailing: Button(action: {
                showFilterActionSheet = true
            }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.title2)
            })
            .confirmationDialog("Location Type Filter", isPresented: $showFilterActionSheet) {
                ForEach(LocationType.allCases, id: \.self) { type in
                    if type == .unknown {
                        EmptyView()
                    } else {
                        Button(action: {
                            filteredLocations = locations.filter {
                                $0.locationType == type
                            }
                        }, label: {
                            Text(type.rawValue)
                        })
                    }
                }
            }
        }
    }
    
    func getColorByLocationType(location: Location) -> Color {
        switch location.locationType {
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
    
    func fetchLocations() async {
        guard let url = URL(string: "https://raw.githubusercontent.com/sly07/coding-exercises/refs/heads/master/mobile/map-locations/locations.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedLocations = try JSONDecoder().decode([Location].self, from: data)
            self.locations = decodedLocations
            self.filteredLocations = decodedLocations
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }
}

struct LocationDetailView: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var location: Location?
    
    var body: some View {
        if let location = location {
            ScrollView {
                VStack(alignment: .leading) {
                    Text(location.name)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    Text(location.description)
                    Text("Estimated Revenue: $\(String(location.estimatedRevenueMillions)) million")
                    
                    HStack {
                        Text("Latitude: \(location.coordinate.latitude)")
                        Text("Longitude: \(location.coordinate.longitude)")
                    }
                    
                    Button("Dismiss") {
                        withAnimation {
                            self.location = nil
                        }
                    }
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .background(ignoresSafeAreaEdges: .horizontal)
        }
    }
}

#Preview {
    MapView()
}
