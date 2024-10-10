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
                            .foregroundStyle(Color.iconColor)
                    })
                }
                .padding(.top, 8)
                .padding(.bottom, 2)
                
                VStack(alignment: .leading, spacing: 8) { // Add spacing for readability
                    // Title Styling
                    Text(location.name)
                        .font(.system(size: 32, weight: .bold, design: .serif)) // Elegant font for title
                        .foregroundColor(Color.primary)
                        .padding(.bottom, 4)
                    
                    // Description Styling
                    Text(location.description)
                        .font(.body)
                        .foregroundColor(Color.secondary) // Subtle color for description
                        .lineSpacing(6) // Add line spacing for readability
                    
                    // Revenue Styling
                    Text("Estimated Revenue: $\(String(location.estimatedRevenueMillions)) million")
                        .font(.headline)
                        .foregroundColor(Color.green) // Differentiate revenue with accent color
                        .padding(.top, 8)
                    
                    // Coordinates Styling
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Latitude: \(location.coordinate.latitude)")
                        Text("Longitude: \(location.coordinate.longitude)")
                    }
                    .font(.footnote) // Smaller font for coordinate details
                    .foregroundColor(Color.gray)
                    .padding(.top, 12)
                }
                .padding(.bottom, 48)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(Color.backGroundColor)
        }
    }
}
