//
//  MovieDetailViewController.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import UIKit

class MovieDetailViewController: UIViewController {
    // MARK: - Outlets
    @IBOutlet private weak var movieDetailTableView: UITableView!
    
    // MARK: - Properties
    var movieDetails: Movie?
    private var movieManager = MovieManager(favoriteService: FavoriteService())
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMovieDetailTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    /// Prepares the view appearance and navigation bar settings.
    private func prepareView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        self.navigationItem.title = movieDetails?.title
    }
    
    /// Prepares the table view for displaying movie details.
    private func prepareMovieDetailTableView() {
      //  movieDetailTableView.dataSource = self
        movieDetailTableView.delegate = self
        movieDetailTableView.register(viewType: MovieDetailsHeaderView.self)
        if #available(iOS 15.0, *) {
            movieDetailTableView.sectionHeaderTopPadding = 0
        }
    }
    
    /// Action when the favorite button is tapped.
    func favoriteButtonAction() {
        guard let movie = movieDetails else { return }
        movieManager.toggleFavorite(movie: movie)
        movieDetails?.toggleIsFavorite()
        movieDetailTableView.reloadData()
    }
}

// MARK: - TableView (ListDetails) Extension
extension MovieDetailViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view : MovieDetailsHeaderView = MovieDetailsHeaderView.fromNib()
        guard let movieObj = self.movieDetails else {
            return nil
        }
        view.movie = movieObj
        view.favoriteButtonAction = {
            self.favoriteButtonAction()
        }
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}
