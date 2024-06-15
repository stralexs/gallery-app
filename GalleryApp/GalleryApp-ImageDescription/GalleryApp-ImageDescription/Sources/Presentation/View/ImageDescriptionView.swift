//
//  ImageDescriptionView.swift
//  GalleryApp-ImageDescription
//
//  Created by Alexander Sivko on 15.06.24.
//

import SwiftUI
import Factory
import Kingfisher
import GalleryApp_Models

// TODO: Remove public when navigation is ready

// MARK: - ImageDescriptionView
public struct ImageDescriptionView<ViewModel: ImageDescriptionViewModel>: View {
    
    // MARK: Properties
    @StateObject private var viewModel: ViewModel
    @State private var currentImage: Int
    
    // MARK: Initializer
    public init(
        viewModel: ViewModel,
        images: [GalleryApp_Models.Image],
        selectedImage: Int
    ) {
        _viewModel = StateObject(wrappedValue: viewModel)
        viewModel.setImages(images)
        currentImage = selectedImage
    }
    
    // MARK: Body
    public var body: some View {
        VStack(spacing: Consts.Layouts.stackSpacing) {
            ZStack {
                tabView
                    .frame(height: Consts.Layouts.tabViewHeight)
                downloadMoreButton
                    .padding(.horizontal)
                heartImage
                    .padding()
            }
            SUIPageControl(
                numberOfPages: viewModel.images.count,
                currentPage: $currentImage
            )
            Text(viewModel.images[currentImage].description)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .default).italic())
                .animation(.easeInOut, value: currentImage)
            Text(viewModel.images[currentImage].createdAt)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .default).italic())
                .animation(.easeInOut, value: currentImage)
            Text(Consts.Texts.byKeyword + " " + viewModel.images[currentImage].creatorName)
                .frame(maxWidth: .infinity, alignment: .center)
                .multilineTextAlignment(.center)
                .font(.system(.body, design: .default).italic())
                .animation(.easeInOut, value: currentImage)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(Consts.Layouts.backgroundColorOpacity))
    }
}

// MARK: - Components
private extension ImageDescriptionView {
    var tabView: some View {
        TabView(selection: $currentImage) {
            ForEach(viewModel.images.indices, id: \.self) { index in
                KFImage(viewModel.images[index].sizeURL.full)
                    .resizable()
                    .placeholder {
                        ProgressView()
                            .controlSize(.large)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    .aspectRatio(contentMode: .fit)
                    .tag(index)
                    .clipShape(RoundedRectangle(cornerRadius: Consts.Layouts.imageCornerRadius))
            }
            .padding(.horizontal)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
    }
    
    var downloadMoreButton: some View {
        HStack {
            Spacer()
            Button {
                viewModel.getMoreImages()
            } label: {
                Image(systemName: Consts.Texts.buttonImageName)
                    .font(.system(size: 45))
                    .foregroundStyle(Color.gray)
            }
            .opacity(currentImage == (viewModel.images.count - 1) ? 1: 0)
            .disabled(currentImage != viewModel.images.count - 1)
            .animation(.easeInOut, value: currentImage)
        }
    }
    
    var heartImage: some View {
        VStack {
            Spacer()
            HStack {
                Spacer()
                ZStack {
                    Image(systemName: Consts.Texts.heartImageName)
                        .font(.system(size: 45))
                        .foregroundStyle(Color.black)
                    Image(systemName: Consts.Texts.heartImageName)
                        .font(.system(size: 40))
                        .foregroundStyle(Color.red)
                }
            }
        }
    }
}

// MARK: - Consts
private extension ImageDescriptionView {
    enum Consts {
        enum Layouts {
            static var backgroundColorOpacity: CGFloat { 0.2 }
            static var stackSpacing: CGFloat { 10 }
            static var imageCornerRadius: CGFloat { 10 }
            static var tabViewHeight: CGFloat { UIScreen.main.bounds.height / 1.5 }
        }
        
        enum Texts {
            static var byKeyword: String { "by" }
            static var heartImageName: String { "heart.fill" }
            static var buttonImageName: String { "plus.circle.fill" }
        }
    }
}

// MARK: - Preview
#Preview {
    ImageDescriptionView(viewModel: DefaultImageDescriptionViewModel(), images: [
        GalleryApp_Models.Image(
            id: "CVbr5RR0yac",
            description: "a living room with a chair and a potted plant",
            createdAt: "06 11 2024",
            creatorName: "Julie Guzal",
            sizeURL: .init(
                small: "https://images.unsplash.com/photo-1718070477385-eed35e367ec8?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwxfHx8fHx8Mnx8MTcxODQ1MDc5OXw&ixlib=rb-4.0.3&q=80&w=400", 
                full: "https://images.unsplash.com/photo-1718070477385-eed35e367ec8?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwxfHx8fHx8Mnx8MTcxODQ1MDc5OXw&ixlib=rb-4.0.3&q=85"
            )
        ),
        GalleryApp_Models.Image(
            id: "GDs4VOWS5wI",
            description: "an aerial view of a city at night",
            createdAt: "14 06 2024",
            creatorName: "Michael Pointner",
            sizeURL: .init(
                small: "https://images.unsplash.com/photo-1717852613749-2104b6bd6b39?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwzMnx8fHx8fDJ8fDE3MTg0NTUxODZ8&ixlib=rb-4.0.3&q=80&w=400",
                full: "https://images.unsplash.com/photo-1717852613749-2104b6bd6b39?crop=entropy&cs=srgb&fm=jpg&ixid=M3w2MjEwOTV8MHwxfGFsbHwzMnx8fHx8fDJ8fDE3MTg0NTUxODZ8&ixlib=rb-4.0.3&q=85"
            )
        )
    ], selectedImage: 0)
}
