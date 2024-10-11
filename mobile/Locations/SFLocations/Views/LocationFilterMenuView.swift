//
//  LocationFilterMenuView.swift
//  Locations
//
//  Created by Mike Sly on 10/10/24.
//

import SwiftUI

struct LocationFilterMenuView: View {
    @State private var selectedFilters: Set<LocationType> = []
    @ObservedObject var mapViewModel: MapViewModel
    
    var body: some View {
        HStack {
            if !selectedFilters.isEmpty {
                Button {
                    selectedFilters.removeAll()
                    mapViewModel.filterLocations(by: selectedFilters)
                } label: {
                    Text("Clear")
                        .foregroundStyle(Color.locationsIcon)
                }
                
            }
            Menu {
                ForEach(LocationType.allCases.filter {$0 != .unknown}, id: \.self) { type in
                    Button {
                        if selectedFilters.contains(type) {
                            selectedFilters.remove(type)
                        } else {
                            selectedFilters.insert(type)
                        }
                        
                        mapViewModel.filterLocations(by: selectedFilters)
                    } label: {
                        HStack {
                            Text(type.displayName())
                            Spacer()
                            if selectedFilters.contains(type) {
                                Image(systemName: "checkmark")
                            }
                        }
                    }
                }
            } label: {
                Image(systemName: "line.horizontal.3.decrease.circle")
                    .foregroundStyle(Color.locationsIcon)
            }
        }
    }
}

#Preview {
    LocationFilterMenuView(mapViewModel: MapViewModel())
}
