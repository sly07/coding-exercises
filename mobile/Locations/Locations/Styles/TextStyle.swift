//
//  TextStyle.swift
//  Locations
//
//  Created by Mike Sly on 10/10/24.
//

import SwiftUI

enum TextStyle {
    case accentStyle
    case footnoteStyle
    case subtitleStyle
    case titleStyle
    case titleLargeStyle
}

struct LocationsTextStyle: ViewModifier {
    var textStyle: TextStyle
    
    func body(content: Content) -> some View {
        switch textStyle {
        case .accentStyle:
            return AnyView(content
                .font(.headline)
                .foregroundStyle(Color.locationsAccent))
        case .footnoteStyle:
            return AnyView(content
                .font(.footnote)
                .foregroundStyle(Color.locationsText))
        case .titleStyle:
            return AnyView(content
                .font(.system(size: 18, weight: .bold, design: .serif))
                .foregroundStyle(Color.locationsPrimary))
        case .titleLargeStyle:
            return AnyView(content
                .font(.system(size: 32, weight: .bold, design: .serif))
                .foregroundStyle(Color.locationsPrimary))
        case .subtitleStyle:
            return AnyView(content
                .font(.body)
                .foregroundStyle(Color.locationsSecondary))
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(LocationsTextStyle(textStyle: style))
    }
}
