//
//  ProductsGridView.swift
//  MarktGuru
//
//  Created by Ahmed Madian on 28.04.25.
//

import SwiftUI
import Factory

struct ProductsGridView: View {
    // MARK: - Dependencies
    @Injected(\.productsViewModel) private var viewModel
    @State private var router = ProductsRouter()

    // MARK: - Layout Constants
    private enum Constants {
        static let gridSpacing: CGFloat = 16
        static let columnCount: Int = 2
        static let contentPadding: CGFloat = 16
        static let overlayOpacity: Double = 0.7
        static let overlayPadding: CGFloat = 16
        static let itemSpacing: CGFloat = 8
    }

    private let columns = Array(
        repeating: GridItem(.flexible(), spacing: 16),
        count: 2
    )

    // MARK: - Body
    var body: some View {
        NavigationStack(path: $router.path) {
            content
                .navigationTitle("Products")
                .navigationDestination(for: ProductsRouter.Destination.self) { destination in
                    destinationView(for: destination)
                }
        }
    }
}

// MARK: - Subviews
private extension ProductsGridView {
    @ViewBuilder
    var content: some View {
        switch viewModel.state {
        case .fetching:
            loadingOverlay
        case let .data(products):
            productsGrid(products)
        case let .error(message):
            errorView(message)
        }
    }

    func productsGrid(_ products: [ProductViewModel]) -> some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: Constants.gridSpacing) {
                ForEach(products) { model in
                    ProductRow(viewModel: model) {
                        viewModel.toggleFavorite(model.id)
                    }
                    .onTapGesture { navigateToDetail(model) }
                    .onAppear { loadMoreIfNeeded(currentId: model.id) }
                }
            }
            .padding(Constants.contentPadding)

            if viewModel.isLoadingMore {
                ProgressView()
                    .frame(maxWidth: .infinity)
                    .padding(Constants.contentPadding)
            }
        }
    }

    var loadingOverlay: some View {
        ZStack {
            Color(.systemBackground)
                .opacity(Constants.overlayOpacity)
                .edgesIgnoringSafeArea(.all)
            ProgressView("Loading...")
                .padding(Constants.overlayPadding)
        }
    }

    func errorView(_ message: String) -> some View {
        VStack(spacing: Constants.itemSpacing) {
            Text("Oops!")
                .font(.title2)
                .bold()
            Text(message)
                .multilineTextAlignment(.center)
            Button("Retry") {
                Task { await viewModel.retry() }
            }
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

// MARK: - Navigation & Actions
private extension ProductsGridView {
    @ViewBuilder
    func destinationView(for destination: ProductsRouter.Destination) -> some View {
        switch destination {
        case let .detail(model):
            let detailVM = Container.shared.productDetailViewModel(model)
            ProductDetailView(viewModel: detailVM)
        }
    }

    func navigateToDetail(_ model: ProductViewModel) {
        router.path.append(.detail(model))
    }

    func loadMoreIfNeeded(currentId: Int) {
        Task { await viewModel.loadMoreIfNeeded(currentProductId: currentId) }
    }
}

// MARK: - Preview
#Preview {
    ProductsGridView()
}
