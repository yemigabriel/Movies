//
//  CollectionViewCell.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/7/22.
//

import UIKit
import SDWebImage

class MovieCell: UICollectionViewCell {

    static let cellIdentifier = "MovieCell"
    static let cornerRadius: CGFloat = 10
    
    private let poster: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .green.withAlphaComponent(0.2)
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = boldFont
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUp()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUp() {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = MovieCell.cornerRadius
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(poster)
        contentView.addSubview(titleLabel)
    }
    
    override func layoutSubviews() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        [poster, titleLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            poster.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            poster.widthAnchor.constraint(equalToConstant: contentView.frame.width),
            poster.heightAnchor.constraint(equalToConstant: 250.0)
        ])
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: poster.bottomAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10)
        ])
        
    }
    
    func configure(movie: Movie) {
        if let url = URL(string: "\(EndPoints.imgBaseUrl)\(movie.poster!)") {
            poster.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        }
        titleLabel.text = movie.title ?? ""
    }
    
}
