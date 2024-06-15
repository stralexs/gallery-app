//
//  UseCase.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

import Combine

// MARK: - UseCase
public protocol UseCase {
    
    // MARK: Associatedtype
    associatedtype Input
    associatedtype SuccessType
    associatedtype FailureType: Error

    // MARK: Methods
    @discardableResult
    func execute(request: Input) -> AnyPublisher<SuccessType, FailureType>
}
