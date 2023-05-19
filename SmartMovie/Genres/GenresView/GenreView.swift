//
//  GenreView.swift
//  SmartMovie
//
//  Created by Khoa Dai on 06/04/2023.
//

import UIKit

class GenreView: UIViewController {

    @IBOutlet weak var genresTableView: UITableView!

    let genreCellId: String = "GenresTableCell"
    private let serverCalling = ServerCalling()
    private var genreList: [Genre]?

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Genres"
        fetchGenresData()
        setupGenreTable()
    }
}

extension GenreView {
    func setupGenreTable() {
        genresTableView.dataSource = self
        genresTableView.delegate = self
        genresTableView.register(UINib(nibName: genreCellId, bundle: nil), forCellReuseIdentifier: genreCellId)
    }
}

extension GenreView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreList?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let genreCell = tableView.dequeueReusableCell(withIdentifier: genreCellId, for: indexPath) as? GenresTableCell,
              let genres = genreList?[indexPath.row]
        else {
            return UITableViewCell()
        }
        genreCell.setupGenre(genres)
        return genreCell
    }
}

extension GenreView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.size.height / 7
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let genreMovieVC = GenresMovieListViewController()
        genreMovieVC.movieGenres = genreList?[indexPath.row]
        navigationController?.pushViewController(genreMovieVC, animated: true)
    }
}

extension GenreView {
    func fetchGenresData() {
        serverCalling.fetchGenres { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let genres):
                    self.genreList = genres
                    self.genresTableView.reloadData()
                case .failure(let error):
                    print("\(error)")
                }
            }
        }
    }
}
