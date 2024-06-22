//
//  DefaultImagesListViewModelTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 21.06.24.
//

import XCTest
import Combine
import Factory

@testable import GalleryApp_Features

// MARK: - DefaultImagesListViewModelTests
final class DefaultImagesListViewModelTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultImagesListViewModel!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultImagesListViewModel()
        GalleryFeaturesContainer.registerMocks()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testOnViewDidLoad_whenUseCaseReturnsNoData_outputIsEmpty() {
        let expectation = XCTestExpectation(description: "Should return empty array")
        
        sut.onViewDidLoad()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .loaded(let value):
                    XCTAssertTrue(value.isEmpty, "Expected empty array")
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testOnViewDidLoad_whenUseCaseReturnsData_returnsImages() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockResponse = GalleryFeaturesMocks.getImagesResponse
        let stubUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubUseCase.getImagesResponse = mockResponse
        
        sut.onViewDidLoad()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .loaded(let value):
                    XCTAssertEqual(value.count, mockResponse.count, "Expected array with two images")
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testOnViewDidLoad_whenUseCaseReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let stubUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubUseCase.isPositiveScenario = false
        
        sut.onViewDidLoad()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .failed:
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testOnViewIsAppearing_whenUseCaseReturnsNoData_outputIsNotMapped() {
        let expectation = XCTestExpectation(description: "Should not map existing images")
        let mockResponse = GalleryFeaturesMocks.getImagesResponse
        let stubUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubUseCase.getImagesResponse = mockResponse
        
        sut.onViewDidLoad()
        sut.onViewIsAppearing()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .loaded(let value):
                    for image in value {
                        XCTAssertTrue(image.isFavorite, "Expected isFavorite to not be toggled")
                    }
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testOnViewIsAppearing_whenUseCaseReturnsData_outputIsMapped() {
        let expectation = XCTestExpectation(description: "Should map existing images")
        let mockResponse = GalleryFeaturesMocks.getImagesResponse
        let stubGetImagesUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubGetImagesUseCase.getImagesResponse = mockResponse
        let mockFavoritesResponse = GalleryFeaturesMocks.getFavoritesResponse
        let stubGetFavoritesUseCase = Container.shared.galleryFeaturesContainer.getUserFavoriteImagesUseCase.cached.resolve() as! StubGetUserFavoriteImagesUseCase
        stubGetFavoritesUseCase.getFavoritesResponse = mockFavoritesResponse
        
        sut.onViewDidLoad()
        sut.onViewIsAppearing()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .loaded(let value):
                    for image in value {
                        XCTAssertFalse(image.isFavorite, "Expected isFavorite to be toggled")
                    }
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testOnViewIsAppearing_whenUseCaseReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let stubUseCase = Container.shared.galleryFeaturesContainer.getUserFavoriteImagesUseCase.cached.resolve() as! StubGetUserFavoriteImagesUseCase
        stubUseCase.isPositiveScenario = false
        
        sut.onViewIsAppearing()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .failed:
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetMoreImages_whenUseCaseReturnsNoData_outputRemainsTheSame() {
        let expectation = XCTestExpectation(description: "Array count shouldn't change")
        let mockResponse = GalleryFeaturesMocks.getImagesResponse
        let stubUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubUseCase.getImagesResponse = mockResponse
        
        sut.onViewDidLoad()
        sut.getMoreImages()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .loaded(let value):
                    XCTAssertEqual(value.count, mockResponse.count, "Expected empty array")
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetMoreImages_whenUseCaseReturnsError_shouldReturnError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let stubUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubUseCase.isPositiveScenario = false
        
        sut.getMoreImages()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .failed:
                    expectation.fulfill()
                default:
                    XCTFail("Error received")
                }
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testNavigateToImageDescription_performsNavigation() {
        let mockCoordinator = MockImagesListCoordinator()
        sut.delegate = mockCoordinator
        sut.onViewDidLoad()
        
        sut.navigateToImageDescription(selectedImage: 0)
        
        XCTAssertTrue(mockCoordinator.isNavigatedToImageDescription, "Should've nagitated to image description screen")
    }
    
    func testNavigateToUserFavoriteImages_performsNavigation() {
        let mockCoordinator = MockImagesListCoordinator()
        sut.delegate = mockCoordinator
        
        sut.navigateToUserFavoriteImages()
        
        XCTAssertTrue(mockCoordinator.isNavigatedToUserFavoriteImages, "Should've nagitated to favorite images screen")
    }
}
