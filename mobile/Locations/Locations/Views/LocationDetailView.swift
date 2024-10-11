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
        VStack(alignment: .leading) {
            if let location = location {
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
                        .padding(.bottom, 8)
                    
                    Text("Estimated Revenue: $\(String(location.estimatedRevenueMillions)) million")
                        .textStyle(.accentStyle)
                        .padding(.bottom, 12)
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Latitude: \(location.coordinate.latitude)")
                        Text("Longitude: \(location.coordinate.longitude)")
                    }
                    .textStyle(.footnoteStyle)
                }
                .padding(.bottom, 48)
            }
        }
        .padding(.horizontal, 24)
        .frame(maxWidth: .infinity, minHeight: 44)
        .background(Color.locationsBackground)
        .clipShape(RoundedRectangle(cornerRadius: 25))
    }
}
