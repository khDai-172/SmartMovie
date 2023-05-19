//
//  ResultTableCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 04/04/2023.
//

import UIKit

class ResultTableCell: UITableViewCell {

    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    private var movieData: MovieEntity?
    private var serverCalling = ServerCalling()
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func getMovieResult(_ data: MovieEntity) {
        if data.originalTitle == nil {
            titleLabel.text = data.title
        } else {
            titleLabel.text = data.originalTitle
        }
        let rating = Int((data.voteAverage ?? 1.0) / 2)
        switch rating {
        case 0..<1:
            ratingImage.image = UIImage(named: "star0:5")
        case 1..<2:
            ratingImage.image = UIImage(named: "star1:5")
        case 2..<3:
            ratingImage.image = UIImage(named: "star2:5")
        case 3..<4:
            ratingImage.image = UIImage(named: "star3:5")
        case 4..<5:
            ratingImage.image = UIImage(named: "star4:5")
        case 5:
            ratingImage.image = UIImage(named: "star5:5")
        default:
            break
        }
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
                print(error ?? "Can not download thumbnail")
            }
        }
    }
}
