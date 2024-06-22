//
//  DefaultUserFavoriteImagesViewModelTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest
import Combine
import Factory

@testable import GalleryApp_Features

// MARK: - DefaultUserFavoriteImagesViewModelTests
final class DefaultUserFavoriteImagesViewModelTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultUserFavoriteImagesViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultUserFavoriteImagesViewModel()
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
    
    func testOnViewDidLoad_whenUseCaseReturnsData_returnsURLs() {
        let expectation = XCTestExpectation(description: "Should return URLs")
        let mockResponse = GalleryFeaturesMocks.getFavoritesResponse
        let stubUseCase = Container.shared.galleryFeaturesContainer.getUserFavoriteImagesUseCase.cached.resolve() as! StubGetUserFavoriteImagesUseCase
        stubUseCase.getFavoritesResponse = mockResponse
        
        sut.onViewDidLoad()
        sut.output
            .sink { loadingState in
                switch loadingState {
                case .loaded(let value):
                    XCTAssertEqual(value.count, mockResponse.count, "Expected array with two URLs")
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
        let stubUseCase = Container.shared.galleryFeaturesContainer.getUserFavoriteImagesUseCase.cached.resolve() as! StubGetUserFavoriteImagesUseCase
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
}
