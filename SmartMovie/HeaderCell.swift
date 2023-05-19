//
//  HeaderCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 30/03/2023.
//

import UIKit

class HeaderCell: UICollectionViewCell {

    @IBOutlet weak var showAllBtn: UIButton!
    @IBOutlet weak var headerLabel: UILabel!
    var section = 0
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBAction func pressShowAll(_ sender: Any) {

    }
}
