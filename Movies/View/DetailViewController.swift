//
//  DetailViewController.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/7/22.
//

import UIKit

class DetailViewController: UIViewController {

    let detailView = DetailView()
    var viewModel: MovieListVM?
    
    override func loadView() {
        view = detailView
        detailView.viewModel = viewModel
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        detailView.castList.register(CastCell.self, forCellWithReuseIdentifier: CastCell.cellIdentifier)
        detailView.castList.delegate = self
        detailView.castList.dataSource = self
    }
    

}

extension DetailViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let totalCastCount = viewModel?.getCast()?.count {
            return totalCastCount < 7 ? totalCastCount : 7
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CastCell.cellIdentifier, for: indexPath) as? CastCell else { fatalError() }
        if let castList = viewModel?.getCast(), indexPath.row <= 7 {
            let cast = castList[indexPath.row]
            cell.configure(cast: cast)
        }
        return cell
    }
    
    
    
    
}
