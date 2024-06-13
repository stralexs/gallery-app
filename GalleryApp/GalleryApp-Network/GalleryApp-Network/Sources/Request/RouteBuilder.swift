//
//  RouteBuilder.swift
//  GalleryApp-Network
//
//  Created by Alexander Sivko on 13.06.24.
//

import Foundation

// MARK: - RouteBuilder
struct RouteBuilder {
    static let baseURL = Consts.baseURL
    static let headers = [Consts.authKey: Consts.authValue]
}

// MARK: - Consts
private extension RouteBuilder {
    enum Consts {
        static let baseURL = "https://api.unsplash.com/"
        static let authKey = "Authorization"
        static let authValue = "Client-ID jXYiLA8HniWT4DPcAXwO6hkWl2ZzPjwq3jAUjCXHcKM"
    }
}
