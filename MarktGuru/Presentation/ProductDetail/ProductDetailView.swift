//
//  ProductDetailView.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 29.04.25.
//

import SwiftUI
import Factory

struct ProductDetailView: View {
    // MARK: - State
    @State private var selectedImageIndex: Int = 0

    // MARK: - Dependencies
    let viewModel: ProductDetailViewModelType

    // MARK: - Layout Constants
    private enum Constants {
        static let mainImageHeight: CGFloat = 400
        static let cornerRadius: CGFloat = 12
        static let thumbnailSize: CGFloat = 60
        static let thumbnailSpacing: CGFloat = 12
        static let horizontalPadding: CGFloat = 8
        static let verticalSpacing: CGFloat = 8
    }

    // MARK: - Body
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                mainImage
                thumbnailCarousel
                headerSection
                descriptionSection
            }
            .padding(.horizontal, Constants.horizontalPadding)
        }
    }
}

// MARK: - View Builders
private extension ProductDetailView {
    var mainImage: some View {
        TabView(selection: $selectedImageIndex) {
            ForEach(viewModel.product.imagesURLs.indices, id: \.self) { index in
                AsyncImage(url: viewModel.product.imagesURLs[index]) { phase in
                    switch phase {
                    case .empty:
                        ProgressView()
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFit()
                    case .failure:
                        Color.gray
                    @unknown default:
                        Color.gray
                    }
                }
                .tag(index)
                .frame(maxWidth: .infinity)
                .cornerRadius(Constants.cornerRadius)
                .padding(.top)
            }
        }
        .tabViewStyle(.page(indexDisplayMode: .automatic))
        .frame(height: Constants.mainImageHeight)
    }

    var thumbnailCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: Constants.thumbnailSpacing) {
                ForEach(viewModel.product.imagesURLs.indices, id: \.self) { index in
                    thumbnail(at: index)
                }
                if viewModel.product.imagesURLs.count > 5 {
                    extraThumbnailCount
                }
            }
            .padding(.top, Constants.verticalSpacing)
        }
    }

    func thumbnail(at index: Int) -> some View {
        AsyncImage(url: viewModel.product.imagesURLs[index]) { phase in
            switch phase {
            case .empty:
                ProgressView()
            case .success(let image):
                image
                    .resizable()
                    .scaledToFill()
                    .overlay(
                        RoundedRectangle(cornerRadius: Constants.cornerRadius)
                            .stroke(
                                selectedImageIndex == index ? Color.blue : Color.clear,
                                lineWidth: 2
                            )
                    )
                    .onTapGesture { selectedImageIndex = index }
            case .failure:
                Color.gray
            @unknown default:
                Color.gray
            }
        }
        .frame(width: Constants.thumbnailSize, height: Constants.thumbnailSize)
        .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    var extraThumbnailCount: some View {
        let count = viewModel.product.imagesURLs.count - 5
        return Text("+\(count)")
            .frame(width: Constants.thumbnailSize, height: Constants.thumbnailSize)
            .background(Color.gray.opacity(0.2))
            .clipShape(RoundedRectangle(cornerRadius: Constants.cornerRadius))
    }

    var headerSection: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: Constants.verticalSpacing) {
                Text(viewModel.product.category)
                    .font(.subheadline)
                    .foregroundColor(.gray)
                Text(viewModel.product.title)
                    .font(.title3)
                Text(viewModel.product.price, format: .currency(code: viewModel.product.currency))
                    .font(.largeTitle.bold())
                    .foregroundColor(.primary)
            }
            Spacer()
            favoriteButton
        }
        .padding(.top, Constants.verticalSpacing)
    }

    var descriptionSection: some View {
        Text(viewModel.product.description)
            .font(.body)
            .multilineTextAlignment(.leading)
            .padding(.bottom, Constants.verticalSpacing)
    }

    var favoriteButton: some View {
        Button(action: { viewModel.toggleFavorite() }) {
            Image(systemName: viewModel.product.isFavorite ? "heart.fill" : "heart")
                .font(.system(size: 28))
                .foregroundColor(viewModel.product.isFavorite ? .red : .primary)
                .padding(Constants.verticalSpacing)
        }
    }
}

// MARK: - Preview
#Preview {
    let sampleProduct = Product(
        id: 1112,
        title: "Classic Black Hooded Sweatshirt",
        price: 50,
        description: "Elevate your casual wardrobe with our Classic Black Hooded SweatshirtSweatshirtS vmweatshirtSweatshirtSweatshirtSweatshirtSweatshirtSweatshirtSweatshirtSweatshirtSweatshirtSweatshirtSweatshirt...",
        images: [
            "https://i.imgur.com/cSytoSD.jpeg",
            "https://i.imgur.com/WwKucXb.jpeg",
            "https://i.imgur.com/cE2Dxh9.jpeg"
        ],
        category: Category(name: "Clothes")
    )
    let productVM = ProductViewModel(product: sampleProduct, isFavorite: false)
    let viewModel = Container.shared.productDetailViewModel(productVM)
    ProductDetailView(viewModel: viewModel)
}
