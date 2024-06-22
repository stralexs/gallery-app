//
//  ImageCollectionViewCellSnapshotTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest
import SnapshotTesting

@testable import GalleryApp_Features

// MARK: - ImageCollectionViewCellSnapshotTests
class ImageCollectionViewCellSnapshotTests: XCTestCase {
    
    // MARK: Properties
    private var sut: ImageCollectionViewCell!
    private var expectation: XCTestExpectation!
    private var size: CGSize!

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = ImageCollectionViewCell()
        GalleryFeaturesContainer.registerMocks()
        expectation = expectation(description: "Wait for view to fully load")
        size = CGSize(width: 300, height: 300)
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testImageCollectionViewCell_loadingState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        
        assertSnapshot(of: sut, as: .image(size: size))
    }
}
