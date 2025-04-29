//
//  ProductRow.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import SwiftUI

struct ProductRow: View {
    // MARK: - Properties
    let viewModel: ProductViewModel
    private var favoriteAction: () -> Void = {}
    
    // MARK: - Styling Constants
    private enum Constants {
        static let cornerRadius: CGFloat = 12
        static let shadowRadius: CGFloat = 4
        static let shadowOpacity: Double = 0.1
        static let spacing: CGFloat = 8
        static let horizontalPadding: CGFloat = 8
        static let imageAspectRatio: CGFloat = 1
    }
    
    // MARK: - init
    init(
        viewModel: ProductViewModel,
        favoriteAction: @escaping () -> Void = {}
    ) {
        self.viewModel = viewModel
        self.favoriteAction = favoriteAction
    }
    
    // MARK: - Body
    var body: some View {
        VStack(spacing: Constants.spacing) {
            productImage
            productTitle
            productPrice
        }
        .padding(.bottom, Constants.spacing)
        .background(Color(UIColor.systemBackground))
        .cornerRadius(Constants.cornerRadius)
        .shadow(
            color: .primary.opacity(Constants.shadowOpacity),
            radius: Constants.shadowRadius,
            x: 0,
            y: 2
        )
    }
}

// MARK: - View Builders
private extension ProductRow {
    @ViewBuilder
    var productImage: some View {
        
        ZStack(alignment: .topTrailing) {
            AsyncImage(url: viewModel.thumbnailURL) { phase in
                switch phase {
                case .success(let image):
                    image
                        .resizable()
                        .scaledToFit()
                default:
                    Color.gray
                }
            }
            .frame(maxWidth: .infinity)
            .aspectRatio(Constants.imageAspectRatio, contentMode: .fit)

            favoriteButton
        }
    }
    
    var favoriteButton: some View {
        Button(action: favoriteAction) {
            Image(systemName: viewModel.isFavorite ? "heart.fill" : "heart")
                .padding(Constants.spacing)
                .background(
                    Circle()
                        .fill(Color.black.opacity(0.5))
                )
                .foregroundColor(viewModel.isFavorite ? .red : .white)
                .accessibilityLabel(viewModel.isFavorite ? "Remove from favorites" : "Add to favorites")
        }
        .padding(Constants.spacing)
    }
    
    var productTitle: some View {
        Text(viewModel.title)
            .font(.caption)
            .foregroundColor(.primary)
            .lineLimit(1)
            .truncationMode(.tail)
            .padding(.horizontal, Constants.horizontalPadding)
    }
    
    var productPrice: some View {
        Text(viewModel.price, format: .currency(code: viewModel.currency))
            .font(.headline.bold())
            .foregroundColor(.primary)
            .lineLimit(1)
            .padding(.horizontal, Constants.horizontalPadding)
    }
}

#Preview {
    let sample = Product(
        id: 1,
        title: "Sample Product",
        price: 29,
        description: "A test product",
        images: ["https://i.imgur.com/9LFjwpI.jpeg"],
        category: Category(name: "Demo")
    )

    ProductRow(
        viewModel: ProductViewModel(product: sample, isFavorite: false),
        favoriteAction: { print("Favorited tapped") }
    )
}
