//
//  ContentView.swift
//  Locations
//
//  Created by Mike Sly on 10/8/24.
//

import SwiftUI

struct ContentView: View {
    @State var locations: [Location] = []
    
    var body: some View {
        MapView()
    }
}

#Preview {
    ContentView()
}
