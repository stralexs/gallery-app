//
//  CoreDataError.swift
//  GalleryApp-Models
//
//  Created by Alexander Sivko on 16.06.24.
//

import Foundation

// MARK: - CoreDataError
public enum CoreDataError: Error {
    case saveExecutionError
    case requestConversionError
    case fetchExecutionError
    case deleteExecutionError
}
