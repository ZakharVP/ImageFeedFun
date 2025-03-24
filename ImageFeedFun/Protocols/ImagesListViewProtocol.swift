//
//  ImagesListViewProtocol.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 22.03.2025.
//
import UIKit

protocol ImagesListViewPresenterProtocol: AnyObject {
    var view: ImagesListViewControllerProtocol? { get set }
    var photos: [Photo] { get set}
    var cellHeights: [IndexPath: CGFloat] { get set}
    func viewDidLoad()
    func fetchPhotosNextPage(completion: @escaping (Result<Void, Error>) -> Void)
    func updateTableViewAnimated()
    func prepareForSegue(segue: UIStoryboardSegue, sender: Any?)
}

protocol ImagesListViewControllerProtocol: AnyObject {
    var showSingleImageSegueIdentifier: String { get }
    func performBatchUpdates(_ updates: @escaping () -> Void, completion: ((Bool) -> Void)?)
    func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation)
    func updateTableViewAnimated()
}

protocol ImagesListServiceProtocol {
    var photos: [Photo] { get }
    func fetchPhotosNextPage(completion: @escaping (Result<[Photo], Error>) -> Void)
}
