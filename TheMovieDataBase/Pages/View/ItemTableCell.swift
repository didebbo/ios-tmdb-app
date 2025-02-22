//
//  ItemTableCell.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 17/02/25.
//

import Stevia

class ItemTableCell: UITableViewCell {
    
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
    
    private lazy var itemDataInfoView: ItemDataInfoView = {
        let view = ItemDataInfoView()
        view.isHidden = true
        return view
    }()
    
    func configure(with item: Item) {
        self.item = item
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        if let itemDataInfo = DataProvider.shared.getItemDataInfo(from: item).result.data {
            itemDataInfoView.isHidden = false
        }
        
        guard let posterImageData = item.posterImageData else { return }
        posterView.image = UIImage(data: posterImageData)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.subviews(posterView, descriptionContainer, itemDataInfoView)
        
        posterView.Width == 100
        posterView.Height == contentView.Height - 20
        posterView.Leading == contentView.Leading + 10
        posterView.centerVertically()
        
        descriptionContainer.Top == contentView.Top + 10
        descriptionContainer.Leading == posterView.Trailing + 10
        descriptionContainer.Trailing == contentView.Trailing - 10
        
        itemDataInfoView.Top >= descriptionContainer.Bottom + 10
        itemDataInfoView.Leading == posterView.Trailing + 10
        itemDataInfoView.Bottom == posterView.Bottom - 10
        itemDataInfoView.Trailing <= contentView.Trailing - 10
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        item = nil
        posterView.image = nil
        titleLabel.text = nil
        descriptionLabel.text = nil
        itemDataInfoView.isHidden = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
