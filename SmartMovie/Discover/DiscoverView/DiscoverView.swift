//
//  ViewController.swift
//  SmartMovie
//
//  Created by KhanhVD1.APL on 3/28/23.
//

import UIKit

class DiscoverView: UIViewController {
    let containerCellId: [String] = [
        "AllMovieCell", "PopularSectionCell", "TopRatedSectionCell", "UpComingSectionCell", "NowPlayingSectionCell"
    ]
    @IBOutlet weak var viewChangeBarBtn: UIBarButtonItem!
    @IBOutlet weak var categorySView: UIStackView!
    @IBOutlet weak var movieBtn: UIButton!
    @IBOutlet weak var popularBtn: UIButton!
    @IBOutlet weak var topratedBtn: UIButton!
    @IBOutlet weak var nowPlayingBtn: UIButton!
    @IBOutlet weak var upcomingBtn: UIButton!
    @IBOutlet weak var containerCV: UICollectionView!

    public let underlineView = UIView()
    private var popularMovies: [MovieEntity]? = [MovieEntity]()
    private var topratedMovies: [MovieEntity]? = [MovieEntity]()
    private var upcomingMovies: [MovieEntity]? = [MovieEntity]()
    private var nowPlayingMovies: [MovieEntity]? = [MovieEntity]()
    let layout = UICollectionViewFlowLayout()
    private let serverCalling = ServerCalling()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCollectionView()
        setupUI()
        fetchPopularData()
        fetchTopratedData()
        fetchUpcomingData()
        fetchNowplayingData()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    @IBAction func pressChangeView(_ sender: UIButton) {
        var viewChanged = Constant.isViewChanged
        if viewChanged == false {
            viewChanged = true
            viewChangeBarBtn.image = UIImage(systemName: "rectangle.grid.1x2")
        } else {
            viewChanged = false
            viewChangeBarBtn.image = UIImage(systemName: "square.grid.2x2")
        }
        Constant.isViewChanged = viewChanged
        let keyDiction: [AnyHashable: Bool] = ["viewChanged": viewChanged]
        NotificationCenter.default.post(name: Notification.Name("ViewChanged"), object: nil, userInfo: keyDiction)
    }

    func setupUI() {
        view.backgroundColor = Color.mainTheme
        containerCV.backgroundColor = Color.mainTheme
        navigationItem.title = "Smart Movie"
        underlineView.backgroundColor = Color.whiteColor
        underlineView.layer.borderColor = UIColor.white.cgColor
        underlineView.layer.cornerRadius = 3
        underlineView.layer.borderWidth = 0.5
        categorySView.addSubview(underlineView)
        view.bringSubviewToFront(underlineView)
        underlineView.frame = CGRect(x: 0, y: self.categorySView.frame.height - 2,
                                     width: movieBtn.frame.width, height: 10)
        categorySView.backgroundColor = Color.mainTheme
    }

    @IBAction func pressCategoryBtn(_ sender: UIButton) {
        guard let btnName = sender.titleLabel?.text else { return }
        switch btnName {
        case "Movie":
            scrollToIndex(index: 0)
            movieBtnPressed()
        case "Popular":
            scrollToIndex(index: 1)
            popularBtnPressed()
        case "Top Rated":
            scrollToIndex(index: 2)
            topratedBtnPressed()
        case "Up Coming":
            scrollToIndex(index: 3)
            upcomingBtnPressed()
        case "Now Playing":
            scrollToIndex(index: 4)
            nowPlayingBtnPressed()
        default: break
        }
    }

    func scrollToIndex(index: Int) {
        guard let rect = containerCV.layoutAttributesForItem(
            at: IndexPath(row: index, section: 0))?.frame else {
            return
        }
        containerCV.scrollRectToVisible(rect, animated: true)
    }
}

extension DiscoverView {
    func movieBtnPressed() {
        animateUnderlineView(xPoint: 0, widthSize: movieBtn.frame.width)
    }

