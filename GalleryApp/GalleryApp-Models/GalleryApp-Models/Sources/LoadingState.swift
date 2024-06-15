//
//  LoadingState.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

//MARK: - LoadingState
public enum LoadingState<T> {
    case loading
    case loaded(T)
    case failed
}
