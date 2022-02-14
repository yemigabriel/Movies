//
//  CastCell.swift
//  Movies
//
//  Created by Yemi Gabriel on 2/9/22.
//

import UIKit

class CastCell: UICollectionViewCell {
    
    static let cellIdentifier = "CastCell"
    static let avatarWidth = 80.0
    
    private let avatar: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.backgroundColor = .purple
        imageView.layer.cornerRadius = avatarWidth/2
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = smallFont
        label.numberOfLines = 2
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
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
        contentView.addSubview(avatar)
        contentView.addSubview(nameLabel)
        contentView.backgroundColor = .systemBackground
    }
    
    override func layoutSubviews() {
        setUpConstraints()
    }
    
    func setUpConstraints() {
        [avatar, nameLabel].forEach{
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            avatar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 0),
            avatar.widthAnchor.constraint(equalToConstant: Self.avatarWidth),
            avatar.heightAnchor.constraint(equalToConstant: Self.avatarWidth)
        ])
        
        NSLayoutConstraint.activate([
            nameLabel.topAnchor.constraint(equalTo: avatar.bottomAnchor, constant: 5),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5)
        ])
        
    }
    
    func configure(cast: Cast) {
        if let url = URL(string: "\(EndPoints.imgBaseUrl)\(cast.profile!)") {
            avatar.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder.png"))
        }
        nameLabel.text = cast.name ?? ""
    }
    
}
