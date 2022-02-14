//
//  DetailView.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/7/22.
//

import UIKit
import Combine

class DetailView: UIView {

    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.contentInsetAdjustmentBehavior = .never
        return scrollView
    }()
    
    private let poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let posterOverlay: UIView = {
        let view = UIView()
        return view
    }()
    
    private let genreLabel: UILabel = {
        let label = UILabel()
        label.font = font
        label.numberOfLines = 1
        return label
    }()
    
    private let runtimeLabel: UILabel = {
        let label = UILabel()
        label.font = boldFont
        label.numberOfLines = 1
//        let frame = label.frame
//        label.frame = CGRect(x: 0, y: 0, width: frame.width + 10, height: frame.height + 10)
        label.backgroundColor = .systemGreen.withAlphaComponent(0.2)
        label.layer.cornerRadius = 5
        label.layer.borderColor = UIColor.systemGray6.cgColor
        label.layer.borderWidth = 1
        return label
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = titleFont
        label.numberOfLines = 0
        return label
    }()
    
    private let descLabel: UILabel = {
        let label = UILabel()
        label.font = font
        label.numberOfLines = 0
        return label
    }()
    
    private let castLabel: UILabel = {
        let label = UILabel()
        label.font = titleFont
        label.numberOfLines = 0
        return label
    }()
    
    let castList: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 80, height: 100)
        layout.minimumInteritemSpacing = 10
        layout.minimumLineSpacing = 20
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        return collectionView
    }()
    
    var viewModel: MovieListVM?
    var cancellables = Set<AnyCancellable>()
    
    override init(frame: CGRect) {
        super.init(frame: UIScreen.main.bounds)
        setUp()
        setUpConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        setUpBindings()
    }
    
    func setUp() {
        addSubview(scrollView)
        scrollView.addSubview(poster)
        scrollView.addSubview(posterOverlay)
        scrollView.addSubview(genreLabel)
        scrollView.addSubview(runtimeLabel)
        scrollView.addSubview(titleLabel)
        scrollView.addSubview(descLabel)
        scrollView.addSubview(castLabel)
        scrollView.addSubview(castList)
    }
    
    func setUpConstraints() {
        [scrollView, poster, posterOverlay, runtimeLabel, genreLabel, titleLabel, descLabel, castLabel, castList].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
        ])
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: scrollView.topAnchor),
            poster.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            poster.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            poster.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height/2),
            poster.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
        ])
        
        NSLayoutConstraint.activate([
            posterOverlay.topAnchor.constraint(equalTo: poster.topAnchor),
            posterOverlay.leadingAnchor.constraint(equalTo: poster.leadingAnchor),
            posterOverlay.trailingAnchor.constraint(equalTo: poster.trailingAnchor),
            posterOverlay.heightAnchor.constraint(equalTo: poster.heightAnchor)
        ])
        
        NSLayoutConstraint.activate([
            runtimeLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 20),
            runtimeLabel.leadingAnchor.constraint(equalTo: poster.leadingAnchor, constant: 20),
            runtimeLabel.widthAnchor.constraint(equalToConstant: 70)
        ])
        
        NSLayoutConstraint.activate([
            genreLabel.topAnchor.constraint(equalTo: runtimeLabel.topAnchor),
            genreLabel.leadingAnchor.constraint(equalTo: runtimeLabel.trailingAnchor, constant: 20),
            genreLabel.trailingAnchor.constraint(equalTo: poster.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: runtimeLabel.bottomAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: poster.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: poster.trailingAnchor, constant: -20)
        ])
        
        NSLayoutConstraint.activate([
            descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 20),
            descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            castLabel.topAnchor.constraint(equalTo: descLabel.bottomAnchor, constant: 20),
            castLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            castLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            castList.topAnchor.constraint(equalTo: castLabel.bottomAnchor, constant: 20),
            castList.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            castList.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
            castList.heightAnchor.constraint(equalToConstant: 100),
            
            
            castList.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -50)
        ])
    }
    
    func setUpBindings() {
        viewModel?.$selectedMovie.sink{ [weak self] movie in
            guard let movie = movie else { return }
            self?.titleLabel.text = movie.title
            self?.descLabel.text = movie.summary
            self?.posterOverlay.backgroundColor = .systemBackground.withAlphaComponent(0.3)
            self?.runtimeLabel.text = "\(movie.runtime) mins"
            if let genres = movie.genre?.allObjects as? [Genre] {
                let genreNames = Set(genres.compactMap{ $0.name })
                self?.genreLabel.text = genreNames.joined(separator: ", ")
            }
            if let url = URL(string: "\(EndPoints.imgBaseUrl)\(movie.poster!)") {
                self?.poster.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
            }
            if let _ = self?.viewModel?.getCast() {
                self?.castLabel.text = "Cast"
                self?.castList.reloadData()
            }
        }
        .store(in: &cancellables)
        
        viewModel?.fetchMovieDetails()
        viewModel?.fetchMovieCast()
        
    }
    
    
}
