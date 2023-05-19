//
//  PopularSectionCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 06/04/2023.
//

import UIKit

class PopularSectionCell: UICollectionViewCell {

    @IBOutlet weak var popularListCV: UICollectionView!
    public var popularMovies: [MovieEntity]?
    private let serverCalling = ServerCalling()
    let cellId: CellId = CellId()
    weak var navigation: UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
    }
}

extension PopularSectionCell {
    func setupCollectionView() {
        popularListCV.dataSource = self
        popularListCV.delegate = self
        popularListCV.register(UINib(nibName: cellId.headerCellId, bundle: nil),
                               forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                               withReuseIdentifier: cellId.headerCellId)
        popularListCV.register(UINib(nibName: cellId.gridCellId, bundle: nil),
                               forCellWithReuseIdentifier: cellId.gridCellId)
        popularListCV.register(UINib(nibName: cellId.listCellId, bundle: nil),
                               forCellWithReuseIdentifier: cellId.listCellId)
        popularListCV.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension PopularSectionCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return popularMovies?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId.listCellId,
                                                                for: indexPath) as? ListCell,
              let popularMovie = popularMovies?[indexPath.row]  else {
            return UICollectionViewCell()
        }
        listCell.backgroundColor = Color.whiteColor
        listCell.layer.cornerRadius = 10
        listCell.setupMovie(popularMovie)
        listCell.downloadImage(popularMovie.posterPath ?? "")
        return listCell
    }
}

extension PopularSectionCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
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
        guard let popularMovieData = popularMovies?[indexPath.item] else { return }
        detailVC.setupDetail(popularMovieData)
        navigation?.pushViewController(detailVC, animated: true)
    }
}
