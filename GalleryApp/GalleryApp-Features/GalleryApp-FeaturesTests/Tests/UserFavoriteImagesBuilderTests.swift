//
//  UserFavoriteImagesBuilderTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest

@testable import GalleryApp_Features

// MARK: - UserFavoriteImagesBuilderTests
final class UserFavoriteImagesBuilderTests: XCTestCase {
    
    // MARK: Properties
    private var sut: UserFavoriteImagesBuilder!
    
    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        sut = UserFavoriteImagesBuilder()
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testBuild_createsExpectedType() {
        let viewController = sut.build()
        
        XCTAssertTrue(viewController is UserFavoriteImagesViewController, "Expected view controller to be of UserFavoriteImagesViewController type")
    }
    
    func testSet_returnsCorrectBuilderType() {
        let bulder = sut.set(delegate: self)
        XCTAssertTrue(bulder is UserFavoriteImagesBuilder, "Expected builder to be of UserFavoriteImagesBuilder type")
    }
}

// MARK: - DelegateDummy
fileprivate protocol DelegateDummy: AnyObject {}

// MARK: - Private
extension ImagesListBuilderTests: DelegateDummy {}
