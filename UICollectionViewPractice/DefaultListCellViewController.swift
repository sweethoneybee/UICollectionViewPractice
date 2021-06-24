//
//  DefaultListCellViewController.swift
//  UICollectionViewPractice
//
//  Created by 정성훈 on 2021/06/24.
//

import UIKit

class DefaultListCellViewController: UIViewController {

    enum Section {
        case main
    }
    
    var dataSource: UICollectionViewDiffableDataSource<Section, Int>!
    var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureHierarchy()
        configureDataSource()
    }
}

extension DefaultListCellViewController {
    func createLayout() -> UICollectionViewLayout {
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0),
                                               heightDimension: .absolute(70))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        
        
        let section = NSCollectionLayoutSection(group: group)
        section.interGroupSpacing = CGFloat(10)
        let layout = UICollectionViewCompositionalLayout(section: section)
        
        return layout
    }
}

extension DefaultListCellViewController {
    func configureHierarchy() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        collectionView.backgroundColor = .systemBackground
        collectionView.delegate = self
        view.addSubview(collectionView)
        
        let randomButton: UIButton = {
            let btn = UIButton()
            btn.translatesAutoresizingMaskIntoConstraints = false
            btn.setTitle("랜덤", for: .normal)
            btn.backgroundColor = .blue
            btn.addTarget(self, action: #selector(onRandomButton), for: .touchUpInside)
            return btn
        }()
        view.addSubview(randomButton)
        randomButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        randomButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        randomButton.widthAnchor.constraint(equalToConstant: 100).isActive = true
        randomButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureDataSource() {
        let cellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, Int> {
            cell, indexPath, identifier in
            var content = cell.defaultContentConfiguration()
            
            content.text = "임시 텍스트"
            content.secondaryText = "세컨더리 텍스트. 아이템=\(identifier)"
            
            cell.contentConfiguration = content
        }
        
        dataSource = UICollectionViewDiffableDataSource<Section, Int>(collectionView: collectionView) {
            (collectionView: UICollectionView, indexPath: IndexPath, identifier: Int) -> UICollectionViewCell? in
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: identifier)
        }
     
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(Array(0...30))
        dataSource.apply(snapshot, animatingDifferences: true)
    }
}

extension DefaultListCellViewController {
    @objc func onRandomButton() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Int>()
        snapshot.appendSections([.main])
        snapshot.appendItems(shuffleData())
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func shuffleData() -> Array<Int> {
        let items = Array(0...30)
        return items.shuffled()
    }
}

extension DefaultListCellViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
