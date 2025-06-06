//
//  File.swift
//  FetchTakeHome
//
//  Created by Franco Miguel Guevarra on 6/3/25.
//

import SwiftUI

@MainActor
final class ImageCache {
    static let shared = ImageCache()
    
    private let cache = Cache<UIImage>()
    
    subscript(_ key: String) -> UIImage? {
        get { getImage(forKey: key) }
        set {
            if let newValue  {
                setImage(newValue, forKey: key)
            }
        }
    }

    func setImage(_ image: UIImage, forKey key: String) {
        cache.setValue(image, forKey: key)
    }
    
    func getImage(forKey key: String) -> UIImage? {
        return cache.value(forKey: key)
    }
    
    func clearCache() {
        cache.removeAllValues()
    }
}

struct CachedAsyncImage: View {
    
    var url: URL?
    
    @State private var result: Result<UIImage, Error>?
    @State private var hasLoaded: Bool = false
    
    init(url: URL? = nil) {
        self.url = url
    }
    
    var body: some View {
        switch result {
        case .success(let success):
            Image(uiImage: success)
                .resizable()
        case .failure(_):
            Rectangle()
                .foregroundColor(.gray)
                .overlay {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .foregroundColor(.secondary)
                }
                .onAppear {
                    Task { @MainActor in
                        await loadImage()
                    }
                }
        case nil:
            Rectangle()
                .foregroundColor(.gray)
                .overlay {
                    ProgressView()
                }
                .task {
                    await loadImage()
                }
        }
    }
    
    func loadImage() async {
        guard !hasLoaded else { return }
        hasLoaded = true
        
        guard let url = url else {
            result = .failure(URLError(.badURL))
            return
        }
        
        if let cachedImage = ImageCache.shared.getImage(forKey: url.absoluteString) {
            result = .success(cachedImage)
            return
        }
        
        if let uiImage = await resizeImage(at: url) {
            ImageCache.shared.setImage(uiImage, forKey: url.absoluteString)
            result = .success(uiImage)
        } else {
            result = .failure(URLError(.cannotDecodeContentData))
        }
    }

    func resizeImage(at url: URL) async -> UIImage? {
        await withCheckedContinuation { continuation in
            DispatchQueue.global(qos: .userInitiated).async {
                let options: [CFString: Any] = [
                    kCGImageSourceCreateThumbnailFromImageIfAbsent: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceShouldCacheImmediately: true,
                    kCGImageSourceThumbnailMaxPixelSize: 1000
                ]
                
                guard let imageSource = CGImageSourceCreateWithURL(url as NSURL, nil),
                      let cgImage = CGImageSourceCreateThumbnailAtIndex(imageSource, 0, options as CFDictionary) else {
                    continuation.resume(returning: nil)
                    return
                }
                
                let uiImage = UIImage(cgImage: cgImage)
                continuation.resume(returning: uiImage)
            }
        }
    }
}
