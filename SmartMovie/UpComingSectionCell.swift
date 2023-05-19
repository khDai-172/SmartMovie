//
//  UpComingSectionCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 06/04/2023.
//

import UIKit

class UpComingSectionCell: UICollectionViewCell {

    @IBOutlet weak var upComingListCV: UICollectionView!
    let cellId: CellId = CellId()
    private let serverCalling = ServerCalling()
    public var upcomingMovies: [MovieEntity]?
    weak var navigation: UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

}

extension UpComingSectionCell {
    func setupCollectionView() {
        upComingListCV.dataSource = self
        upComingListCV.delegate = self
        upComingListCV.register(UINib(nibName: cellId.headerCellId, bundle: nil),
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: cellId.headerCellId)
        upComingListCV.register(UINib(nibName: cellId.gridCellId, bundle: nil),
                                forCellWithReuseIdentifier: cellId.gridCellId)
        upComingListCV.register(UINib(nibName: cellId.listCellId, bundle: nil),
                                forCellWithReuseIdentifier: cellId.listCellId)
        upComingListCV.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension UpComingSectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return upcomingMovies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId.listCellId,
                                                                for: indexPath) as? ListCell,
              let upcomingMovie = upcomingMovies?[indexPath.row] else {
            return UICollectionViewCell()
        }
        listCell.backgroundColor = Color.whiteColor
        listCell.layer.cornerRadius = 10
        listCell.setupMovie(upcomingMovie)
        listCell.downloadImage(upcomingMovie.posterPath ?? "")
        return listCell
    }
}

extension UpComingSectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailView") as? DetailView else {
            return
        }
        guard let upcomingMovieData = upcomingMovies?[indexPath.item] else { return }
        detailVC.setupDetail(upcomingMovieData)
        navigation?.pushViewController(detailVC, animated: true)
    }
}
