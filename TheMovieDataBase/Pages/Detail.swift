//
//  Detail.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 18/02/25.
//

import Stevia
import SnapKit

class Detail: BaseViewController {
    
    private let item: Item
    
    private lazy var safeViewContainer: UIView = {
        let view = UIView()
        
        view.subviews(coverImageView, descriptionView)
        view.layout {
            0
            |-0--coverImageView--0-|
            0
            |-0--descriptionView--0-|
            0
        }
        coverImageView.Height == view.Height / 2
        
        return view
    }()
    
    private lazy var coverImageView: UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    private lazy var descriptionView: UIScrollView = {
        let view = UIScrollView()
        view.isScrollEnabled = true
        view.showsHorizontalScrollIndicator = false
        view.showsVerticalScrollIndicator = false
        view.subviews(titleLabel, descriptionLabel)
        view.layout {
            10
            titleLabel
            10
            descriptionLabel
            0
        }
        titleLabel.Width == view.Width - 20
        titleLabel.centerHorizontally()
        
        descriptionLabel.Width == view.Width - 20
        descriptionLabel.centerHorizontally()
        
        return view
    }()
    
    private func configureLayout() {
        view.addSubview(safeViewContainer)
        safeViewContainer.snp.makeConstraints { make in
            make.top.leading.bottom.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func configureData() {
        titleLabel.text = item.title
        descriptionLabel.text = item.description
        
        if let coverUrl = item.coverUrl {
            DataProvider.shared.getImageData(from: coverUrl) { item in
                item.hasData { data in
                    DispatchQueue.main.async { [weak self] in guard let self else { return }
                        coverImageView.image = UIImage(data: data)
                    }
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        configureLayout()
        configureData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    init(of item: Item) {
        self.item = item
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
