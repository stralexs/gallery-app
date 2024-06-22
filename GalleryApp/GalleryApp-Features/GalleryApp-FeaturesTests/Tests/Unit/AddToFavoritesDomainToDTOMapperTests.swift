//
//  AddToFavoritesDomainToDTOMapperTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 21.06.24.
//

import XCTest
import Combine
import Factory

@testable import GalleryApp_Features

// MARK: - AddToFavoritesDomainToDTOMapperTests
final class AddToFavoritesDomainToDTOMapperTests: XCTestCase {
    
    // MARK: Properties
    private var cancellables: Set<AnyCancellable> = []
    private var sut: AddToFavoritesDomainToDTOMapper!

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = AddToFavoritesDomainToDTOMapper()
        Container.registerCoreDataMock()
    }

    override func tearDownWithError() throws {
        cancellables = []
        sut = nil
        
        try super.tearDownWithError()
    }

    // MARK: Tests
    func testMapModel_correctlyMapsFields() {
        let mockRequestDTO = GalleryFeaturesMocks.requestImage
        
        let favoriteImage = sut.mapModel(mockRequestDTO)
        
        XCTAssertEqual(mockRequestDTO.id, favoriteImage.id, "ID should match the initial value")
        XCTAssertEqual(mockRequestDTO.sizeURL.full.absoluteString, favoriteImage.fullSizeURLString, "URL should match the initial value")
    }
}
