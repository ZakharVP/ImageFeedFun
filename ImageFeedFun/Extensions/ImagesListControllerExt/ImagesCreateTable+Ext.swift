//
//  ImagesCreateTable+Ext.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.03.2025.
//
// Здесь создаем таблицу и задаем базовые настройки

import UIKit

extension ImagesListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int)
        -> Int
    {
        return presenter.photos.count  
    }

    func tableView(
        _ tableView: UITableView, heightForRowAt indexPath: IndexPath
    ) -> CGFloat {
        if let height = presenter.cellHeights[indexPath] {
            return height
        }
        return 200
    }

    func tableView(
        _ tableView: UITableView, didSelectRowAt indexPath: IndexPath
    ) {
        performSegue(
            withIdentifier: showSingleImageSegueIdentifier, sender: indexPath)
    }

    func tableView(
        _ tableView: UITableView, willDisplay cell: UITableViewCell,
        forRowAt indexPath: IndexPath
    ) {
        if indexPath.row == presenter.photos.count - 1 {
            presenter.fetchPhotosNextPage { result in
                  switch result {
                  case .success:
                      print("Successfully fetched new photos")
                  case .failure(let error):
                      print("Failed to fetch photos: \(error)")
                  }
              }
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath)
        -> UITableViewCell
    {

        guard
            let imageListCell = tableView.dequeueReusableCell(
                withIdentifier: ImagesListCell.reuseIdentifier,
                for: indexPath
            ) as? ImagesListCell
        else {
            return UITableViewCell()
        }

        let photo = presenter.photos[indexPath.row]
        imageListCell.configCell(with: photo, dateFormatter: dateFormatter)
        imageListCell.likeButtonTapped = { [weak self] isLiked in
            guard let self = self else { return }
            self.toggleLike(for: photo, at: indexPath, isLiked: isLiked)
        }
        imageListCell.imageTapped = { [weak self] in
            guard let self = self else { return }
            self.performSegue(withIdentifier: self.showSingleImageSegueIdentifier, sender: indexPath)
        }
        return imageListCell
    }

    // Метод для обработки лайка
    func toggleLike(for photo: Photo, at indexPath: IndexPath, isLiked: Bool) {
        // Отправляем запрос на сервер
        print("[toggleLike] the button like is clicked")
        UIBlockingProgressHUD.show()
        if isLiked {
            // Отправляем POST-запрос для добавления лайка
            ImagesListService.shared.likePhoto(photoId: photo.id) { result in
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    switch result {
                    case .success:
                        print("Лайк успешно добавлен")
                        self.presenter.photos[indexPath.row].isLiked = true
                    case .failure(let error):
                        print("Ошибка при добавлении лайка: \(error)")
                    }
                }
            }

        } else {
            // Отправляем DELETE-запрос для удаления лайка
            ImagesListService.shared.unlikePhoto(photoId: photo.id) { result in
                DispatchQueue.main.async {
                    UIBlockingProgressHUD.dismiss()
                    switch result {
                    case .success:
                        print("Лайк успешно удален")
                        self.presenter.photos[indexPath.row].isLiked = false
                    case .failure(let error):
                        print("Ошибка при удалении лайка: \(error)")
                    }
                }
            }
        }
    }
}

extension ImagesListService: ImagesListServiceProtocol {}
