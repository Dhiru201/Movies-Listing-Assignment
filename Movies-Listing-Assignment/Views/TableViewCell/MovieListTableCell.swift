//
//  MovieListTableCell.swift
//  Movies-Listing-Assignment
//
//  Created by Dhirendra Kumar Verma on 18/06/24.
//

import UIKit
import SDWebImage

// Protocol definition
protocol MovieListCellDelegate: AnyObject {
    func didTapFavoriteButtonInCell(_ cell: MovieListTableCell)
}

final class MovieListTableCell: UITableViewCell {
    @IBOutlet private weak var movieImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var timeNGenreLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!

    weak var delegate: MovieListCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    /// Resets the cell's contents to prepare for reuse.
    override func prepareForReuse() {
        super.prepareForReuse()
        movieImage.image = .none
        titleLabel.text = .none
        timeNGenreLabel.text = .none
    }
    
    /// Configures the cell with the specified movie details.
    /// - Parameter movie: The `Movie` object representing the movie to be displayed.
    func configure(with movie: Movie) {
        titleLabel.text = movie.title
        movieImage.sd_setImage(with: URL(string: movie.imageUrl), placeholderImage: UIImage(named: "placeholder.png"))
        timeNGenreLabel.text = "\(movie.duration) -  \(movie.genre)"
        toggelFavoriteButton(isFavorite: movie.isFavorite)
    }
    
    /// Toggles the favorite button icon based on the movie's favorite status.
    /// - Parameter isFavorite: A Boolean value indicating whether the movie is marked as favorite.
    private func toggelFavoriteButton(isFavorite: Bool) {
        print(isFavorite)
        favoriteButton.setImage(isFavorite ? UIImage(systemName: "bookmark.fill") : UIImage(systemName: "bookmark"), for: .normal)
    }
    
    
    @IBAction func favoriteButtonAction(_ sender: UIButton) {
        delegate?.didTapFavoriteButtonInCell(self)
    }
}
