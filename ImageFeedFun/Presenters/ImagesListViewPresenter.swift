//
//  ImagesListViewPresenter.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//
import UIKit

final class ImagesListViewPresenter: ImagesListViewPresenterProtocol {
      
    weak var view: ImagesListViewControllerProtocol?
    let imagesListService: ImagesListServiceProtocol
    var photos: [Photo] = []
    var cellHeights: [IndexPath: CGFloat] = [:]

    init(imagesListService: ImagesListServiceProtocol = ImagesListService.shared) {
        self.imagesListService = imagesListService
    }

    func viewDidLoad() {
        setupNotificationObserver()
        fetchPhotos()
    }
    
    func fetchPhotosNextPage(completion: @escaping (Result<Void, any Error>) -> Void) {
        imagesListService.fetchPhotosNextPage { [weak self] result in
                  guard let self = self else { return }
                  switch result {
                  case .success(let photos):
                      self.photos = photos
                      self.view?.updateTableViewAnimated()
                      completion(.success(()))
                  case .failure(let error):
                      print("Failed to fetch photos: \(error)")
                      completion(.failure(error))
                  }
              }
    }
    func fetchPhotos() {
        imagesListService.fetchPhotosNextPage { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let photos):
                self.photos = photos
                self.view?.updateTableViewAnimated()
            case .failure(let error):
                print("Failed to fetch photos: \(error)")
            }
        }
    }

    func updateTableViewAnimated() {
        let oldCount = photos.count
        let newCount = imagesListService.photos.count
        photos = imagesListService.photos

        if oldCount != newCount {
            view?.performBatchUpdates({
                let indexPaths = (oldCount..<newCount).map { IndexPath(row: $0, section: 0) }
                self.view?.insertRows(at: indexPaths, with: .automatic)
            }, completion: nil)
        }
    }

    func prepareForSegue(segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == view?.showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            let photo = photos[indexPath.row]
            let url = URL(string: photo.largeImageURL)
            viewController.imageURL = url
        }
    }
    
    func updatePhotoLikeStatus(at indexPath: IndexPath, isLiked: Bool) {
           photos[indexPath.row].isLiked = isLiked
       }

    private func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            forName: ImagesListService.didChangeNotification,
            object: nil,
            queue: .main
        ) { [weak self] _ in
            self?.updateTableViewAnimated()
        }
    }
}
