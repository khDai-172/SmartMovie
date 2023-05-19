//
//  SearchResultsViewController.swift
//  SmartMovie
//
//  Created by Khoa Dai on 04/04/2023.
//

import UIKit

class GenresMovieListViewController: UIViewController {

    public let genreMoviesTableview: UITableView = {
        let tableView = UITableView(frame: .zero)
        let genreMoviesTableId = "GenreMovieListTableCell"
        tableView.register(UINib(nibName: genreMoviesTableId, bundle: nil), forCellReuseIdentifier: genreMoviesTableId)
        return tableView
    }()
    private var moviePage: MovieDataBase?
    public var movieGenres: Genre?
    public var movieList: [MovieEntity]? = [MovieEntity]()
    private let serverCalling = ServerCalling()
    let genreCellId = "GenreMovieListTableCel"

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(genreMoviesTableview)
        title = movieGenres?.name
        setupGenreMovieTableView()
        fetchGenreMovieListData()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        genreMoviesTableview.frame = view.bounds
    }
}

extension GenresMovieListViewController {
    func setupGenreMovieTableView() {
        genreMoviesTableview.dataSource = self
        genreMoviesTableview.delegate = self
        genreMoviesTableview.register(UINib(nibName: genreCellId, bundle: nil), forCellReuseIdentifier: genreCellId)
    }
}

extension GenresMovieListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let genreMovieCell = tableView.dequeueReusableCell(withIdentifier: "GenreMovieListTableCell", for: indexPath) as? GenreMovieListTableCell,
              let moviesData = movieList?[indexPath.row]
        else {
            return UITableViewCell()
        }

        genreMovieCell.downloadImage(moviesData.posterPath ?? "")
        genreMovieCell.setupMovie(moviesData)
        return genreMovieCell
    }
}

extension GenresMovieListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 5.5 + 8
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailView") as? DetailView else {
            return
        }
        guard let movieDetail = movieList?[indexPath.row] else { return }
        detailVC.setupDetail(movieDetail)
        navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension GenresMovieListViewController {
    private func fetchGenreMovieListData() {
        guard let genreId = movieGenres?.id else { return }
        let url = "\(Constant.baseURL)discover/movie?api_key=\(Constant.APIKey)&with_genres=\(genreId)&page=1"
        serverCalling.fetchAPIFromURL(url) { [weak self] (data, error) in
            guard let self = self else {
                return
            }
            if let errorMessage = error {
                print(errorMessage)
                return
            }
            if let data = data {
                self.convertData(data)
            }
        }
    }
    private func convertData(_ data: String) {
        let responseData = Data(data.utf8)
        do {
            moviePage = try JSONDecoder().decode(MovieDataBase.self, from: responseData)
            DispatchQueue.main.async { [weak self] in
                let group = DispatchGroup()
                for index in 0..<(self?.moviePage?.results.count ?? 0) {
                    group.enter()
                    self?.serverCalling.fetchMovieDetails(movieId: self?.moviePage?.results[index].id ?? 0) { result in
                        switch result {
                        case .success(let movie):
                            self?.movieList?.append(movie)
                        case .failure(let error):
                            print("\(error)")
                        }
                        group.leave()
                    }
                }
                group.notify(queue: .main) {
                    self?.genreMoviesTableview.reloadData()
                }
            }
        } catch let error {
            print("Failed to decode JSON \(error)")
        }
    }
}
