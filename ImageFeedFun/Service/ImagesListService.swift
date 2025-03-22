//
//  ImagesListService.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.03.2025.
//
import Foundation

final class ImagesListService {

    static let shared = ImagesListService()
    static let didChangeNotification = Notification.Name("ImagesListServiceDidChange")
    private(set) var photos: [Photo] = []
    private var lastLoadedPage: Int?
    private var currentTask: URLSessionDataTask?

    private func makePhotosRequest(numberPage: Int) -> URLRequest? {
        URLRequest.makeHTTPRequest(
            path: "/photos" + "?page=\(numberPage)" + "&per_page=10",
            httpMethod: "GET",
            baseURLString: Constants.defaultBaseUrl.absoluteString)
    }

    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void) {

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

            if let error = error {
                print("[fetchPhotosNextPage] error fetching photos\(error)")
                return
            }

            guard let data = data else {
                print("[fetchPhotosNextPage] no data received")
                return
            }

            let decoder = JSONDecoder()

            do {

                let newPhotosResults = try decoder.decode(
                    [PhotoResult].self, from: data)
                let newPhotos = newPhotosResults.map { $0.toPhoto() }

                // Создаем Set из существующих id
                let existingIDs = Set(self?.photos.map { $0.id } ?? [])
                let uniqueNewPhotos = newPhotos.filter {
                    !existingIDs.contains($0.id)
                }

                DispatchQueue.main.async {
                    self?.photos.append(contentsOf: uniqueNewPhotos)
                    self?.lastLoadedPage = nextPage

                    NotificationCenter.default.post(
                        name: ImagesListService.didChangeNotification,
                        object: self)
                    
                    self?.currentTask = nil
                }

            } catch {
                print("[fetchPhotosNextPage] error decoding JSON: \(error)")
                return
            }

        }

        currentTask?.resume()
    }

    // Метод для добавления лайка
    func likePhoto(
        photoId: String, completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Отправляем POST-запрос на сервер
        guard
            let request = URLRequest.makeHTTPRequest(
                path: "/photos" + "/\(photoId)" + "/like",
                httpMethod: "POST",
                baseURLString: Constants.defaultBaseUrl.absoluteString)
        else {
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(
                    "[likePhoto] error \(error) adding like for photo \(photoId)"
                )
            } else {
                completion(.success(()))
                print("[likePhoto] like added for photo \(photoId)")
            }
        }.resume()
    }

    // Метод для удаления лайка
    func unlikePhoto(
        photoId: String, completion: @escaping (Result<Void, Error>) -> Void
    ) {
        // Отправляем DELETE-запрос на сервер
        guard
            let request = URLRequest.makeHTTPRequest(
                path: "/photos" + "/\(photoId)" + "/like",
                httpMethod: "DELETE",
                baseURLString: Constants.defaultBaseUrl.absoluteString)
        else {
            return
        }

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print(
                    "[likePhoto] like error \(error) deleted for photo \(photoId)"
                )
            } else {
                completion(.success(()))
                print("[likePhoto] like deleted for photo \(photoId)")
            }
        }.resume()

    }

    func clearData() {
        photos.removeAll()
    }
}

