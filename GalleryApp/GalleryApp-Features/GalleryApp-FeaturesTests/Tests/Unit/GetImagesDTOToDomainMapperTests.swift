//
//  GetImagesDTOToDomainMapperTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 21.06.24.
//

import XCTest
import Combine

@testable import GalleryApp_Features

// MARK: - GetImagesDTOToDomainMapperTests
final class GetImagesDTOToDomainMapperTests: XCTestCase {
    
    // MARK: Properties
    private var cancellables: Set<AnyCancellable> = []
    private var sut: GetImagesDTOToDomainMapper!

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = GetImagesDTOToDomainMapper()
    }

    override func tearDownWithError() throws {
        cancellables = []
        sut = nil
        
        try super.tearDownWithError()
    }

    // MARK: Tests
    func testMapModel_returnsCorrectNumberOfImages() {
        let mockDTOs = GalleryFeaturesMocks.getImagesResponseDTO
        
        let images = sut.mapModel(mockDTOs)
        
        XCTAssertEqual(images.count, mockDTOs.count, "The number of DTOs should match the number of domain entities")
    }
    
    func testMapModel_correctlyMapsFields() {
        let mockDTOs = GalleryFeaturesMocks.getImagesResponseDTO
        
        let images = sut.mapModel(mockDTOs)
        
        for (index, value) in mockDTOs.enumerated() {
            XCTAssertEqual(value.id, images[index].id, "The id of the domain entity should  match the title of the DTO")
        }
    }
    
    func testMapModel_handlesEmptyInput() {
        let images = sut.mapModel([])
        
        XCTAssertTrue(images.isEmpty, "Mapping an empty array should return empty array")
    }
}
