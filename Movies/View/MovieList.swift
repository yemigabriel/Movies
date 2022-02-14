//
//  MoviesView.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/7/22.
//

import UIKit
import Combine
import SwiftUI

class MovieList: UIView {
    
    let moviesList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: screenSize().width/2 - 20, height: 320)
        layout.minimumInteritemSpacing = 5
        layout.minimumLineSpacing = 20
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        return collectionView
    }()
    
    let segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: categories)
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.backgroundColor = .systemGreen.withAlphaComponent(0.5)
        segmentedControl.addTarget(self, action: #selector(didSelectMovies), for: .valueChanged)
        segmentedControl.setTitleTextAttributes([.font: font ?? .systemFont(ofSize: 17)], for: .normal)
        return segmentedControl
    }()
    
    let retryButton: UIButton = {
        let button = UIButton()
        button.setTitle(" No internet connection. Tap to retry?", for: .normal)
        button.setTitleColor(.systemGray, for: .normal)
        button.setImage(UIImage(systemName: "arrow.counterclockwise"), for: .normal)
        button.addTarget(self, action: #selector(didTapRetryBtn), for: .touchUpInside)
        button.isHidden = true
        return button
    }()
    
    let activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        return indicator
    }()
    
    static let categories = ["Latest", "Popular", "Upcoming"]

    @Published var viewModel: MovieListVM
    var cancellables = Set<AnyCancellable>()
    
    init(vm: MovieListVM = MovieListVM()) {
        self.viewModel = vm
        super.init(frame: UIScreen.main.bounds)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpBindings(category: viewModel.category)
    }
    
    func setUp() {
        addSubview(moviesList)
        addSubview(segmentedControl)
        addSubview(retryButton)
        addSubview(activityIndicator)
    }
    
    func setUpConstraints() {
        let guide = safeAreaLayoutGuide
        [segmentedControl, moviesList, retryButton, activityIndicator].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            segmentedControl.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10),
            segmentedControl.widthAnchor.constraint(equalToConstant: bounds.width - 20 ),
            segmentedControl.centerXAnchor.constraint(equalTo: centerXAnchor),
            segmentedControl.heightAnchor.constraint(equalTo: segmentedControl.heightAnchor, constant: 60)
        ])
        
        NSLayoutConstraint.activate([
            retryButton.topAnchor.constraint(equalTo: segmentedControl.bottomAnchor, constant: 10),
            retryButton.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            retryButton.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            activityIndicator.topAnchor.constraint(equalTo: retryButton.bottomAnchor, constant: 10),
            activityIndicator.centerXAnchor.constraint(equalTo: centerXAnchor),
            activityIndicator.widthAnchor.constraint(equalToConstant: 44),
        ])
        
        NSLayoutConstraint.activate([
            moviesList.topAnchor.constraint(equalTo: retryButton    .bottomAnchor, constant: 10),
            moviesList.bottomAnchor.constraint(equalTo: guide.bottomAnchor),
            moviesList.leadingAnchor.constraint(equalTo: guide.leadingAnchor),
            moviesList.trailingAnchor.constraint(equalTo: guide.trailingAnchor)
        ])
    }
    
    func setUpBindings(category: MovieCategory) {
        activityIndicator.startAnimating()
        viewModel.category = category
        viewModel.getLocalMovies()
        viewModel.$movies.sink { movies in
            DispatchQueue.main.async { [weak self] in
                self?.moviesList.reloadData()
                self?.activityIndicator.stopAnimating()
            }
        }
        .store(in: &cancellables)
        viewModel.$hasNetworkError.sink { hasError in
            DispatchQueue.main.async { [weak self] in
                self?.retryButton.isHidden = !hasError
            }
        }
        .store(in: &cancellables)
    }
    
    @objc func didSelectMovies(sender: UISegmentedControl) {
        setUpBindings(category: MovieCategory.allCases[sender.selectedSegmentIndex])
    }
    
    @objc func didTapRetryBtn() {
        setUpBindings(category: viewModel.category)
    }
    
}
