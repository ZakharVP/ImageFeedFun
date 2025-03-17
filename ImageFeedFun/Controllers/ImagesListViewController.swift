//
//  ViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 26.08.2024.
//

import Kingfisher
import UIKit

final class ImagesListViewController: UIViewController {

    let showSingleImageSegueIdentifier = "ShowSingleImage"
    let currentDate = Date()
    lazy var dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()

    var photos: [Photo] = []
    var cellHeights: [IndexPath: CGFloat] = [:]

    @IBOutlet private var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        print("[ImageListViewController] viewDidLoad started")
        setupTableView()
        print("[ImageListViewController] setupTableView ended")
        setupNotificationObserver()
        print("[ImageListViewController] setupNotificationObserver ended")

    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showSingleImageSegueIdentifier {
            guard
                let viewController = segue.destination
                    as? SingleImageViewController,
                let indexPath = sender as? IndexPath
            else {
                assertionFailure("Invalid segue destination")
                return
            }

            let photo = photos[indexPath.row]
            let url = URL(string: photo.urls.full)
            viewController.imageURL = url

        } else {
            super.prepare(for: segue, sender: sender)
        }
    }

    func setupTableView() {
        tableView.contentInset = UIEdgeInsets(
            top: 12, left: 0, bottom: 12, right: 0)
        tableView.dataSource = self
        tableView.delegate = self
    }

    func setupNotificationObserver() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handlePhotosUpdate),
            name: ImagesListService.didChangeNotification,
            object: nil)
    }

    @objc private func handlePhotosUpdate() {
        if Thread.isMainThread {
            print("[handlePhotosUpdate] - on main thread")
        } else {
            print("[handlePhotosUpdate] - not on main thread")
        }
        DispatchQueue.main.async {
            self.updateTableViewAnimated()
        }

    }

    func updateTableViewAnimated() {
        if Thread.isMainThread {
            print("[updateTableViewAnimated] - on main thread")
        } else {
            print("[updateTableViewAnimated] - not on main thread")
        }
        let oldCount = photos.count
        let newCount = ImagesListService.shared.photos.count
        photos = ImagesListService.shared.photos
        if oldCount != newCount {
            tableView.performBatchUpdates {
                let indexPaths = (oldCount..<newCount).map { i in
                    IndexPath(row: i, section: 0)
                }
                tableView.insertRows(at: indexPaths, with: .automatic)
            } completion: { _ in
            }

        }
    }

}
