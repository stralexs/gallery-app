//
//  GetImagesRequest.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import GalleryApp_Network
import GalleryApp_Models
import Moya

// MARK: - GetImagesRequest
struct GetImagesRequest: Request {
    
    // MARK: Properties
    typealias ResponseType = [ImageDTO]
    let target: MultiTarget
    
    // MARK: Initializer
    init(requestTarget: GetImagesTarget) {
        self.target = MultiTarget(requestTarget)
    }
}
