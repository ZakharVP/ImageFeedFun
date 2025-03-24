//
//  ImageListViewTests.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//
import XCTest
@testable import ImageFeedFun

final class ImagesListViewPresenterTests: XCTestCase {
    
    var presenter: ImagesListViewPresenterSpy!
    var viewController: ImagesListViewControllerSpy!
    
    override func setUp() {
        super.setUp()
        presenter = ImagesListViewPresenterSpy()
        viewController = ImagesListViewControllerSpy()
        presenter.view = viewController
    }
    
    override func tearDown() {
        presenter = nil
        viewController = nil
        super.tearDown()
    }
    
    func testViewDidLoad() {
        // When
        presenter.viewDidLoad()
        
        // Then
        XCTAssertTrue(presenter.viewDidLoadCalled, "viewDidLoad() should be called")
    }
    
    func testFetchPhotosNextPage() {
        // When
        presenter.fetchPhotosNextPage { _ in }
        
        // Then
        XCTAssertTrue(presenter.fetchPhotosNextPageCalled, "fetchPhotosNextPage() should be called")
    }
    
    func testUpdateTableViewAnimated() {
        // When
        presenter.updateTableViewAnimated()
        
        // Then
        XCTAssertTrue(presenter.updateTableViewAnimatedCalled, "updateTableViewAnimated() should be called")
    }
    
    func testPrepareForSegue() {
        // Given
        let segue = UIStoryboardSegue(identifier: "ShowSingleImage", source: UIViewController(), destination: UIViewController())
        let sender = IndexPath(row: 0, section: 0)
        
        // When
        presenter.prepareForSegue(segue: segue, sender: sender)
        
        // Then
        XCTAssertTrue(presenter.prepareForSegueCalled, "prepareForSegue() should be called")
    }
}
