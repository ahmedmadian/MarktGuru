//
//  MarktGuruApp.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import SwiftUI

@main
struct MarktGuruApp: App {
    @AppStorage(AppStorageKeys.appearance)
    private var appearance = Appearance.system

    var body: some Scene {
        WindowGroup {
            RootView()
                .preferredColorScheme(appearance.colorScheme)
        }
    }
}
