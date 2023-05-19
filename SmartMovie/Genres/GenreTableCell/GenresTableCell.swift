//
//  GenresTableCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 09/04/2023.
//

import UIKit

class GenresTableCell: UITableViewCell {

    @IBOutlet weak var genreImage: UIImageView!
    @IBOutlet weak var genreLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func setupGenre(_ data: Genre) {
        genreLabel.text = data.name
    }

}
