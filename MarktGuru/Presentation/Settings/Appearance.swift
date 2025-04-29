//
//  Appearance.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import SwiftUI

enum Appearance: String, CaseIterable, Identifiable {
    case light, dark, system

    var id: String { rawValue }

    var icon: Image {
        switch self {
        case .light:  Image(systemName: "sun.max.fill")
        case .dark:   Image(systemName: "moon.fill")
        case .system: Image(systemName: "circle.lefthalf.fill")
        }
    }

    var label: String {
        switch self {
        case .light:  "Light"
        case .dark:   "Dark"
        case .system: "System"
        }
    }

    var colorScheme: ColorScheme? {
        switch self {
        case .light:  .light
        case .dark:   .dark
        case .system: nil
        }
    }
}
