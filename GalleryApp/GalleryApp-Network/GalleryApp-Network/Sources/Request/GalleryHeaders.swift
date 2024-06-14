//
//  GalleryHeaders.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Foundation

// MARK: - GalleryHeaders
enum GalleryHeaders {
    static let dictionary = [Consts.authKey: Consts.authValue]
}

// MARK: - Consts
private extension GalleryHeaders {
    enum Consts {
        static let authKey = "Authorization"
        static let authValue = "Client-ID jXYiLA8HniWT4DPcAXwO6hkWl2ZzPjwq3jAUjCXHcKM"
    }
}
