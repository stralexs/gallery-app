//
//  NSObject+Extension.swift
//  GalleryApp-Core
//
//  Created by Alexander Sivko on 14.06.24.
//

import Foundation

// MARK: - NSObject
public extension NSObject {
    static var className: String { return NSStringFromClass(self).components(separatedBy: ".").last! }
}
