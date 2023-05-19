//
//  DetailView.swift
//  SmartMovie
//
//  Created by Khoa Dai on 11/04/2023.
//

import UIKit
import Kingfisher

struct SectionModel {
    let title: String
    let cellType: CellType
}

enum CellType {
    case casting
    case similar
}

class DetailView: UIViewController {

    @IBOutlet weak var overviewView: UIView!
    @IBOutlet weak var detailTableView: UITableView!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var genresLabel: UILabel!
    @IBOutlet weak var starsRateImage: UIImageView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var languageLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var productionCountryLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var overviewContainer: UIView!
    @IBOutlet weak var overviewLabel: UILabel!

    private let castCellId = "CastTableCell"
    private let similarCellId = "SimilarMoviesTableCell"
    private let serverCalling = ServerCalling()
    private var movieDetail: MovieEntity?
    private var movieCast: Credits?
    private var similarMovie: MovieDataBase?
    private var similarMovieDetail: [MovieEntity]?
    private let section: [SectionModel] = [SectionModel(title: "Casting", cellType: .casting),
                                           SectionModel(title: "Similar Movie", cellType: .similar)]
    override func viewDidLoad() {
        super.viewDidLoad()
        setupDetailTable()
        fetchMovieCastData()
        fetchSimilarData()
        updataDetailData()
        view.backgroundColor = Color.mainTheme
        detailTableView.backgroundColor = Color.mainTheme
    }

    func setupDetail(_ data: MovieEntity) {
        movieDetail = data
    }

    @IBAction func pressMoreBtn(_ sender: Any) {
        
    }
    
    func retrieveImage(image: UIImage) {
        movieImage.image = image
    }

    func updataDetailData() {
        downloadImage(movieDetail?.posterPath ?? "")
        titleLabel.text = movieDetail?.originalTitle
        let score = String(format: "%.1f", movieDetail?.voteAverage ?? Double())
        scoreLabel.text = "\(score) / 10"
        releaseDateLabel.text = movieDetail?.releaseDate

        overviewLabel.text = movieDetail?.overview

        guard let runtime = movieDetail?.runtime else { return }
        let hour = runtime / 60
        let minutes = runtime % 60
        durationLabel.text = "\(hour)h, \(minutes)p"

        let rating = Int((movieDetail?.voteAverage ?? 1.0) / 2)
        switch rating {
        case 0..<1:
            starsRateImage.image = UIImage(named: "star0:5")
        case 1..<2:
            starsRateImage.image = UIImage(named: "star1:5")
        case 2..<3:
            starsRateImage.image = UIImage(named: "star2:5")
        case 3..<4:
            starsRateImage.image = UIImage(named: "star3:5")
        case 4..<5:
            starsRateImage.image = UIImage(named: "star4:5")
        case 5:
            starsRateImage.image = UIImage(named: "star5:5")
        default:
            break
        }

        if let productionCountry = movieDetail?.productionCountry {
            let countryName = productionCountry.map { country in
                guard let countryCode = country.iso31661 else { return "" }
                return countryCode.uppercased()
            }
            productionCountryLabel.text = countryName.first
        }

        if let language = movieDetail?.originalLanguage?.uppercased() {
            let locale = Locale(identifier: "en_US")
            guard let languageName = locale.localizedString(forLanguageCode: language) else { return }
            languageLabel.text = "Language: \(languageName)"
        }

        if let genres = movieDetail?.genres {
            let genreNames = genres.compactMap { $0.name }
            genresLabel.text = genreNames.joined(separator: " | ")
        } else {
            genresLabel.text = "Loading..."
        }
    }
}

extension DetailView {
    func setupDetailTable() {
        detailTableView.dataSource = self
        detailTableView.delegate = self
        detailTableView.register(UINib(nibName: castCellId, bundle: nil), forCellReuseIdentifier: castCellId)
        detailTableView.register(UINib(nibName: similarCellId, bundle: nil), forCellReuseIdentifier: similarCellId)
    }
}

extension DetailView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.section.count
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.section[section].cellType {
        case .casting:
            return 1
        case .similar:
            return similarMovie?.results.count ?? 0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let castCell = tableView.dequeueReusableCell(withIdentifier: castCellId) as? CastTableCell,
              let similarCell = tableView.dequeueReusableCell(withIdentifier: similarCellId) as? SimilarMoviesTableCell,
              let castList = movieCast?.cast,
              let similarList = similarMovieDetail?[indexPath.row]
        else {
            return UITableViewCell()
        }
        switch self.section[indexPath.section].cellType {
        case .casting:
            castCell.getCastData(movies: castList)
            return castCell
        case .similar:
            similarCell.backgroundColor = Color.mainTheme
            similarCell.setupSimilar(similarList)
            return similarCell
        }
    }
}

extension DetailView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch self.section[indexPath.section].cellType {
        case .casting:
            return 280
        case .similar:
            return 200
        }
    }
}

extension DetailView {
    func downloadImage(_ imageURL: String) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w200/\(imageURL)") else {
            return
        }
        serverCalling.downloadImageFromURL(url) { [weak self] (image, error) in
            guard let self = self else { return }
            if let image = image {
                DispatchQueue.main.async {
                    self.retrieveImage(image: image)
                }
            } else {
                movieImage.image = UIImage(named: "4k.tv")
                print(error ?? "Can not download thumbnail")
            }
        }
    }
}

extension DetailView {
    private func fetchMovieCastData() {
        guard let genreId = movieDetail?.id else { return }
        let url = "\(Constant.baseURL)movie/\(genreId)/credits?api_key=\(Constant.APIKey)"
        serverCalling.fetchAPIFromURL(url) { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            if let errorMessage = error {
                print(errorMessage)
                return
            }
            if let data = data {
                self.convertCastData(data)
            }
        }
    }
    private func convertCastData(_ data: String) {
        let responseData = Data(data.utf8)
        do {
            movieCast = try JSONDecoder().decode(Credits.self, from: responseData)
//            DispatchQueue.main.async { [weak self] in
//                self?.detailTableView.reloadData()
//            }
        } catch let error {
            print("Failed to decode JSON \(error)")
        }
    }

    private func fetchSimilarData() {
        guard let genreId = movieDetail?.id else { return }
        let url = "\(Constant.baseURL)movie/\(genreId)/similar?api_key=\(Constant.APIKey)&fbclid=\(Constant.castPath)"
        serverCalling.fetchAPIFromURL(url) { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            if let errorMessage = error {
                print(errorMessage)
                return
            }
            if let data = data {
                self.convertSimilarMovies(data)
            }
        }
    }
    private func convertSimilarMovies(_ data: String) {
        let responseData = Data(data.utf8)
        do {
            similarMovie = try JSONDecoder().decode(MovieDataBase.self, from: responseData)
            DispatchQueue.main.async { [weak self] in
                self?.similarMovieDetail = []
                let group = DispatchGroup()
                for index in 0..<(self?.similarMovie?.results.count ?? 0) {
                    group.enter()
                    self?.serverCalling.fetchMovieDetails(movieId: self?.similarMovie?.results[index].id ?? 0) { result in
                        print(self?.similarMovie?.results[index].id ?? 0)
                        switch result {
                        case .success(let movie):
                            self?.similarMovieDetail?.append(movie)
                        case .failure(let error):
                            print("\(error)")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self?.detailTableView.reloadData()
                }
            }
        } catch let error {
            print("Failed to decode JSON \(error)")
        }
    }
}
