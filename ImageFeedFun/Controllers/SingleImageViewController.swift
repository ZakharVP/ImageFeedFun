//
//  SingleImageViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 08.09.2024.
//

import Kingfisher
import UIKit

final class SingleImageViewController: UIViewController {

    @IBOutlet private var scrollView: UIScrollView!
    @IBOutlet private var imageView: UIImageView!
    @IBAction private func didTapBackButton() {
        dismiss(animated: true, completion: nil)
    }
    @IBAction private func didTapShareButton(_ sender: UIButton) {
        guard let imageURL else { return }
        let share = UIActivityViewController(
            activityItems: [imageURL],
            applicationActivities: nil
        )
        present(share, animated: true, completion: nil)
    }

    var imageURL: URL? {
        didSet {
            print(
                "[SingleImageViewController] imageURL установлен: \(imageURL?.absoluteString ?? "nil")"
            )
            if isViewLoaded {
                loadImage()
            }

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        print("[SingleImageViewController] viewDidLoad")

        // Настройка scrollView
        scrollView.minimumZoomScale = 0.1
        scrollView.maximumZoomScale = 3.0
        scrollView.delegate = self
        
        configScrollView()

        // Настройка imageView
        imageView.contentMode = .scaleAspectFit

        loadImage()

    }
    
    private func configScrollView() {
          scrollView.contentInsetAdjustmentBehavior = .never
          imageView.translatesAutoresizingMaskIntoConstraints = false
          NSLayoutConstraint.activate([
              scrollView.topAnchor.constraint(equalTo: view.topAnchor),
              scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
              scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
              scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
          ])
          
          NSLayoutConstraint.activate([
              imageView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
              imageView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
              imageView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
              imageView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor)
          ])
      }

    private func loadImage() {
        DispatchQueue.main.async {
               UIBlockingProgressHUD.show()
        }

        guard let imageURL = imageURL else {
            imageView.image = nil
            UIBlockingProgressHUD.dismiss()
            return
        }

        DispatchQueue.main.async {
            self.imageView.kf.setImage(with: imageURL) { [weak self] result in
                UIBlockingProgressHUD.dismiss()
                switch result {
                case .success(let value):
                    print("[loadImage] Image loaded successfully:")
                self?.rescaleAndCenterImageInScrollView(image: value.image)
                case .failure(let error):
                    print(
                        "[loadImage] Failed to load image: \(error.localizedDescription)"
                    )
                }
            }
        }
    }

    private func rescaleAndCenterImageInScrollView(image: UIImage) {
        guard !image.size.width.isZero && !image.size.height.isZero else {
            print("Ошибка: Размер изображения равен нулю")
            return
        }

        // Рассчитываем масштаб
        let minZoomScale = scrollView.minimumZoomScale
        let maxZoomScale = scrollView.maximumZoomScale
        let visibleRectSize = scrollView.bounds.size
        let imageSize = image.size

        let hScale = visibleRectSize.width / imageSize.width
        let vScale = visibleRectSize.height / imageSize.height
        let scale = min(maxZoomScale, max(minZoomScale, max(hScale, vScale)))

        // Устанавливаем масштаб
        scrollView.setZoomScale(scale, animated: false)
        scrollView.layoutIfNeeded()

        // Центрируем изображение
        let newContentSize = scrollView.contentSize
        let x = (newContentSize.width - visibleRectSize.width) / 2
        let y = (newContentSize.height - visibleRectSize.height) / 2
        scrollView.setContentOffset(CGPoint(x: x, y: y), animated: false)
    }
}

extension SingleImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}