    func popularBtnPressed() {
        animateUnderlineView(xPoint: movieBtn.frame.width, widthSize: popularBtn.frame.width)
    }

    func topratedBtnPressed() {
        animateUnderlineView(xPoint: movieBtn.frame.width + popularBtn.frame.width, widthSize: topratedBtn.frame.width)
    }

    func upcomingBtnPressed() {
        animateUnderlineView(xPoint: movieBtn.frame.width + popularBtn.frame.width + topratedBtn.frame.width,
                             widthSize: upcomingBtn.frame.width)
    }

    func nowPlayingBtnPressed() {
        animateUnderlineView(xPoint: movieBtn.frame.width + popularBtn.frame.width
                             + topratedBtn.frame.width + upcomingBtn.frame.width,
                             widthSize: nowPlayingBtn.frame.width)
    }

    func animateUnderlineView(xPoint: CGFloat, widthSize: CGFloat) {
        UIView.animate(withDuration: 0.13, delay: 0.0, options: .curveLinear, animations: {
            self.underlineView.frame = CGRect(x: xPoint, y: self.categorySView.frame.height - 2,
                                              width: widthSize, height: 10)
        })
    }
}

extension DiscoverView {
    private func setupCollectionView() {
        containerCV.collectionViewLayout = layout
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        containerCV.dataSource = self
        containerCV.delegate = self
        containerCV.register(UINib(nibName: containerCellId[0], bundle: nil),
                             forCellWithReuseIdentifier: containerCellId[0])
        containerCV.register(UINib(nibName: containerCellId[1], bundle: nil),
                             forCellWithReuseIdentifier: containerCellId[1])
        containerCV.register(UINib(nibName: containerCellId[2], bundle: nil),
                             forCellWithReuseIdentifier: containerCellId[2])
        containerCV.register(UINib(nibName: containerCellId[3], bundle: nil),
                             forCellWithReuseIdentifier: containerCellId[3])
        containerCV.register(UINib(nibName: containerCellId[4], bundle: nil),
                             forCellWithReuseIdentifier: containerCellId[4])
        containerCV.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: -5, bottom: 0, right: 0)
    }
}

extension DiscoverView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return containerCellId.count
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let allMovieCell = collectionView.dequeueReusableCell(
            withReuseIdentifier: containerCellId[0], for: indexPath) as? AllMovieCell,
              let popularSectionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: containerCellId[1], for: indexPath) as? PopularSectionCell,
              let topratedSectionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: containerCellId[2], for: indexPath) as? TopRatedSectionCell,
              let upcomingSectionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: containerCellId[3], for: indexPath) as? UpComingSectionCell,
              let nowPlayingSectionCell = collectionView.dequeueReusableCell(
                withReuseIdentifier: containerCellId[4], for: indexPath) as? NowPlayingSectionCell,
              let popularData = popularMovies,
              let topratedData = topratedMovies,
              let upcomingData = upcomingMovies,
              let nowPlayingData = nowPlayingMovies
        else {
            return UICollectionViewCell()
        }
        switch indexPath.item {
        case 0:
            allMovieCell.backgroundColor = Color.mainTheme
            if popularData.count >= 4 {
                let popular: [MovieEntity] = Array(popularData.prefix(4))
                allMovieCell.setupCell(movies: popular)
                allMovieCell.navigation = self.navigationController
            }
            if topratedData.count >= 4 {
                let toprated: [MovieEntity] = Array(topratedData.prefix(4))
                allMovieCell.setupToprated(movies: toprated)
                allMovieCell.navigation = self.navigationController
            }
            if upcomingData.count >= 4 {
                let upcoming: [MovieEntity] = Array(upcomingData.prefix(4))
                allMovieCell.setupUpcoming(movies: upcoming)
                allMovieCell.navigation = self.navigationController
            }
            if nowPlayingData.count >= 4 {
                let nowPlaying: [MovieEntity] = Array(nowPlayingData.prefix(4))
                allMovieCell.setupNowPlaying(movies: nowPlaying)
                allMovieCell.navigation = self.navigationController
            }
            return allMovieCell
        case 1:
            popularSectionCell.popularMovies = popularData
            popularSectionCell.navigation = self.navigationController
            return popularSectionCell
        case 2:
            topratedSectionCell.topratedMovies = topratedData
            topratedSectionCell.navigation = self.navigationController
            return topratedSectionCell
        case 3:
            upcomingSectionCell.upcomingMovies = upcomingData
            upcomingSectionCell.navigation = self.navigationController
            return upcomingSectionCell
        case 4:
            nowPlayingSectionCell.nowPlayingMovies = nowPlayingData
            nowPlayingSectionCell.navigation = self.navigationController
            return nowPlayingSectionCell
        default:
            break
        }
        return UICollectionViewCell()
    }
}
extension DiscoverView: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - 130)
    }
}

