//
//  ImageListViewPresenterSpy.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//

import UIKit

final class ImagesListViewPresenterSpy: ImagesListViewPresenterProtocol {
    weak var view: ImagesListViewControllerProtocol?
    var photos: [Photo] = []
    var cellHeights: [IndexPath: CGFloat] = [:]
    
    var viewDidLoadCalled = false
    var fetchPhotosNextPageCalled = false
    var updateTableViewAnimatedCalled = false
    var prepareForSegueCalled = false
    
    func viewDidLoad() {
        viewDidLoadCalled = true
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void) {
        fetchPhotosNextPageCalled = true
    }
    
    func updateTableViewAnimated() {
        updateTableViewAnimatedCalled = true
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
        prepareForSegueCalled = true
    }
    
    func updatePhotoLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
        // Реализация для тестирования обновления статуса лайка
    }
}
