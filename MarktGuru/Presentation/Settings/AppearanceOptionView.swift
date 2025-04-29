//
//  AppearanceOptionView.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import SwiftUI

struct AppearanceOptionView: View {
    // MARK: - Properties
    let option: Appearance
    let isSelected: Bool
    let onSelect: () -> Void

    // MARK: - Layout Constants
    private enum Constants {
        static let iconSize: CGFloat = 30
        static let boxSize: CGFloat = 60
        static let spacing: CGFloat = 8
        static let selectedStrokeWidth: CGFloat = 2
        static let markerSize: CGFloat = 16
        static let innerMarkerSize: CGFloat = 8
    }

    // MARK: - Body
    var body: some View {
        Button { onSelect() } label: {
            VStack(spacing: Constants.spacing) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .frame(width: Constants.boxSize, height: Constants.boxSize)
                    option.icon
                        .resizable()
                        .scaledToFit()
                        .frame(width: Constants.iconSize, height: Constants.iconSize)
                        .foregroundColor(.primary)
                }
                Text(option.label)
                    .font(.footnote)
                selectionMarker
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Selection Indicator
    private var selectionMarker: some View {
        ZStack {
            Circle()
                .stroke(
                    isSelected ? Color.accentColor : Color.secondary,
                    lineWidth: Constants.selectedStrokeWidth
                )
                .frame(width: Constants.markerSize, height: Constants.markerSize)
            if isSelected {
                Circle()
                    .fill(Color.accentColor)
                    .frame(width: Constants.innerMarkerSize, height: Constants.innerMarkerSize)
            }
        }
    }
}

#Preview {
    AppearanceOptionView(option: .system, isSelected: false, onSelect: { print("Selected") })
}
