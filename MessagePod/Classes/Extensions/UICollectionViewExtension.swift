//
//  UICollectionViewExtension.swift
//  MessagePod
//
//  Created by gang wang on 25/12/2017.
//

import Foundation

public protocol CollectionViewReusable: AnyObject {
    static func reuseIdentifier() -> String
}

public extension MessagesCollectionView {
    func register<CellType: UICollectionViewCell & CollectionViewReusable>(_ cellClass: CellType.Type) {
        register(cellClass, forCellWithReuseIdentifier: CellType.reuseIdentifier())
    }
    
    func register<ViewType: UICollectionReusableView & CollectionViewReusable>(_ headerFooterClass: ViewType.Type, forSupplementaryViewOfKind kind: String) {
        register(headerFooterClass, forSupplementaryViewOfKind: kind, withReuseIdentifier: ViewType.reuseIdentifier())
    }
    
    func dequeueReusableCell<CellType: UICollectionViewCell & CollectionViewReusable>(_ cellClass: CellType.Type, for indexPath: IndexPath) -> CellType {
        guard let cell = dequeueReusableCell(withReuseIdentifier: cellClass.reuseIdentifier(), for: indexPath) as? CellType else {
            fatalError("Unable to dequeue \(String(describing: cellClass)) with reuseId of \(cellClass.reuseIdentifier())")
        }
        return cell
    }
    
    func dequeueReusableHeader<ViewType: UICollectionReusableView & CollectionViewReusable>(_ viewClass: ViewType.Type, for indexPath: IndexPath) -> ViewType {
        
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: viewClass.reuseIdentifier(), for: indexPath)
        
        guard let viewType = view as? ViewType else {
            fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(viewClass.reuseIdentifier())")
        }
        return  viewType
    }
    
    func dequeueReusableFooter<ViewType: UICollectionReusableView & CollectionViewReusable>(_ viewClass: ViewType.Type, for indexPath: IndexPath) -> ViewType {
        
        let view = dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionFooter, withReuseIdentifier: viewClass.reuseIdentifier(), for: indexPath)
        
        guard let viewType = view as? ViewType else {
            fatalError("Unable to dequeue \(String(describing: viewClass)) with reuseId of \(viewClass.reuseIdentifier())")
        }
        return  viewType
    }
}
