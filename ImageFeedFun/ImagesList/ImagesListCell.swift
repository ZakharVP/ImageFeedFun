//
//  ImagesListCell.swift
//  ImageFeedFun
//
//  Created by Захар Панченко on 01.09.2024.
//

import UIKit

final class ImagesListCell: UITableViewCell {
    
    static let reuseIdentifier = "ImagesListCell"
    @IBOutlet private var contentCell: UIView!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var dateTextLAbel: UILabel!
    @IBOutlet weak var imageLabel: UIImageView!
}
