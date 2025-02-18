//
//  BottomNavigator.swift
//  TheMovieDataBase
//
//  Created by Gianluca Napoletano on 15/02/25.
//

import SnapKit

class BottomNavigator: BaseNavigationController {
    
    var destinations: [BottomNavigationBar.Item.Destination] = []
    
    lazy var bottomNavigationBar: BottomNavigationBar = {
        let view = BottomNavigationBar(detstinations: destinations)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.delegate = self
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar.prefersLargeTitles = true
        
        if let destination = destinations.first {
            setViewControllers([destination.viewController], animated: false)
        }
        
        handleBottomNavigationBar()
    }
    
    private func handleBottomNavigationBar() {
        view.addSubview(bottomNavigationBar)
        bottomNavigationBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(BottomNavigationBar.itemHeight)
            make.bottom.equalToSuperview()
        }
    }
}

extension BottomNavigator: BottomNavigationBarDelegate {
    
    func didSelectItemAt(currentIndex: Int, destinationIndex: Int) {
        guard currentIndex != destinationIndex else { return }
        
        guard let currentVC = topViewController else { return }
        let destinationVC = destinations[destinationIndex].viewController
        
        let startDestinationVCTranslationX: CGFloat = currentIndex < destinationIndex ? view.bounds.width : -view.bounds.width
        destinationVC.view.transform = CGAffineTransform(translationX: startDestinationVCTranslationX, y: 0)
        
        handleComplexAnimation(currentItem: (index: currentIndex, vc: currentVC), destinationItem: (index: destinationIndex, vc: destinationVC))
    }
    
    private func handleSimpleAnimation(currentItem: (index: Int, vc: UIViewController), destinationItem: (index: Int, vc: UIViewController)) {
        UIView.animate(withDuration: 0.3) { [weak self] in guard let self else { return }
            let currentVCTranslationX: CGFloat = currentItem.index < destinationItem.index ? -view.bounds.width : view.bounds.width
            currentItem.vc.view.transform = CGAffineTransform(translationX: currentVCTranslationX, y: 0)
        } completion: { [weak self] _ in guard let self else { return }
            setViewControllers([destinationItem.vc], animated: false)
            
            UIView.animate(withDuration: 0.3) {
                destinationItem.vc.view.transform = .identity
            }
        }
    }
    
    private func handleMediumAnimation(currentItem: (index: Int, vc: UIViewController), destinationItem: (index: Int, vc: UIViewController)) {
        destinationItem.vc.view.alpha = 0
        UIView.animate(withDuration: 0.3) { [weak self] in guard let self else { return }
            let currentVCTranslationX: CGFloat = currentItem.index < destinationItem.index ? -view.bounds.width : view.bounds.width
            currentItem.vc.view.transform = CGAffineTransform(translationX: currentVCTranslationX, y: 0)
            currentItem.vc.view.alpha = 0
        } completion: { [weak self] _ in guard let self else { return }
            setViewControllers([destinationItem.vc], animated: false)
            
            UIView.animate(withDuration: 0.3) {
                destinationItem.vc.view.transform = .identity
                destinationItem.vc.view.alpha = 1
            }
        }
    }
    
    private func handleComplexAnimation(currentItem: (index: Int, vc: UIViewController), destinationItem: (index: Int, vc: UIViewController)) {
        destinationItem.vc.view.alpha = 0
        
        UIView.animate(withDuration: 0.6) { [weak self] in guard let self else { return }
            let currentVCTranslationX: CGFloat = currentItem.index < destinationItem.index ? -view.bounds.width : view.bounds.width
            currentItem.vc.view.transform = CGAffineTransform(translationX: currentVCTranslationX, y: 0)
        }
        UIView.animate(withDuration: 0.3) {
            currentItem.vc.view.alpha = 0
        } completion: { [weak self] _ in guard let self else { return }
            setViewControllers([destinationItem.vc], animated: false)
            
            UIView.animate(withDuration: 0.3) {
                destinationItem.vc.view.transform = .identity
            }
            UIView.animate(withDuration: 0.6) {
                destinationItem.vc.view.alpha = 1
            }
        }
    }
}

