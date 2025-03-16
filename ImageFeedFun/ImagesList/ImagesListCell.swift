//
//  ImagesListCell.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 01.09.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {

    private var isLiked: Bool = false
    private var currentImageURL: URL?

    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet private var contentCell: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateTextLabel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!

    var likeButtonTapped: ((Bool) -> Void)?
    var imageTapped: (() -> Void)?

    override func prepareForReuse() {
        super.prepareForReuse()
        imageLabel.kf.cancelDownloadTask()
        imageLabel.image = UIImage(named: "card_placeholder")
        currentImageURL = nil

        // Удаляем все распознаватели жестов
        imageLabel.gestureRecognizers?.forEach {
            imageLabel.removeGestureRecognizer($0)
        }
    }

    func configCell(with photo: Photo, dateFormatter: DateFormatter) {
        dateTextLabel.text = dateFormatter.string(
            from: photo.createdAt ?? Date())

        let placeholderImage = UIImage(named: "card_placeholder")
        imageLabel.image = placeholderImage

        // Добавляем обработчик нажатия на изображение
        let tapGestureRecognizer = UITapGestureRecognizer(
            target: self, action: #selector(handelImageTapped))
        imageLabel.isUserInteractionEnabled = true
        imageLabel.addGestureRecognizer(tapGestureRecognizer)

        if let thumbImageURL = photo.urls.thumb,
            let url = URL(string: thumbImageURL)
        {
            if currentImageURL != url {
                currentImageURL = url
                imageLabel.kf.setImage(
                    with: url, placeholder: placeholderImage,
                    options: [.transition(.fade(0.2))]
                ) { result in
                    switch result {
                    case .success(let value):
                        // Обновляем высоту ячейки после загрузки изображения
                        if let tableView = self.superview as? UITableView,
                            let indexPath = tableView.indexPath(for: self)
                        {
                            let image = value.image
                            let imageInsets = UIEdgeInsets(
                                top: 4, left: 16, bottom: 4, right: 16)
                            let imageViewWidth =
                                tableView.bounds.width - imageInsets.left
                                - imageInsets.right
                            let imageWidth = image.size.width
                            let scale = imageViewWidth / imageWidth
                            let cellHeight =
                                image.size.height * scale + imageInsets.top
                                + imageInsets.bottom

                            // Сохраняем высоту ячейки в кэше
                            (tableView.delegate as? ImagesListViewController)?
                                .cellHeights[indexPath] = cellHeight

                            // Обновляем высоту ячейки
                            tableView.beginUpdates()
                            tableView.endUpdates()
                        }
                    case .failure(let error):
                        print("Ошибка загрузки изображения: \(error)")
                    }
                }
            }
        } else {
            print("[configCell] No image URL provided [thumbImageURL]")
            imageLabel.image = placeholderImage
        }
        isLiked = photo.likedByUser
        print("[configCell] isLiked: \(isLiked)")
        updateLikeButton()
    }

    @objc private func handelImageTapped() {
        print("[handleImageTapped] press the image")  // Выводим сообщение в консоль
        imageTapped?()  // Вызываем замыкание, если оно установлено
    }

    private func updateLikeButton() {
        let likeImage =
            isLiked ? UIImage(named: "Favorite") : UIImage(named: "noActive")
        likeButton.setImage(likeImage, for: .normal)
    }

    @IBAction private func likeButtonClicked(_ sender: UIButton) {
        isLiked.toggle()
        updateLikeButton()
        likeButtonTapped?(isLiked)  // Вызываем замыкание
    }

}
