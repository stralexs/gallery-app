//
//  ImagesListBuilderTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest

@testable import GalleryApp_Features

// MARK: - ImagesListBuilderTests
final class ImagesListBuilderTests: XCTestCase {
    
    // MARK: Properties
    private var sut: ImagesListBuilder!
    
    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = ImagesListBuilder()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testBuild_createsExpectedType() {
        let viewController = sut.build()
        
        XCTAssertTrue(viewController is ImagesListViewController, "Expected view controller to be of ImagesListViewController type")
    }
    
    func testSet_returnsCorrectBuilderType() {
        let bulder = sut.set(delegate: self)
        XCTAssertTrue(bulder is ImagesListBuilder, "Expected builder to be of ImagesListBuilder type")
    }
}

// MARK: - DelegateDummy
fileprivate protocol DelegateDummy: AnyObject {}

// MARK: - Private
extension ImagesListBuilderTests: DelegateDummy {}
