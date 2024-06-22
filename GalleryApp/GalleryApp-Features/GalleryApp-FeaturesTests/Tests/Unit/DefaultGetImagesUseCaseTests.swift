//
//  DefaultGetImagesUseCaseTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import XCTest
import Combine

@testable import GalleryApp_Features

// MARK: - DefaultGetImagesUseCaseTests
final class DefaultGetImagesUseCaseTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultGetImagesUseCase!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultGetImagesUseCase()
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
        
        sut.execute(request: 0)
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
        let mockResponse = GalleryFeaturesMocks.getImagesResponse
        let stubRepository = GalleryFeaturesContainer.shared.galleryFeaturesRepository.cached.resolve() as! StubGalleryFeaturesRepository
        stubRepository.getImagesResponse = mockResponse
        
        sut.execute(request: 0)
            .sink { completion in
                switch completion {
                case .finished:
                    expectation.fulfill()
                case .failure:
                    XCTFail("Error recieved")
                }
            } receiveValue: { images in
                XCTAssertEqual(images.count, mockResponse.count, "Expected array with two images")
                
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
    
    func testExecute_whenRepositoryReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.networkError
        let stubRepository = GalleryFeaturesContainer.shared.galleryFeaturesRepository.cached.resolve() as! StubGalleryFeaturesRepository
        stubRepository.isPositiveScenario = false
        
        sut.execute(request: 0)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("Error recieved")
                case .failure(let error):
                    expectation.fulfill()
                    XCTAssertEqual(error.response, mockError.response, "Expected response to be equal")
                    XCTAssertEqual(error.errorDescription, mockError.errorDescription, "Expected errorDescription to be equal")
                }
            } receiveValue: { _ in }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 1)
    }
}
