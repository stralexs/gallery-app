//
//  DefaultImageCollectionViewCellViewModelTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest
import Combine
import Factory

@testable import GalleryApp_Features

// MARK: - DefaultImageCollectionViewCellViewModelTests
final class DefaultImageCollectionViewCellViewModelTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultImageCollectionViewCellViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultImageCollectionViewCellViewModel()
        GalleryFeaturesContainer.registerMocks()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testSet_setsImageCorrectly() {
        let expectation = XCTestExpectation(description: "Should set image correctly")
        let mockImage = GalleryFeaturesMocks.requestImage
        sut.set(mockImage)
        
        sut.output
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Error recieved")
                }
            } receiveValue: { image in
                XCTAssertEqual(image.id, mockImage.id, "Expected id to be identical")
                XCTAssertEqual(image.description, mockImage.description, "Expected description to be identical")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSet_whenUseCaseReturnsError_setErrorBooleanToTrue() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let stubUseCase = Container.shared.galleryFeaturesContainer.getUserFavoriteImagesUseCase.cached.resolve() as! StubGetUserFavoriteImagesUseCase
        stubUseCase.isPositiveScenario = false
        sut.set(GalleryFeaturesMocks.requestImage)
        
        sut.output
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
    
    func testToggleIsFavorite_whenAddsToFavorites_isFavoriteEqualsTrue() {
        let expectation = XCTestExpectation(description: "Should set isFavorite to true")
        sut.set(GalleryFeaturesMocks.requestImage)
        sut.toggleIsFavorite()
        
        sut.output
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure:
                    XCTFail("Error recieved")
                }
            } receiveValue: { image in
                XCTAssertTrue(image.isFavorite, "Expected isFavorite to be true")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testToggleIsFavorite_whenAddsToFavoritesReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let stubUseCase = GalleryFeaturesContainer.shared.addToFavoritesUseCase.cached.resolve() as! StubAddToFavoritesUseCase
        stubUseCase.isPositiveScenario = false
        sut.set(GalleryFeaturesMocks.requestImage)
        sut.toggleIsFavorite()
        
        sut.output
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
