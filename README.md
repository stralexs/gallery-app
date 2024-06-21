# Gallery App

![1](https://github.com/stralexs/gallery-app/assets/123239625/4951ccb4-816f-4b65-bd02-c7b2de92c393)

GalleryApp is an application that utilises Unsplash API’s library of images and provides user-friendly UI for viewing images. Application provides basic data persistence for retrieving list of favorite images.

## Stack
- iOS 15
- Swift
- Modularity
- MVVM + Clean
- Combine
- Coordinator
- UIKit, SwiftUI
- DI: Factory
- SnapKit
- CoreData
- Moya
- Kingfisher
- Tests: Unit (XCTestCase), Snapshot (SnapshotTesting)

## Installation

To install application on your machine clone repository and open GalleryApp.xcworkspace file within GalleryApp folder.

## UI

Application works fine in both portrait and landscape orientation and supports devices of all screen sizes due to adaptive layout. ImagesList and UserFavoriteImages screens are written in UIKit+SnapKit without Storyboard. ImageDescription screen is written in SwiftUI and integrated into UIKit flow using custom UIHostingController.

![2](https://github.com/stralexs/gallery-app/assets/123239625/aa3bf272-e354-46df-99b2-06032ef5ff5d)

## Architecture

Application has framework-based modularity:
- GalleryApp: main module which contains SceneDelegate and AppCoordinator to perform navigation flow + application target
- GalleryApp-Features: ImagesList, ImageDescription and UserFavoriteImages screens
- GalleryApp-Network:Moya-based NetworkManager and all required types and interfaces
- GalleryApp-Core: high-level rules (protocols) for application and types extensions
- GalleryApp-Models: domain and DTO models + CoreData model
- GalleryApp-CoreData: CoreDataManager class and interface
- GalleryApp-Navigation: coordinator pattern classes and interfaces

In Features module there is a MVVM+Clean architecture: 
- Presentation layer with MVVM architecture pattern
- Domain layer which sets high-level business rules and use cases
- Data layer for retrieving data from database or network
- Repository and mappers as a sublayer between Domain and Data layers to transform DTO models to domain and vice versa
More about this architecture [here](https://tech.olx.com/clean-architecture-and-mvvm-on-ios-c9d167d9f5b3)

Application uses Combine for reactive updates of UI.
Coordinator pattern is used to perform navigation.
Factory library is used to inject dependencies.
Tests are written for Features module.
