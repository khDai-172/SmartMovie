//
//  ListCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 30/03/2023.
//

import UIKit

class ListCell: UICollectionViewCell {

    @IBOutlet weak var favoriteBtn: UIButton!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    private let serverCalling = ServerCalling()
    override func awakeFromNib() {
        super.awakeFromNib()
        titleLabel.textColor = Color.blackColor
        overviewLabel.textColor = Color.blackColor
        durationLabel.textColor = Color.blackColor
        releaseDateLabel.textColor = Color.blackColor
        movieImage.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
           super.prepareForReuse()
           movieImage.image = UIImage(systemName: "pencil.and.outline")
           titleLabel.text = "Loading..."
           releaseDateLabel.text = "Loading..."
           durationLabel.text = "Loading..."
           overviewLabel.text = "Loading..."
    }

    func setupMovie(_ data: MovieEntity) {
        if data.originalTitle == nil {
            titleLabel.text = data.title
        } else {
            titleLabel.text = data.originalTitle
        }
        releaseDateLabel.text = data.releaseDate
        overviewLabel.text = data.overview
        guard let runtime = data.runtime else { return }
        let hour = runtime / 60
        let minutes = runtime % 60
        durationLabel.text = "\(hour)h, \(minutes)p"

        downloadImage(data.posterPath ?? "")
    }

    func retrieveImage(image: UIImage) {
        DispatchQueue.main.async {
            self.movieImage.image = image
        }
    }

    func downloadImage(_ imageURL: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(imageURL)") else {
            return
        }
        serverCalling.downloadImageFromURL(url) { [weak self] (image, error) in
            guard let self = self else { return }
            if let image = image {
                DispatchQueue.main.async {
                    self.retrieveImage(image: image)
                }
            } else {
                self.retrieveImage(image: UIImage(systemName: "pencil.and.outline") ?? UIImage())
                print(error ?? "Can not download thumbnail")
            }
        }
    }
}
