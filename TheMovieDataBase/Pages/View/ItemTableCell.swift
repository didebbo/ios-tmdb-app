//
//  ItemTableCell.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Stevia

class ItemTableCell: UITableViewCell {
    
    private lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.backgroundColor = .lightGray
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionContainer: UIView = {
        let view = UIView()
        
        view.subviews(titleLabel, descriptionLabel)
        view.layout {
            0
            |-0--titleLabel--0-|
            (>=5)
            |-0--descriptionLabel--0-|
            0
        }
        
        return view
    }()
    
    func configure(with item: Item) {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        DataProvider.shared.getImageDataFrom(imagePath: item.posterPath) { item in
            item.hasData { data in
                DispatchQueue.main.async { [weak self] in guard let self else { return }
                    posterView.image = UIImage(data: data)
                }
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.subviews(posterView, descriptionContainer)
        
        posterView.Top == contentView.Top + 10
        posterView.Leading == contentView.Leading + 10
        posterView.Bottom == contentView.Bottom - 10
        posterView.Width == 50
        
        descriptionContainer.Top == contentView.Top + 10
        descriptionContainer.Leading == posterView.Trailing + 10
        descriptionContainer.Bottom == contentView.Bottom - 10
        descriptionContainer.Trailing == contentView.Trailing - 10
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
