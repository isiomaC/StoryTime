//
//  EmptyableDiffableDataSource.swift
//  StoryTime
//
//  Created by Chuck on 21/02/2023.
//

import Foundation
import UIKit

/// A diffable data source fir UICollectionViews that is capable of displaying an UIView if the datasource does not contain any item
class EmptyableDiffableDataSource<S, T>: UICollectionViewDiffableDataSource<S, T> where S: Hashable, T: Hashable {

    private var collectionView: UICollectionView?
    private var emptyStateView: UIView?

    /// Creates a diffable data source with the specified cell provider, and connects it to the specified collection view. Additionally an `UIView` can be specified which is shown when the data source is empty
    ///
    /// - Parameters:
    ///   - collectionView: The initialized collection view object to connect to the diffable data source.
    ///   - cellProvider: A closure that creates and returns each of the cells for the collection view from the data the diffable data source provides.
    ///   - emptyStateView: An UIView that is displayed when the data source is empty. If nil is provided, the default view for the collection view is shown
    convenience init(collectionView: UICollectionView,
                     cellProvider: @escaping UICollectionViewDiffableDataSource<S, T>.CellProvider,
                     emptyStateView: UIView? = nil
    ) {
        self.init(collectionView: collectionView, cellProvider: cellProvider)
        self.collectionView = collectionView
        self.emptyStateView = emptyStateView
      

    }

    override func apply(_ snapshot: NSDiffableDataSourceSnapshot<S, T>, animatingDifferences: Bool = true, completion: (() -> Void)? = nil) {
        super.apply(snapshot, animatingDifferences:animatingDifferences, completion: completion)

        guard let emptyView = emptyStateView, let collectionView = collectionView else {
            return
        }

        if snapshot.itemIdentifiers.isEmpty {

            // Add and show empty state view
            emptyView.translatesAutoresizingMaskIntoConstraints = false
            collectionView.addSubview(emptyView)
            NSLayoutConstraint.activate([
                emptyView.topAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.topAnchor),
                emptyView.trailingAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.trailingAnchor),
                emptyView.bottomAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.bottomAnchor),
                emptyView.leadingAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.leadingAnchor)
            ])
        } else {
            NSLayoutConstraint.deactivate([
                emptyView.topAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.topAnchor),
                emptyView.trailingAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.trailingAnchor),
                emptyView.bottomAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.bottomAnchor),
                emptyView.leadingAnchor.constraint(equalTo: collectionView.layoutMarginsGuide.leadingAnchor)
            ])
            // Remove and hide empty state view
            emptyStateView?.removeFromSuperview()
        }
    }
}
