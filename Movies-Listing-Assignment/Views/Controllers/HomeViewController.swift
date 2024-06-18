//
//  HomeViewController.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import UIKit

final class HomeViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet weak var moviesTableView: UITableView!
    private var viewModel: MovieListDataProtocol!
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.largeTitleDisplayMode =  .always
        self.navigationItem.title = "Movies"
        view.backgroundColor = .white
        setupViewModel()
        prepareProductListView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchMoviesData()
    }

    /// Sets up the view model for managing movie-related operations.
    private func setupViewModel() {
        self.viewModel = MoviesViewModel(for: .home)
    }

    /// Prepares the movies table view by setting up data source and delegate.
    private func prepareProductListView() {
        moviesTableView.dataSource = self
        moviesTableView.delegate = self
        moviesTableView.register(cellType: MovieListTableCell.self)
    }

    /// Fetches movies data from the view model.
    private func fetchMoviesData() {
        /// Fetch products
        viewModel.fetchMovies { [weak self] in
            self?.moviesTableView.reloadData()
        }
    }
}

// MARK: - TableView (List) Extension
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    /// Handles the selection of a movie at a specific index.
    /// - Parameter index: The index of the selected movie.
    func didSelectRowAt(index: Int) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        guard let detailVC = storyboard.instantiateViewController(identifier: "MovieDetailViewController") as? MovieDetailViewController,
              let movieObj = viewModel.movie(index) else { return }
        detailVC.movieDetails = movieObj
        self.navigationController?.pushViewController(detailVC, animated: true)
    }
}

extension HomeViewController: MovieListCellDelegate {
    func didTapFavoriteButtonInCell(_ cell: MovieListTableCell) {
        // Handle button tap from the cell
        guard let indexPath = moviesTableView.indexPath(for: cell) else {
            return
        }
        viewModel.toggleFavorite(at: indexPath)
        self.moviesTableView.reloadData()
    }
}
