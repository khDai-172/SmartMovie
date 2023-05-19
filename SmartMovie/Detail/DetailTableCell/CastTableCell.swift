//
//  CastTableCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 12/04/2023.
//

import UIKit

class CastTableCell: UITableViewCell {

    @IBOutlet weak var castCollectionView: UICollectionView!
    private var casts: [Cast]?
    let layout = UICollectionViewFlowLayout()
    override func awakeFromNib() {
        super.awakeFromNib()
        castCollectionView.backgroundColor = Color.mainTheme
        castCollectionView.backgroundColor?.withAlphaComponent(0.5)
        setupCastCollection()
    }

    func getCastData(movies: [Cast]) {
        casts = movies
        castCollectionView.reloadData()
    }
}

extension CastTableCell {
    func setupCastCollection() {
        castCollectionView.dataSource = self
        castCollectionView.delegate = self
        castCollectionView.register(UINib(nibName: "CastsCollectionCell", bundle: nil), forCellWithReuseIdentifier: "CastsCollectionCell")
        castCollectionView.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
    }
}

extension CastTableCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return casts?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let castCell = collectionView.dequeueReusableCell(withReuseIdentifier: "CastsCollectionCell", for: indexPath) as? CastsCollectionCell,
              let castList = casts?[indexPath.row] else {
            return UICollectionViewCell()
        }
        castCell.setupMovieCast(castList)
        return castCell
    }
}

extension CastTableCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.bounds.width / 4, height: self.bounds.height / 2 - 6)
    }
}
