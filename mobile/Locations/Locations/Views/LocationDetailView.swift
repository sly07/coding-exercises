//
//  LocationDetailView.swift
//  Locations
//
//  Created by Mike Sly on 10/9/24.
//

import SwiftUI

struct LocationDetailView: View {
    @Binding var location: Location?
    
    var body: some View {
        if let location = location {
            VStack(alignment: .leading) {
                // Close button with improved alignment and padding
                HStack {
                    Spacer()
                    Button(action: {
                        withAnimation {
                            self.location = nil
                        }
                    }, label: {
                        Image(systemName: "xmark")
                            .foregroundStyle(Color.locationsIcon)
                    })
                }
                .padding(.top, 16)
                .padding(.bottom, 2)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text(location.name)
                        .textStyle(.titleLargeStyle)
                        .padding(.bottom, 4)
                    
                    Text(location.description)
                        .textStyle(.subtitleStyle)
                    
                    Text("Estimated Revenue: $\(String(location.estimatedRevenueMillions)) million")
                        .textStyle(.accentStyle)
                        .padding(.top, 8)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Latitude: \(location.coordinate.latitude)")
                        Text("Longitude: \(location.coordinate.longitude)")
                    }
                    .textStyle(.footnoteStyle)
                    .padding(.top, 12)
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(Color.locationsBackground)
        }
    }
}
