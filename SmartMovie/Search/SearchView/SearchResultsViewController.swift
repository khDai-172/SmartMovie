//
//  SearchResultsViewController.swift
//  SmartMovie
//
//  Created by Khoa Dai on 04/04/2023.
//

import UIKit

class SearchResultsViewController: UIViewController {

    public let searchResultTableview: UITableView = {
        let tableView = UITableView(frame: .zero)
        let searchTableId = "ResultTableCell"
        tableView.register(UINib(nibName: searchTableId, bundle: nil), forCellReuseIdentifier: searchTableId)
        return tableView
    }()
    public var movies: [MovieEntity]? = [MovieEntity]()
    public var movie: MovieEntity?
    weak var navigation: UINavigationController?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(searchResultTableview)
        searchResultTableview.dataSource = self
        searchResultTableview.delegate = self
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        searchResultTableview.frame = view.bounds
    }
}

extension SearchResultsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movies?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let resultCell = tableView.dequeueReusableCell(withIdentifier: "ResultTableCell",
                                                             for: indexPath) as? ResultTableCell,
              let movie = movies?[indexPath.row] else {
            return UITableViewCell()
        }
        resultCell.backgroundColor = Color.mainTheme
        resultCell.downloadImage(movie.posterPath ?? "")
        resultCell.getMovieResult(movie)
        if let genres = movie.genres {
            let genreNames = genres.compactMap { $0.name }
            resultCell.genresLabel.text = genreNames.joined(separator: " | ")
        } else {
            resultCell.genresLabel.text = "Loading..."
        }
        return resultCell
    }
}

extension SearchResultsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 6
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let detailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailView") as? DetailView else {
            return
        }
        guard let movieDetail = movies?[indexPath.row] else { return }
        detailVC.setupDetail(movieDetail)
        navigation?.pushViewController(detailVC, animated: true)
    }
}
