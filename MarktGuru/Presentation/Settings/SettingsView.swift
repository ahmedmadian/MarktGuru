//
//  SettingsView.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import SwiftUI

struct SettingsView: View {
    // MARK: - Properties
    @AppStorage(AppStorageKeys.appearance)
    private var appearance = Appearance.system

    // MARK: - Layout Constants
    private enum Constants {
        static let optionSpacing: CGFloat = 16
        static let sectionPadding: CGFloat = 8
    }

    // MARK: - Body
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Appearance")) {
                    HStack(spacing: Constants.optionSpacing) {
                        ForEach(Appearance.allCases) { option in
                            AppearanceOptionView(
                                option: option,
                                isSelected: appearance == option,
                                onSelect: { appearance = option }
                            )
                            if option != Appearance.allCases.last {
                                Spacer()
                            }
                        }
                    }
                    .padding(.vertical, Constants.sectionPadding)
                }
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .preferredColorScheme(appearance.colorScheme)
        }
    }
}

#Preview {
    SettingsView()
}
