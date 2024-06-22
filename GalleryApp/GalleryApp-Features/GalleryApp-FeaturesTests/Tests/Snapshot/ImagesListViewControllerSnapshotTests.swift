//
//  ImagesListViewControllerSnapshotTests.swift
//  GalleryApp-FeaturesTests
//
//  Created by Alexander Sivko on 22.06.24.
//

import XCTest
import Factory
import SnapshotTesting

@testable import GalleryApp_Features

// MARK: - ImagesListViewControllerSnapshotTests
class ImagesListViewControllerSnapshotTests: XCTestCase {
    
    // MARK: Properties
    private var sut: ImagesListViewController!
    private var stubViewModel: StubImagesListViewModel!
    private var expectation: XCTestExpectation!

    // MARK: Override
    override func setUpWithError() throws {
        try super.setUpWithError()
        
        GalleryFeaturesContainer.registerMocks()
        stubViewModel = GalleryFeaturesContainer.shared.imagesListViewModel.resolve() as? StubImagesListViewModel
        sut = ImagesListViewController(viewModel: stubViewModel)
        expectation = expectation(description: "Wait for view to fully load")
    }
    
    override func tearDownWithError() throws {
        sut = nil
        
        try super.tearDownWithError()
    }
    
    // MARK: Tests
    func testImagesListViewController_loadingState() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
    
    func testImagesListViewController_loadedImagesState() {
        stubViewModel.mockImageLoad(GalleryFeaturesMocks.getImagesResponse)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
    
    func testImagesListViewController_failureState() {
        stubViewModel.mockLoadingFailure()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { self.expectation.fulfill() }
        wait(for: [expectation], timeout: 2)
        
        assertSnapshot(of: sut, as: .image(on: .iPhone13Pro))
    }
}
