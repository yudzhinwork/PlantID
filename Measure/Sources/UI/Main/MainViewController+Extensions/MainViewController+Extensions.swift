//
//  MainViewController+Extensions.swift

//
//   on 08.01.2024.
//

import UIKit

extension MainViewController {
    func createLayout() -> UICollectionViewCompositionalLayout {
        return UICollectionViewCompositionalLayout { (section, environment) -> NSCollectionLayoutSection? in
            switch section {
            case 0:
                let itemHeightDimension = UIDevice.current.name.contains("SE") ? 1 / 1.3 : 1.0

                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(itemHeightDimension)
                )
                let layoutItem = NSCollectionLayoutItem(
                    layoutSize: itemSize
                )
                layoutItem.edgeSpacing = NSCollectionLayoutEdgeSpacing(
                    leading: NSCollectionLayoutSpacing.fixed(8),
                    top: nil,
                    trailing: nil,
                    bottom: nil
                )
                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .estimated(70),
                    heightDimension: .estimated(70)
                )
                let layoutGroup = NSCollectionLayoutGroup.vertical(
                    layoutSize: groupSize, subitem: layoutItem, count: 1
                )

                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.contentInsets = NSDirectionalEdgeInsets(
                    top: 12, leading: 16, bottom: 20, trailing: 12
                )
                layoutSection.orthogonalScrollingBehavior = .continuous

                let layoutSectionHeaderSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(20)
                )
                let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: layoutSectionHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )

                layoutSection.boundarySupplementaryItems = [layoutSectionHeader]

                return layoutSection
            default:
                let itemHeightDimension = UIDevice.current.name.contains("SE") ? 0.7 : 1.0

                let itemSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .fractionalHeight(itemHeightDimension)
                )
                let layoutItem = NSCollectionLayoutItem(
                    layoutSize: itemSize
                )

                let groupHeightDimension = UIDevice.current.name.contains("SE") ? 0.8 : 1 / 1.5

                let groupSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(0.8),
                    heightDimension: .fractionalHeight(groupHeightDimension)
                )
                let layoutGroup = NSCollectionLayoutGroup.horizontal(
                    layoutSize: groupSize, subitem: layoutItem, count: 1
                )
                layoutGroup.contentInsets = NSDirectionalEdgeInsets(
                    top: 0, leading: 0, bottom: 0, trailing: 12
                )

                let layoutSection = NSCollectionLayoutSection(group: layoutGroup)
                layoutSection.contentInsets = NSDirectionalEdgeInsets(
                    top: 12, leading: 16, bottom: 0, trailing: 0
                )
                layoutSection.orthogonalScrollingBehavior = .groupPaging

                layoutSection.visibleItemsInvalidationHandler = { [weak self] items, scrollOffset, environment in
                    guard let self = self else { return }
                    let visibleRect = CGRect(
                        x: scrollOffset.x + 110,
                        y: 0,
                        width: environment.container.contentSize.width,
                        height: environment.container.contentSize.height
                    )
                    
                    var visibleIndexPaths: [IndexPath] = []
                    for item in items {
                        if item.frame.intersects(visibleRect) {
                            visibleIndexPaths.append(item.indexPath)
                        }
                    }
                    
                    let sortedVisibleIndexPaths = visibleIndexPaths.sorted { $0.item < $1.item }
                    if let currentIndexPath = sortedVisibleIndexPaths.first {
                        self.updatePageControl(with: currentIndexPath.item)
                    }
                }
                
                let layoutSectionHeaderSize = NSCollectionLayoutSize(
                    widthDimension: .fractionalWidth(1),
                    heightDimension: .estimated(20)
                )
                let layoutSectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                    layoutSize: layoutSectionHeaderSize,
                    elementKind: UICollectionView.elementKindSectionHeader,
                    alignment: .topLeading
                )
                layoutSection.boundarySupplementaryItems = [layoutSectionHeader]
                return layoutSection
            }
        }
    }
}
