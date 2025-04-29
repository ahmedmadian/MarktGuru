# MarktGuru

## Architecture

The App is structured using a modular **MVVM (Model-View-ViewModel)** architecture with a Repository layer and dependency injection facilitated by [Factory](https://github.com/hmlongco/Factory). 

The high-level modules are:

- **Factory**: Defines dependency injection containers and registration (`Container+*.swift`).
- **Data**:
  - **Model**: Core data models (`Product.swift`, `Favorite.swift`).
  - **Networking**: API endpoints and client (`ProductsAPIEndpoint.swift`, `ProductsAPIClient.swift`).
  - **Persistence**: Local storage (`FavoritesDataSource.swift` using CoreData).
  - **Repo**: Repository interface and implementation (`ProductsRepo.swift`).
- **Presentation**:
  - **ViewModels**: Business logic and state (`ProductsViewModel.swift`, etc.).
  - **Views**: SwiftUI views for product list, details, favorites, and settings.
- **Resources**: Asset catalogs (`Assets.xcassets`).
- **Preview Content**: Stub data and clients for SwiftUI previews.
- **Tests**: Unit tests for API client, repository, persistence, and view models, with mock implementations.

## Data Flow

1. **Startup**: `MarktGuruApp` initializes the Factory container and injects dependencies into the root view.
2. **Fetching Products**:
   - `ProductsViewModel` calls `ProductsRepository.fetchProducts()`.
   - `ProductsRepository` uses `ProductsAPIClient` (`URLSession`) to fetch JSON data from the remote API.
   - The response is decoded into `Product` models and returned to the ViewModel.
3. **Favorites Persistence**:
   - When a user favorites/unfavorites a product, `ProductsViewModel` calls `ProductsRepository.toggleFavorite(_:)`.
   - The repository delegates to `FavoritesDataSource`, which uses CoreData to store/remove a `Favorite` entity.
   - On next load, the repository merges remote products with local favorites.
4. **UI Update**: The ViewModel publishes changes via `@Published` properties, and SwiftUI views reactively update.

## Approximate Time Spent
**Total:** ~14 hours

## External Libraries

- **[Factory](https://github.com/hmlongco/Factory)**:
  - Provides a lightweight, Swift-native dependency injection container.
  - Enables decoupled module wiring, easier testing, and clearer singleton management.

_All other frameworks (SwiftUI, Foundation, CoreData) are Apple-provided and require no additional installation._

## AI Usage

AI Used in documenting and drafting the README file  
