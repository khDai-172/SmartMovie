//
//  ContainerCell.swift
//  SmartMovie
//
//  Created by Khoa Dai on 30/03/2023.
//

import UIKit

struct CellId {
    let headerCellId = "HeaderCell"
    let gridCellId = "GridCell"
    let listCellId = "ListCell"
}
enum Sections: Int {
    case popular = 0
    case topRated = 1
    case upcoming = 2
    case nowPlaying = 3
}

class AllMovieCell: UICollectionViewCell {

    @IBOutlet weak var movieListCV: UICollectionView!
    private let cellId: CellId = CellId()
    var isDataLoaded = false
    private var popularMovies: [MovieEntity]?
    private var topratedMovies: [MovieEntity]?
    private var upcomingMovies: [MovieEntity]?
    private var nowPlayingMovies: [MovieEntity]?
    let categoryList: [String] = ["Popular", "Top Rated", "Up coming", "Now Playing"]
    private let serverCalling = ServerCalling()
    weak var navigation: UINavigationController?
    override func awakeFromNib() {
        super.awakeFromNib()
        setupCollectionView()
        movieListCV.backgroundColor = Color.mainTheme
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(viewChanged(_:)),
                                               name: Notification.Name("ViewChanged"), object: nil)
    }

    @objc func viewChanged(_ notification: Notification) {
        if let userInfo = notification.userInfo as? [String: Any],
            let viewChanged = userInfo["viewChanged"] as? Bool {
            Constant.isViewChanged = viewChanged
            movieListCV.reloadData()
        }
    }

    func setupCell(movies: [MovieEntity]) {
        popularMovies = movies
        movieListCV.reloadData()
    }

    func setupToprated(movies: [MovieEntity]) {
        topratedMovies = movies
        movieListCV.reloadData()
    }

    func setupUpcoming(movies: [MovieEntity]) {
        upcomingMovies = movies
        movieListCV.reloadData()
    }

    func setupNowPlaying(movies: [MovieEntity]) {
        nowPlayingMovies = movies
        movieListCV.reloadData()
    }
}

extension AllMovieCell {
    func setupCollectionView() {
        movieListCV.dataSource = self
        movieListCV.delegate = self
        movieListCV.register(UINib(nibName: cellId.gridCellId,
                                   bundle: nil), forCellWithReuseIdentifier: cellId.gridCellId)
        movieListCV.register(UINib(nibName: cellId.listCellId,
                                   bundle: nil), forCellWithReuseIdentifier: cellId.listCellId)
        movieListCV.register(UINib(nibName: cellId.headerCellId,
                                   bundle: nil),
                             forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                             withReuseIdentifier: cellId.headerCellId)
        movieListCV.collectionViewLayout = UICollectionViewFlowLayout()
    }
}

extension AllMovieCell: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        var count: Int = 0
        if popularMovies?.isEmpty == false {
            count += 1
        }
        if topratedMovies?.isEmpty == false {
            count += 1
        }
        if upcomingMovies?.isEmpty == false {
            count += 1
        }
        if nowPlayingMovies?.isEmpty == false {
            count += 1
        }
        return count
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch section {
        case Sections.popular.rawValue:
            return popularMovies?.count ?? 0
        case Sections.topRated.rawValue:
            return topratedMovies?.count ?? 0
        case Sections.upcoming.rawValue:
            return upcomingMovies?.count ?? 0
        case Sections.nowPlaying.rawValue:
            return nowPlayingMovies?.count ?? 0
        default:
            return 0
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {
        guard let headerCell = collectionView.dequeueReusableSupplementaryView(
            ofKind: UICollectionView.elementKindSectionHeader,
            withReuseIdentifier: cellId.headerCellId, for: indexPath) as? HeaderCell else {
            return UICollectionReusableView()
        }
        let headerData = categoryList[indexPath.section]
        headerCell.backgroundColor = Color.mainTheme
        headerCell.headerLabel.text = headerData
        headerCell.headerLabel.textColor = Color.blackColor
        return headerCell
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let listCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: cellId.listCellId, for: indexPath) as? ListCell,
              let popularMovieData = popularMovies?[indexPath.item]
        else {
            return UICollectionViewCell()
        }
        listCell.backgroundColor = Color.whiteColor
        listCell.layer.cornerRadius = 10
        switch indexPath.section {
        case Sections.popular.rawValue:
            listCell.setupMovie(popularMovieData)
        case Sections.topRated.rawValue:
            guard let topratedMovieData = topratedMovies?[indexPath.item] else { return UICollectionViewCell() }
            listCell.setupMovie(topratedMovieData)

        case Sections.upcoming.rawValue:
            guard let upcomingMovieData = upcomingMovies?[indexPath.item] else { return UICollectionViewCell() }
            listCell.setupMovie(upcomingMovieData)

        case Sections.nowPlaying.rawValue:
            guard let nowPlayingMovieData = nowPlayingMovies?[indexPath.item] else { return UICollectionViewCell() }
            listCell.setupMovie(nowPlayingMovieData)

        default:
            break
        }
        return listCell
    }
}

extension AllMovieCell: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 20, height: 56)
    }

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 8, height: 170)
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
        switch indexPath.section {
        case Sections.popular.rawValue:
            guard let popularMovieData = popularMovies?[indexPath.item] else { return }
            detailVC.setupDetail(popularMovieData)
            navigation?.pushViewController(detailVC, animated: true)
        case Sections.topRated.rawValue:
            guard let topratedMovieData = topratedMovies?[indexPath.item] else { return }
            detailVC.setupDetail(topratedMovieData)
            navigation?.pushViewController(detailVC, animated: true)
        case Sections.upcoming.rawValue:
            guard let upcomingMovieData = upcomingMovies?[indexPath.item] else { return }
            detailVC.setupDetail(upcomingMovieData)
            navigation?.pushViewController(detailVC, animated: true)
        case Sections.nowPlaying.rawValue:
            guard let nowPlayingMovieData = nowPlayingMovies?[indexPath.item] else { return }
            detailVC.setupDetail(nowPlayingMovieData)
            navigation?.pushViewController(detailVC, animated: true)
        default:
            break
        }
    }
}
