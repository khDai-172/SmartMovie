//
//  SimilarMoviesTableCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 12/04/2023.
//

import UIKit

class SimilarMoviesTableCell: UITableViewCell {

    @IBOutlet weak var wrapperView: UIView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var ratingImage: UIImageView!
    
    private let serverCalling = ServerCalling()
    override func awakeFromNib() {
        super.awakeFromNib()
        wrapperView.layer.cornerRadius = 10
        wrapperView.backgroundColor = Color.whiteColor
    }
    
    func setupSimilar(_ data: MovieEntity) {
        if data.originalTitle == nil {
            nameLabel.text = data.title
        } else {
            nameLabel.text = data.originalTitle
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
        if let genres = data.genres {
            let genreNames = genres.compactMap { $0.name }
            self.genresLabel.text = genreNames.joined(separator: " | ")
        } else {
            self.genresLabel.text = "Loading..."
        }
        
        downloadImage(data.backdropPath ?? "")
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
                self.retrieveImage(image: UIImage(named: "person.fill") ?? UIImage())
                print(error ?? "Can not download thumbnail")
            }
        }
    }
}
