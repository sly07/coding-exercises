//
//  MapViewModel.swift
//  Locations
//
//  Created by Mike Sly on 10/9/24.
//

import Foundation

class MapViewModel: ObservableObject {
    /// It could be beneficial to create something like a LocationsRepository responsible for making the request, holding state for locations, refreshing state, and error handling.
    private var locationsCache: [Location] = []
    
    @Published var locations: [Location] = []
    
    init() {
        Task {
            await self.getLocations()
        }
    }
    
    func filterLocations(by locationTypes: Set<LocationType>) {
        if locationTypes.isEmpty {
            locations = locationsCache
            return
        }
        
        var newLocations: [Location] = []
        
        locationTypes.forEach { type in
            newLocations += locationsCache.filter({
                $0.locationType == type
            })
        }
        
        locations = newLocations
    }
}

extension MapViewModel {
    
    func getLocations() async {
        guard let url = URL(string: "https://raw.githubusercontent.com/sly07/coding-exercises/refs/heads/master/mobile/map-locations/locations.json") else {
            print("Invalid URL")
            return
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let decodedLocations = try JSONDecoder().decode([Location].self, from: data)
            await MainActor.run {
                self.locationsCache = decodedLocations
                self.locations = decodedLocations
            }
        } catch {
            print("Error fetching or decoding data: \(error)")
        }
    }
}
