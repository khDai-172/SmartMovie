//
//  NowPlayingSectionCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 06/04/2023.
//

import UIKit

class NowPlayingSectionCell: UICollectionViewCell {

    @IBOutlet weak var nowPlayingListCV: UICollectionView!
    let cellId: CellId = CellId()
    private let serverCalling = ServerCalling()
    public var nowPlayingMovies: [MovieEntity]?
    weak var navigation: UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }

}

extension NowPlayingSectionCell {
    func setupCollectionView() {
        nowPlayingListCV.dataSource = self
        nowPlayingListCV.delegate = self
        nowPlayingListCV.register(UINib(nibName: cellId.headerCellId,
                                        bundle: nil),
                                  forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                  withReuseIdentifier: cellId.headerCellId)
        nowPlayingListCV.register(UINib(nibName: cellId.gridCellId, bundle: nil),
                                  forCellWithReuseIdentifier: cellId.gridCellId)
        nowPlayingListCV.register(UINib(nibName: cellId.listCellId, bundle: nil),
                                  forCellWithReuseIdentifier: cellId.listCellId)
        nowPlayingListCV.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension NowPlayingSectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return nowPlayingMovies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId.listCellId,
                                                                for: indexPath) as? ListCell,
              let nowPlayingMovie = nowPlayingMovies?[indexPath.row] else {
            return UICollectionViewCell()
        }
        listCell.backgroundColor = Color.whiteColor
        listCell.layer.cornerRadius = 10
        listCell.setupMovie(nowPlayingMovie)
        listCell.downloadImage(nowPlayingMovie.posterPath ?? "")
        return listCell
    }
}

extension NowPlayingSectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        guard let nowPlayingMovieData = nowPlayingMovies?[indexPath.item] else { return }
        detailVC.setupDetail(nowPlayingMovieData)
        navigation?.pushViewController(detailVC, animated: true)
    }
}
