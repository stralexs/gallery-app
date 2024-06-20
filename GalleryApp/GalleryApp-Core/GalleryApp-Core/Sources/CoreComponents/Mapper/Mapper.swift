//
//  Mapper.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

// MARK: - Mapper
public protocol Mapper {
    
    // MARK: Associatedtype
    associatedtype Source
    associatedtype Destination
    
    // MARK: Methods
    func mapModel(_ model: Source) -> Destination
}
