//
//  CastsCollectionCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 12/04/2023.
//

import UIKit

class CastsCollectionCell: UICollectionViewCell {

    @IBOutlet weak var castImage: UIImageView!
    @IBOutlet weak var castNameLabel: UILabel!

    private let serverCalling = ServerCalling()
    override func awakeFromNib() {
        super.awakeFromNib()
        castImage.layer.cornerRadius = 10
    }

    override func prepareForReuse() {
           super.prepareForReuse()
           castImage.image = UIImage(named: "person.fill")
           castNameLabel.text = "Loading..."
    }

    func setupMovieCast(_ data: Cast) {
        castNameLabel.text = data.name
        downloadImage(data.profilePath ?? "")
    }

    func retrieveImage(image: UIImage) {
        DispatchQueue.main.async {
            self.castImage.image = image
        }
    }

    func downloadImage(_ imageURL: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w300/\(imageURL)") else {
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
