//
//  ImageCacheService.swift
//  SafariHighlighter
//
//  Created by Andrey Yakovlev on 14.05.2023.
//

import UIKit

protocol ImageCacheServiceProtocol: AnyObject {
    func loadCachedImage(for imageUrl: URL, completion: @escaping (UIImage?) -> Void)
    func save(image: UIImage, for imageUrl: URL)
}

final class ImageCacheService: ImageCacheServiceProtocol {
    
    // MARK: - Internal

    init() {
        let fileManager = FileManager.default
        let cacheDirectories = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        
        if let cacheDirectory = cacheDirectories.first {
            let cacheDirectory = cacheDirectory.appendingPathComponent("ImageCache")
            self.cacheDirectoryURL = cacheDirectory
            
            do {
                try fileManager.createDirectory(at: cacheDirectory, withIntermediateDirectories: true, attributes: nil)
            } catch let error {
                print("Error creating cache directory: \(error.localizedDescription)")
            }
        }
    }
    
    func save(image: UIImage, for imageUrl: URL) {
        guard let cacheDirectoryURL = self.cacheDirectoryURL else { return }
        
        DispatchQueue.global().async {
            let cacheFileURL = cacheDirectoryURL.appendingPathComponent(imageUrl.absoluteString.sha256())
            let imageData = image.pngData()
            
            do {
                try imageData?.write(to: cacheFileURL)
            } catch let error {
                print("Error writing to cache file: \(error.localizedDescription)")
            }
        }
    }
    
    
    func loadCachedImage(for imageUrl: URL, completion: @escaping (UIImage?) -> Void) {
        guard let cacheDirectoryURL = self.cacheDirectoryURL else {
            completion(nil); return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let cacheFileURL = cacheDirectoryURL.appendingPathComponent(imageUrl.absoluteString.sha256())
            guard let imageData = try? Data(contentsOf: cacheFileURL) else {
                completion(nil); return
            }
            
            let image = UIImage(data: imageData)
            
            DispatchQueue.main.async {
                completion(image)
            }
        }
    }
    
    // MARK: - Private
    
    private var cacheDirectoryURL: URL?
}
