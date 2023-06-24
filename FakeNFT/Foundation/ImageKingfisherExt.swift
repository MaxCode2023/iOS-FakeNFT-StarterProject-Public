//
//  ImageKingfisherExt.swift
//  FakeNFT
//
//  Created by macOS on 24.06.2023.
//

import Kingfisher
import UIKit

extension UIImageView {
    func loadImage(url: URL, cornerRadius: CGFloat) {
        let processor = RoundCornerImageProcessor(cornerRadius: cornerRadius)
        self.kf.setImage(
            with: url,
            options: [.processor(processor), .cacheSerializer(FormatIndicatedCacheSerializer.png)])
    }
}
