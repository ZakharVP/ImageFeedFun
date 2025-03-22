//
//  ImageListViewControllerSpy.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//

import UIKit

final class ImagesListViewControllerSpy: UIViewController, ImagesListViewControllerProtocol {
    var showSingleImageSegueIdentifier: String = "ShowSingleImage"
    
    var performBatchUpdatesCalled = false
    var insertRowsCalled = false
    var updateTableViewAnimatedCalled = false
    
    func performBatchUpdates(_ updates: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        performBatchUpdatesCalled = true
        updates()
        completion?(true)
    }
    
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        insertRowsCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
}
