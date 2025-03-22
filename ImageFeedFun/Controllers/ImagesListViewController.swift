//
//  ViewController.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 26.08.2024.
//

import Kingfisher
import UIKit

final class ImagesListViewController: UIViewController, ImagesListViewControllerProtocol {

    var showSingleImageSegueIdentifier: String { "ShowSingleImage" }
    lazy var dateFormatter: DateFormatter = {
           let formatter = DateFormatter()
           formatter.dateFormat = "dd MMMM yyyy"
           formatter.locale = Locale(identifier: "ru_RU")
           return formatter
       }()

    @IBOutlet private var tableView: UITableView!
    var presenter: ImagesListViewPresenterProtocol!

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter = ImagesListViewPresenter()
        presenter.view = self
        presenter.viewDidLoad()
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        presenter.prepareForSegue(segue: segue, sender: sender)
    }

    // MARK: - ImagesListViewControllerProtocol

    func performBatchUpdates(_ updates: @escaping () -> Void, completion: ((Bool) -> Void)?) {
        tableView.performBatchUpdates(updates, completion: completion)
    }

    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) {
        tableView.insertRows(at: indexPaths, with: animation)
    }

    func updateTableViewAnimated() {
        tableView.reloadData()
    }
}

