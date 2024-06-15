//
//  GetImagesTarget.swift
//  GalleryApp-ImagesList
//
//  Created by Alexander Sivko on 14.06.24.
//

import GalleryApp_Network
import Moya

// MARK: - GetImagesTarget
enum GetImagesTarget {
    case getImages(page: Int)
}

// MARK: - BaseTargetType
extension GetImagesTarget: BaseTargetType {
    var baseURL: URL {
        URL(string: Consts.baseURL)!
    }
    
    var path: String {
        Consts.path
    }
    
    var method: Moya.Method {
        .get
    }
    
    var task: Moya.Task {
        switch self {
        case .getImages(let page):
            .requestParameters(
                parameters: [Consts.countPerPage: 30, Consts.page: page],
                encoding: URLEncoding.queryString
            )
        }
    }
}

// MARK: - Consts
extension GetImagesTarget {
    enum Consts {
        static let baseURL = "https://api.unsplash.com/"
        static let path = "photos"
        static let countPerPage = "per_page"
        static let page = "page"
    }
}
