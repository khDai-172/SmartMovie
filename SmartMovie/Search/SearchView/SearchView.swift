//
//  SearchView.swift
//  SmartMovie
//
//  Created by Khoa Dai on 04/04/2023.
//

import UIKit

class SearchView: UIViewController {
    @IBOutlet weak var overView: UIView!
    private let searchController = UISearchController(searchResultsController: SearchResultsViewController())
    private let serverCalling = ServerCalling()
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        configureSearchController()
        overView.backgroundColor = Color.mainTheme
    }

    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = true
        definesPresentationContext = true
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Search for a Movie"
    }
}

extension SearchView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar

        guard let query = searchBar.text,
              !query.trimmingCharacters(in: .whitespaces).isEmpty,
              query.trimmingCharacters(in: .whitespaces).count >= 2,
              let resultController = searchController.searchResultsController as? SearchResultsViewController
        else { return }
        
        serverCalling.fetchSearchData(query: query) { result in
            resultController.movies = []
            DispatchQueue.main.async {
                switch result {
                case .success(let movies):
                    let group = DispatchGroup()
                    for index in 0..<movies.count {
                        group.enter()
                        self.serverCalling.fetchMovieDetails(movieId: movies[index].id ?? 0) { result in
                            switch result {
                            case .success(let movie):
                                resultController.movies?.append(movie)
                            case .failure(let error):
                                print("\(error)")
                            }
                            group.leave()
                        }
                    }
                    group.notify(queue: .main) {
                        resultController.searchResultTableview.reloadData()
                        resultController.navigation = self.navigationController
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
}
