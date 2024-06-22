//
//  ImageDescriptionBuilderTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest

@testable import GalleryApp_Features

// MARK: - ImageDescriptionBuilderTests
final class ImageDescriptionBuilderTests: XCTestCase {
    
    // MARK: Properties
    private var sut: ImageDescriptionBuilder!
    
    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = ImageDescriptionBuilder()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testBuild_createsExpectedType() {
        typealias ExpectedType = GalleryHostingController<ImageDescriptionView<DefaultImageDescriptionViewModel>>
        let viewController = sut.build()
        
        XCTAssertTrue(viewController is ExpectedType, "Expected view controller to be of ExptectedType type")
    }
    
    func testSet_returnsCorrectBuilderType() {
        let bulder = sut.set(delegate: self)
        XCTAssertTrue(bulder is ImageDescriptionBuilder, "Expected builder to be of ImageDescriptionBuilder type")
    }
}

// MARK: - DelegateDummy
fileprivate protocol DelegateDummy: AnyObject {}

// MARK: - Private
extension ImagesListBuilderTests: DelegateDummy {}
