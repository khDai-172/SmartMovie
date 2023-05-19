//
//  TopRatedSectionCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 06/04/2023.
//

import UIKit

class TopRatedSectionCell: UICollectionViewCell {

    @IBOutlet weak var topratedListCV: UICollectionView!
    let cellId: CellId = CellId()
    private let serverCalling = ServerCalling()
    public var topratedMovies: [MovieEntity]?
    weak var navigation: UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

}

extension TopRatedSectionCell {
    func setupCollectionView() {
        topratedListCV.dataSource = self
        topratedListCV.delegate = self
        topratedListCV.register(UINib(nibName: cellId.headerCellId, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: cellId.headerCellId)
        topratedListCV.register(UINib(nibName: cellId.gridCellId, bundle: nil),
                                forCellWithReuseIdentifier: cellId.gridCellId)
        topratedListCV.register(UINib(nibName: cellId.listCellId, bundle: nil),
                                forCellWithReuseIdentifier: cellId.listCellId)
        topratedListCV.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension TopRatedSectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return topratedMovies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId.listCellId,
                                                                for: indexPath) as? ListCell,
              let topratedMovie = topratedMovies?[indexPath.row] else {
            return UICollectionViewCell()
        }
        listCell.backgroundColor = Color.whiteColor
        listCell.layer.cornerRadius = 10
        listCell.setupMovie(topratedMovie)
        listCell.downloadImage(topratedMovie.posterPath ?? "")
        return listCell
    }
}

extension TopRatedSectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.frame.width - 8, height: 170)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 4
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main",
                                          bundle: nil).instantiateViewController(withIdentifier: "DetailView")
                as? DetailView else {
            return
        }
        guard let topratedMovieData = topratedMovies?[indexPath.item] else { return }
        detailVC.setupDetail(topratedMovieData)
        navigation?.pushViewController(detailVC, animated: true)
    }
}
