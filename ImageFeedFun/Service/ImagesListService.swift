//
//  ImagesListService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.03.2025.
//
import Foundation

final class ImagesListService {

    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name(
        rawValue: "ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionDataTask?

    private func makePhotosRequest(numberPage: Int) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/photos" + "?page=\(numberPage)" + "&per_page=10",
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseUrl)
    }

    func fetchPhotosNextPage() {

        let nextPage = (lastLoadedPage ?? 0) + 1
        print("[fetchPhotosNextPage] cuttent page \(nextPage)")

        // Проверить существование Таск
        guard currentTask == nil else { return }

        // Выполнить Таск
        guard let request = makePhotosRequest(numberPage: nextPage) else {
            return
        }

        currentTask = URLSession.shared.dataTask(with: request) {
            [weak self] data, _, error in

            defer { self?.currentTask = nil }

            if let error = error {
                print("[fetchPhotosNextPage] error fetching photos\(error)")
                return
            }

            guard let data = data else {
                print("[fetchPhotosNextPage] no data received")
                return
            }

            do {
                let newPhotos = try JSONDecoder().decode(
                    [Photo].self, from: data)
                self?.photos.append(contentsOf: newPhotos)
                self?.lastLoadedPage = nextPage

                NotificationCenter.default.post(
                    name: ImagesListService.didChangeNotification, object: self)
            } catch {
                print("[fetchPhotosNextPage] error decoding JSON: \(error)")
                return
            }

        }

        currentTask?.resume()
    }

}
