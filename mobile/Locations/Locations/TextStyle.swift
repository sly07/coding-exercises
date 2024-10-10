//
//  TextStyle.swift
//  Locations
//
//  Created by Mike Sly on 10/10/24.
//

import SwiftUI

enum TextStyle {
    case primaryStyle
    case secondaryStyle
}

struct LocationsTextStyle: ViewModifier {
    var textStyle: TextStyle
    
    func body(content: Content) -> some View {
        switch textStyle {
        case .primaryStyle:
            return content
                .font(.system(size: 18, weight: .bold, design: .serif))
                .fontWeight(.bold)
                .foregroundStyle(.gray)
        case .secondaryStyle:
            return content
                .font(.system(size: 18))
                .fontWeight(.regular)
                .foregroundStyle(.gray)
        }
    }
}

extension View {
    func textStyle(_ style: TextStyle) -> some View {
        self.modifier(LocationsTextStyle(textStyle: style))
    }
}

// TODO: Decide where these go
extension Color {
    static var backGroundColor = Color.brown.opacity(0.2)
    static var iconColor = Color.gray
    static var textColor = Color.gray
}
