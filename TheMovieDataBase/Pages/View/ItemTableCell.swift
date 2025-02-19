//
//  ItemTableCell.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Stevia

protocol ItemTableCellDelegate: AnyObject {
    func didTapSaveIcon(item: Item)
}

class ItemTableCell: UITableViewCell {
    
    weak var delegate: ItemTableCellDelegate?
    
    static let heightForRowAt: CGFloat = 160
    
    private var item: Item?
    
    private lazy var posterView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .lightGray
        view.contentMode = .scaleToFill
        view.translatesAutoresizingMaskIntoConstraints = false
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
        label.numberOfLines = 3
        return label
    }()
    
    private lazy var descriptionContainer: UIView = {
        let view = UIView()
        
        view.subviews(titleLabel, descriptionLabel)
        view.layout {
            0
            |-0--titleLabel--0-|
            5
            |-0--descriptionLabel--0-|
            0
        }
        
        return view
    }()
    
    private lazy var saveIconTapGesture = UITapGestureRecognizer(target: self, action: #selector(tapOnSaveIcon))
    
    private lazy var saveIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = UIColor(resource: .primary)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    func configure(with item: Item) {
        self.item = item
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        if let saved = item.saved  {
            let iconName = saved ? "heart.fill" : "heart"
            saveIcon.image = UIImage(systemName: iconName)
            saveIcon.addGestureRecognizer(saveIconTapGesture)
        }
        
        guard let posterPath = item.posterPath else { return }
        DataProvider.shared.getImageDataFrom(imagePath: posterPath) { item in
            item.hasData { data in
                DispatchQueue.main.async { [weak self] in guard let self else { return }
                    posterView.image = UIImage(data: data)
                }
            }
        }
    }
    
    @objc private func tapOnSaveIcon() {
        guard let item else { return }
        delegate?.didTapSaveIcon(item: item)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.subviews(posterView, descriptionContainer, saveIcon)
        
        posterView.Width == 100
        posterView.Height == contentView.Height - 20
        posterView.Leading == contentView.Leading + 10
        posterView.centerVertically()
        
        descriptionContainer.Top == contentView.Top + 10
        descriptionContainer.Leading == posterView.Trailing + 10
        descriptionContainer.Trailing == contentView.Trailing - 10
        
        saveIcon.Top >= descriptionContainer.Bottom + 10
        saveIcon.Leading == posterView.Trailing + 10
        saveIcon.Bottom == contentView.Bottom - 10
        saveIcon.Width == 35
        saveIcon.heightEqualsWidth()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        posterView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        saveIcon.image = nil
        saveIcon.removeGestureRecognizer(saveIconTapGesture)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
