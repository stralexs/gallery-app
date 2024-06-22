//
//  DefaultGalleryFeaturesRepositoryTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 20.06.24.
//

import XCTest
import Combine

@testable import GalleryApp_Features

// MARK: - DefaultGalleryFeaturesRepositoryTests
final class DefaultGalleryFeaturesRepositoryTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultGalleryFeaturesRepository!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultGalleryFeaturesRepository()
        GalleryFeaturesContainer.registerMocks()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testGetImages_whenDataSourceReturnsNoData_returnsEmptyArray() {
        let expectation = XCTestExpectation(description: "Should return empty array")
        
        sut.getImages(requestDTO: 0)
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
    
    func testGetImages_whenDataSourceReturnsData_returnsImages() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockResponse = GalleryFeaturesMocks.getImagesResponseDTO
        let stubDataSource = GalleryFeaturesContainer.shared.galleryFeaturesDataSource.cached.resolve() as! StubGalleryFeaturesDataSource
        stubDataSource.getImagesResponse = mockResponse
        
        sut.getImages(requestDTO: 0)
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
    
    func testGetImages_whenDataSourceReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.networkError
        let stubDataSource = GalleryFeaturesContainer.shared.galleryFeaturesDataSource.cached.resolve() as! StubGalleryFeaturesDataSource
        stubDataSource.isPositiveScenario = false
        
        sut.getImages(requestDTO: 0)
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
    
    func testGetFavorites_whenDataSourceReturnsNoData_returnsEmptyArray() {
        let expectation = XCTestExpectation(description: "Should return empty array")
        
        sut.getFavorites()
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
    
    func testGetFavorites_whenDataSourceReturnsData_returnsImages() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockResponse = GalleryFeaturesMocks.getFavoritesResponse
        let stubDataSource = GalleryFeaturesContainer.shared.galleryFeaturesDataSource.cached.resolve() as! StubGalleryFeaturesDataSource
        stubDataSource.getFavoritesResponse = mockResponse
        
        sut.getFavorites()
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
    
    func testGetFavorites_whenDataSourceReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let stubDataSource = GalleryFeaturesContainer.shared.galleryFeaturesDataSource.cached.resolve() as! StubGalleryFeaturesDataSource
        stubDataSource.isPositiveScenario = false
        
        sut.getFavorites()
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
    
    func testAddToFavorites_whenDataSourceReturnsVoid_Succeeds() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockRequest = GalleryFeaturesMocks.requestImage
        
        sut.addToFavorites(requestDTO: mockRequest)
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
    
    func testAddToFavorites_whenDataSourceReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let mockRequest = GalleryFeaturesMocks.requestImage
        let stubDataSource = GalleryFeaturesContainer.shared.galleryFeaturesDataSource.cached.resolve() as! StubGalleryFeaturesDataSource
        stubDataSource.isPositiveScenario = false
        
        sut.addToFavorites(requestDTO: mockRequest)
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
    
    func testRemoveFromFavorites_whenDataSourceReturnsVoid_Succeeds() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockRequest = GalleryFeaturesMocks.requestFavoriteImage
        
        sut.removeFromFavorites(requestDTO: mockRequest)
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
    
    func testRemoveFromFavorites_whenDataSourceReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let mockRequest = GalleryFeaturesMocks.requestFavoriteImage
        let stubDataSource = GalleryFeaturesContainer.shared.galleryFeaturesDataSource.cached.resolve() as! StubGalleryFeaturesDataSource
        stubDataSource.isPositiveScenario = false
        
        sut.removeFromFavorites(requestDTO: mockRequest)
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
