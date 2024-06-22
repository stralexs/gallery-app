//
//  DefaultGetUserFavoriteImagesUseCaseTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import XCTest
import Combine

@testable import GalleryApp_Features

// MARK: - DefaultGetUserFavoriteImagesUseCaseTests
final class DefaultGetUserFavoriteImagesUseCaseTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultGetUserFavoriteImagesUseCase!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultGetUserFavoriteImagesUseCase()
        GalleryFeaturesContainer.registerMocks()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testExecute_whenRepositoryReturnsNoData_returnsEmptyArray() {
        let expectation = XCTestExpectation(description: "Should return empty array")
        
        sut.execute(request: ())
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Error recieved")
                }
            } receiveValue: { images in
                XCTAssertTrue(images.isEmpty, "Expected empty array")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testEcecute_whenRepositoryReturnsData_returnsImages() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockResponse = GalleryFeaturesMocks.getFavoritesResponse
        let stubRepository = GalleryFeaturesContainer.shared.galleryFeaturesRepository.cached.resolve() as! StubGalleryFeaturesRepository
        stubRepository.getFavoritesResponse = mockResponse
        
        sut.execute(request: ())
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Error recieved")
                }
            } receiveValue: { response in
                XCTAssertEqual(response.count, mockResponse.count, "Expected array with two images")
                
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testExecute_whenRepositoryReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let stubRepository = GalleryFeaturesContainer.shared.galleryFeaturesRepository.cached.resolve() as! StubGalleryFeaturesRepository
        stubRepository.isPositiveScenario = false
        
        sut.execute(request: ())
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Error recieved")
                case .failure(let error):
                    expectation.fulfill()
                    XCTAssertEqual(error, mockError, "Expected errors to be equal")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
