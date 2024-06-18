//
//  FavoritesViewController.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import UIKit

class FavoritesViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var favoritesListTableView: UITableView!
    
    // MARK: - Properties
    private var viewModel: MovieListDataProtocol!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        self.navigationItem.title = "Favorites"
        view.backgroundColor = .white
        setupViewModel()
        prepareProductListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMoviesData()
    }

    /// Sets up the view model for managing favorite movie operations.
    private func setupViewModel() {
        self.viewModel = MoviesViewModel(for: .favorite)
    }

    /// Prepares the table view for displaying favorite movie list.
    private func prepareProductListView() {
        favoritesListTableView.dataSource = self
        favoritesListTableView.delegate = self
        favoritesListTableView.register(cellType: MovieListTableCell.self)
    }
    
    /// Fetches favorite movies data from the view model.
    private func fetchMoviesData() {
        viewModel.fetchFavoriteMovies { [weak self] in
            self?.favoritesListTableView.reloadData()
        }
    }
}

// MARK: - TableView (List) Extension
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(with: MovieListTableCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.delegate = self
        if let movie = viewModel.movie(indexPath.row) {
            cell.configure(with: movie)
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        didSelectRowAt(index: indexPath.row)
    }
    
    /// Handles selection of a movie cell to navigate to its details.
    func didSelectRowAt(index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController,
              let movieObj = viewModel.movie(index) else { return }
        detailVC.movieDetails = movieObj
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

// MARK: - MovieListCellDelegate Extension
extension FavoritesViewController: MovieListCellDelegate {
    func didTapFavoriteButtonInCell(_ cell: MovieListTableCell) {
        /// Handles favorite button tap in the movie cell to toggle favorite status.
        guard let indexPath = favoritesListTableView.indexPath(for: cell) else {
            return
        }
        viewModel.toggleFavorite(at: indexPath)
        viewModel.fetchFavoriteMovies {
            self.favoritesListTableView.reloadData()
        }
    }
}
