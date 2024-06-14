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

// MARK: - Default Implementation
public extension UseCase where Input == Any? {
    func execute() -> AnyPublisher<SuccessType, FailureType> {
        execute(request: nil)
    }
}
