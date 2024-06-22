//
//  DefaultGalleryFeaturesDataSourceTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 21.06.24.
//

import XCTest
import Combine
import Factory

@testable import GalleryApp_Features

// MARK: - DefaultGalleryFeaturesDataSourceTests
final class DefaultGalleryFeaturesDataSourceTests: XCTestCase {
    
    // MARK: Properties
    private var sut: DefaultGalleryFeaturesDataSource!
    private var cancellables: Set<AnyCancellable> = []

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = DefaultGalleryFeaturesDataSource()
        GalleryFeaturesContainer.registerMocks()
        Container.registerNetworkMock()
        Container.registerCoreDataMock()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        cancellables = []
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testGetImages_whenNetworkManagerReturnsNoData_returnsEmptyArray() {
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
    
    func testGetImages_whenNetworkManagerReturnsData_returnsImages() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockResponse = GalleryFeaturesMocks.getImagesResponseDTO
        let mockNetworkManager = Container.shared.networkManager.resolve() as! MockNetworkManager
        mockNetworkManager.getImagesResponse = mockResponse
        
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
    
    func testGetImages_whenNetworkManagerReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.networkError
        let mockNetworkManager = Container.shared.networkManager.resolve() as! MockNetworkManager
        mockNetworkManager.isPositiveScenario = false
        
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
    
    func testGetFavorites_whenCoreDataManagerReturnsNoData_returnsEmptyArray() {
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
    
    func testGetFavorites_whenCoreDataManagerReturnsData_returnsImages() {
        let expectation = XCTestExpectation(description: "Should return images")
        let mockResponse = GalleryFeaturesMocks.getFavoritesResponse
        let mockCoreDatakManager = Container.shared.coreDataManager.resolve() as! MockCoreDataManager
        mockCoreDatakManager.getFavoritesResponse = mockResponse
        
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
    
    func testGetFavorites_whenCoreDataManagerReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let mockCoreDatakManager = Container.shared.coreDataManager.resolve() as! MockCoreDataManager
        mockCoreDatakManager.isPositiveScenario = false
        
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
    
    func testAddToFavorites_whenCoreDataManagerReturnsVoid_Succeeds() {
        let expectation = XCTestExpectation(description: "Should return images")
        
        sut.addToFavorites(requestDTO: GalleryFeaturesMocks.requestFavoriteImage)
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
    
    func testAddToFavorites_whenCoreDataManagerReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let mockCoreDatakManager = Container.shared.coreDataManager.resolve() as! MockCoreDataManager
        mockCoreDatakManager.isPositiveScenario = false
        
        sut.addToFavorites(requestDTO: GalleryFeaturesMocks.requestFavoriteImage)
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
    
    func testRemoveFromFavorites_whenCoreDataManagerReturnsVoid_Succeeds() {
        let expectation = XCTestExpectation(description: "Should return images")
        
        sut.removeFromFavorites(requestDTO: GalleryFeaturesMocks.requestFavoriteImage)
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
    
    func testRemoveFromFavorites_whenCoreDataManagerReturnsError_returnsError() {
        let expectation = XCTestExpectation(description: "Should return error")
        let mockError = GalleryFeaturesMocks.coreDataError
        let mockCoreDatakManager = Container.shared.coreDataManager.resolve() as! MockCoreDataManager
        mockCoreDatakManager.isPositiveScenario = false
        
        sut.removeFromFavorites(requestDTO: GalleryFeaturesMocks.requestFavoriteImage)
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
