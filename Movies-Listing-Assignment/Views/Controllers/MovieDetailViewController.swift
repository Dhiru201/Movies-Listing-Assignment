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
    var comments: [Comment] = []

    private var movieManager = MovieManager(favoriteService: FavoriteService(), commentService: CommentService())
    // Track the active text view
    private weak var activeField: UIView?
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareMovieDetailTableView()
        fetchAllComments {
            self.movieDetailTableView.reloadData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        prepareView()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.prefersLargeTitles = true
        deregisterFromKeyboardNotifications()
    }
    
    /// Prepares the view appearance and navigation bar settings.
    private func prepareView() {
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = false
        view.backgroundColor = .white
        self.navigationItem.title = movieDetails?.title
        registerForKeyboardNotifications()
        setupTapGesture()
    }
    
    /// Registers for keyboard notifications.
        private func registerForKeyboardNotifications() {
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
            NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        }
    
    /// Deregisters from keyboard notifications.
       private func deregisterFromKeyboardNotifications() {
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
           NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
       }
       
    /// Adjusts content inset of table view when keyboard will show.
    @objc private func keyboardWillShow(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            return
        }
        
        let contentInsets = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame.height, right: 0)
        movieDetailTableView.contentInset = contentInsets
        movieDetailTableView.scrollIndicatorInsets = contentInsets
        
        // Scroll to active field if needed
        if let activeField = activeField {
            let rect = activeField.convert(activeField.bounds, to: movieDetailTableView)
            movieDetailTableView.scrollRectToVisible(rect, animated: true)
        }
    }
       
       /// Adjusts content inset of table view when keyboard will hide.
       @objc private func keyboardWillHide(_ notification: Notification) {
           let contentInsets = UIEdgeInsets.zero
           movieDetailTableView.contentInset = contentInsets
           movieDetailTableView.scrollIndicatorInsets = contentInsets
           movieDetailTableView.scrollsToTop = true
       }
       
       /// Sets up tap gesture recognizer to dismiss keyboard when tapping outside.
    private func setupTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tapGesture)
        tapGesture.cancelsTouchesInView = false
    }
    
       /// Dismisses keyboard when tapping outside.
       @objc private func dismissKeyboard() {
           view.endEditing(true)
           movieDetailTableView.reloadData()
       }
    
    private func fetchAllComments(completion: @escaping () -> Void) {
        guard let movie = movieDetails, let comments = movieManager.getAllComments(for: movie) else {
            completion()
            return
        }
        self.comments = comments
        completion()
    }
    
    /// Prepares the table view for displaying movie details.
    private func prepareMovieDetailTableView() {
        movieDetailTableView.dataSource = self
        movieDetailTableView.delegate = self
        movieDetailTableView.register(viewType: MovieDetailsHeaderView.self)
        movieDetailTableView.register(cellType: AddCommentTableViewCell.self)
        movieDetailTableView.register(cellType: CommentTableViewCell.self)
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
extension MovieDetailViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 0
        } else {
            return comments.count ?? 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1 {
            let cell = tableView.dequeueReusableCell(with: CommentTableViewCell.self, for: indexPath)
            guard let commentObj = comments[safe: indexPath.item] else { return cell }
            cell.commentLabel.text = commentObj.comment
            return cell
        } else {
            return UITableViewCell()
        }
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            let view : MovieDetailsHeaderView = MovieDetailsHeaderView.fromNib()
            guard let movieObj = self.movieDetails else {
                return nil
            }
            view.movie = movieObj
            view.favoriteButtonAction = {
                self.favoriteButtonAction()
            }
            return view
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "AddCommentTableViewCell") as? AddCommentTableViewCell else { return nil }
            cell.commentTextView.delegate = self
            cell.commentTextView.text = "Enter comment here..."
            cell.commentTextView.textColor = UIColor.lightGray
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MovieDetailViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        activeField = textView
        if textView.textColor == UIColor.lightGray {
            textView.text = .none
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Enter text here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        activeField = nil
        if textView.text.isEmpty {
            textView.text = "Enter text here..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        // Detect if the user pressed the "send" button (usually return or done button on keyboard)
        if text == "\n" {
            // Handle your action here
            handleSendAction(textView)
            // Return false to prevent new line character in text view
            return false
        }
        return true
    }

    func handleSendAction(_ textView: UITextView) {
        guard let movieId = movieDetails?.id, let comment = textView.text, comment != "Enter text here..." else { return }
        let commentObj = Comment(id: UUID(), comment: comment, movieId: movieId)
        movieManager.saveComment(commentObj)
        textView.resignFirstResponder() // Dismiss keyboard if needed
        fetchAllComments {
            self.movieDetailTableView.reloadData()
        }
    }
}
