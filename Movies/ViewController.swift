//
//  ViewController.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/6/22.
//

import UIKit
import Combine

class ViewController: UIViewController {

    let moviesView = MovieList()
    var viewModel: MovieListVM?
    
    override func loadView() {
        view = moviesView
        viewModel = moviesView.viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Movies"
        
        moviesView.moviesList.delegate = self
        moviesView.moviesList.dataSource = self
        moviesView.moviesList.register(MovieCell.self, forCellWithReuseIdentifier: MovieCell.cellIdentifier)
    }
    
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel?.movies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MovieCell.cellIdentifier, for: indexPath) as? MovieCell else { fatalError() }
        
        if let movie = viewModel?.movies[indexPath.row] {
            cell.configure(movie: movie)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        guard let _ = collectionView.cellForItem(at: indexPath) as? MovieCell
        else { return }
        
        if let movie = viewModel?.movies[indexPath.row] {
            viewModel?.selectedMovie = movie
            let detailVC = DetailViewController()
            detailVC.viewModel = viewModel
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }
    
    
}