extension DiscoverView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetX = scrollView.contentOffset.x
        let contentWidth = scrollView.contentSize.width
        let scrollViewWidth = scrollView.frame.width
        switch offsetX {
        case 0:
            animateUnderlineView(xPoint: offsetX, widthSize: movieBtn.frame.width)

        case 0...contentWidth - (scrollViewWidth * 4):
            animateUnderlineView(xPoint: offsetX / 5, widthSize: popularBtn.frame.width)

        case contentWidth - (scrollViewWidth * 4)...contentWidth - (scrollViewWidth * 3):
            animateUnderlineView(xPoint: offsetX / 5, widthSize: topratedBtn.frame.width)

        case contentWidth - (scrollViewWidth * 3)...contentWidth - (scrollViewWidth * 2):
            animateUnderlineView(xPoint: offsetX / 5, widthSize: upcomingBtn.frame.width)

        case contentWidth - (scrollViewWidth * 2)...contentWidth - scrollViewWidth:
            animateUnderlineView(xPoint: offsetX / 5, widthSize: nowPlayingBtn.frame.width)
        default: break
        }
    }
}

extension DiscoverView {
    func fetchPopularData() {
        serverCalling.fetchPopularMovie(currentPage: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let popularMovies):
                    let group = DispatchGroup()
                    for index in 0..<popularMovies.count {
                        group.enter()
                        self.serverCalling.fetchMovieDetails(movieId: popularMovies[index].id ?? 0) { result in
                            switch result {
                            case .success(let movie):
                                self.popularMovies?.append(movie)
                            case .failure(let error):
                                print("\(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        self.containerCV.reloadData()
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    func fetchTopratedData() {
        serverCalling.fetchTopratedMovie(currentPage: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let topratedMovies):
                    let group = DispatchGroup()
                    for index in 0..<topratedMovies.count {
                        group.enter()
                        self.serverCalling.fetchMovieDetails(movieId: topratedMovies[index].id ?? 0) { result in
                            switch result {
                            case .success(let movie):
                                self.topratedMovies?.append(movie)
                            case .failure(let error):
                                print("\(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        self.containerCV.reloadData()
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    func fetchUpcomingData() {
        serverCalling.fetchUpcomingMovie(currentPage: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let upcomingMovies):
                    let group = DispatchGroup()
                    for index in 0..<upcomingMovies.count {
                        group.enter()
                        self.serverCalling.fetchMovieDetails(movieId: upcomingMovies[index].id ?? 0) { result in
                            switch result {
                            case .success(let movie):
                                self.upcomingMovies?.append(movie)
                            case .failure(let error):
                                print("\(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        self.containerCV.reloadData()
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }

    func fetchNowplayingData() {
        serverCalling.fetchNowplayingMovie(currentPage: 1) { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let nowPlayingMovies):
                    let group = DispatchGroup()
                    for index in 0..<nowPlayingMovies.count {
                        group.enter()
                        self.serverCalling.fetchMovieDetails(movieId: nowPlayingMovies[index].id ?? 0) { result in
                            switch result {
                            case .success(let movie):
                                self.nowPlayingMovies?.append(movie)
                            case .failure(let error):
                                print("\(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        self.containerCV.reloadData()
                    }
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
}
