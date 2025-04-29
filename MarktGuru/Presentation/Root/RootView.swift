//
//  RootView.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import SwiftUI

struct RootView: View {
    var body: some View {
        TabView {
            Tab("Products", systemImage: "cart") {
                ProductsGridView()
            }

            Tab("Settings", systemImage: "gear") {
                SettingsView()
            }
        }
    }
}

#Preview {
    RootView()
}
