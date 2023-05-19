//
//  GenreMovieListTableCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 10/04/2023.
//

import UIKit

class GenreMovieListTableCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewLabel: UILabel!
    private let serverCalling = ServerCalling()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func prepareForReuse() {
           super.prepareForReuse()
           movieImage.image = nil
           titleLabel.text = nil
           releaseDateLabel.text = nil
           durationLabel.text = nil
           overviewLabel.text = nil
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
    }

    func retrieveImage(image: UIImage) {
        movieImage.image = image
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
                self.retrieveImage(image: UIImage(named: "pencil.and.outline") ?? UIImage())
                print(error ?? "Can not download thumbnail")
            }
        }
    }
}
