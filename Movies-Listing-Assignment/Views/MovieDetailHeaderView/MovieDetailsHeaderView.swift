//
//  MovieDetailsHeaderView.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import UIKit
import SDWebImage

class MovieDetailsHeaderView: UITableViewHeaderFooterView {
    //MARK: - Properties
    @IBOutlet private weak var releaseDateLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var ratingLabel: UILabel!
    @IBOutlet private weak var durationLabel: UILabel!
    @IBOutlet private weak var genreLabel: UILabel!
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet weak var favoriteButton: UIButton!
    var favoriteButtonAction: (() -> Void)?
    
    var movie: Movie? {
        didSet {
            setMovieDetails()
        }
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        movieImage.layer.cornerRadius = 8
        movieImage.layer.masksToBounds = true
    }
    
//    override init(reuseIdentifier: String?) {
//        super.init(reuseIdentifier: reuseIdentifier)
//    }
//
//    required init?(coder: NSCoder) {
//        super.init(coder: coder)
//    }
    
    /// Sets up the UI with movie details.
    private func setMovieDetails() {
        guard let movie else { return }
        releaseDateLabel.text = movie.releaseDate
        descriptionLabel.text = movie.description
        ratingLabel.text = "\(movie.rating)" + "/10"
        durationLabel.text = movie.duration
        genreLabel.text = movie.genre
        movieImage.sd_setImage(with: URL(string: movie.imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        favoriteButton.setImage(movie.isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
    
    /// Handles tap on the favorite button.
    @IBAction func didTapfavoriteButton(_ sender: Any) {
        favoriteButtonAction?()
    }
}
