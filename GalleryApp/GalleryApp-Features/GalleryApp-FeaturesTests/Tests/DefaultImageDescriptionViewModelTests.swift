//
//  DefaultImageDescriptionViewModelTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest
import Combine
import Factory

@testable import GalleryApp_Features

// MARK: - DefaultImageDescriptionViewModelTests
final class DefaultImageDescriptionViewModelTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultImageDescriptionViewModel!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultImageDescriptionViewModel()
        GalleryFeaturesContainer.registerMocks()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testSetImages_setsCorrectNumberOfImages() {
        let expectation = XCTestExpectation(description: "Should return empty array")
        let mockImages = GalleryFeaturesMocks.getImagesResponse
        
        sut.setImages(mockImages)
        
        sut.$output
            .sink { images in
                XCTAssertEqual(images.count, mockImages.count, "Expected array with two images")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testSetImages_whenUseCaseReturnsError_setErrorBooleanToTrue() {
        let expectation = XCTestExpectation(description: "Should set isErrorOccurred to true")
        let stubUseCase = Container.shared.galleryFeaturesContainer.getUserFavoriteImagesUseCase.cached.resolve() as! StubGetUserFavoriteImagesUseCase
        stubUseCase.isPositiveScenario = false
        
        sut.setImages(GalleryFeaturesMocks.getImagesResponse)
        
        sut.$isErrorOccurred
            .sink { isErrorOccurred in
                if isErrorOccurred { expectation.fulfill() }
                XCTAssertTrue(isErrorOccurred, "isErrorOccurred should be set to true when error occurrs")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetMoreImages_whenUseCaseReturnsNoData_outputRemainsTheSame() {
        let expectation = XCTestExpectation(description: "Array count shouldn't change")
        let mockImages = GalleryFeaturesMocks.getImagesResponse
        
        sut.setImages(mockImages)
        sut.getMoreImages()
        sut.$output
            .sink { images in
                XCTAssertEqual(images.count, mockImages.count, "Expected array with two images")
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testGetMoreImages_whenUseCaseReturnsError_shouldReturnError() {
        let expectation = XCTestExpectation(description: "Should set isErrorOccurred to true")
        let stubUseCase = Container.shared.galleryFeaturesContainer.getImagesUseCase.cached.resolve() as! StubGetImagesUseCase
        stubUseCase.isPositiveScenario = false
        
        sut.getMoreImages()
        sut.$isErrorOccurred
            .sink { isErrorOccurred in
                if isErrorOccurred { expectation.fulfill() }
                XCTAssertTrue(isErrorOccurred, "isErrorOccurred should be set to true when error occurrs")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
