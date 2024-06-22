//
//  DefaultAddToFavoritesUseCaseTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import XCTest
import Combine
import GalleryApp_Models

@testable import GalleryApp_Features

// MARK: - DefaultAddToFavoritesUseCaseTests
final class DefaultAddToFavoritesUseCaseTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultAddToFavoritesUseCase!
    private var mockRequest: GalleryApp_Models.Image!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultAddToFavoritesUseCase()
        mockRequest = GalleryFeaturesMocks.requestImage
        GalleryFeaturesContainer.registerMocks()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        mockRequest = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testEcecute_whenRepositoryReturnsVoid_Succeeds() {
        let expectation = XCTestExpectation(description: "Should return images")
        
        sut.execute(request: mockRequest)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTAssert(true, "Error recieved")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testExecute_whenRepositoryReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let stubRepository = GalleryFeaturesContainer.shared.galleryFeaturesRepository.cached.resolve() as! StubGalleryFeaturesRepository
        stubRepository.isPositiveScenario = false
        
        sut.execute(request: mockRequest)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTAssert(true, "Error recieved")
                case .failure(let error):
                    expectation.fulfill()
                    XCTAssertEqual(error, mockError, "Expected errors to be equal")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
