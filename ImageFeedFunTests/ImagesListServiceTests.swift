//
//  ImageFeedFunTests.swift
//  ImageFeedFunTests
//
//  Created by Захар Панченко on 09.03.2025.
//

import XCTest

@testable import ImageFeedFun

final class ImagesListsServiceTests: XCTestCase {
//    func testFetchPhotos() {
//        let service = ImagesListService()
//        let expectation = XCTestExpectation(description: "Fetch photos")
//    }

    func testFetchPhotos() {
        let service = ImagesListService()
        let expectation = self.expectation(description: "Wait for Notification")
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { _ in
            expectation.fulfill()
        }
        service.fetchPhotosNextPage()
        wait(for: [expectation], timeout: 10)

        XCTAssertEqual(service.photos.count, 10)
    }
}
