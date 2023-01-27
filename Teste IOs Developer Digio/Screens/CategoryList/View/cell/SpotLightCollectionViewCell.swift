//
//  SpotLightViewCell.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import UIKit

class SpotLightCollectionViewCell: UICollectionViewCell {

    private let imgSpotLight : UIImageView = {
        let imgSpotLight = UIImageView()
        imgSpotLight.contentMode = .scaleAspectFill
        imgSpotLight.clipsToBounds = true
        imgSpotLight.borderRadius(size: 5)
        return imgSpotLight
    }()
    var spotLightCellViewModel: SpotLightCellViewModel? {
        didSet {
            if let bannerURL = spotLightCellViewModel?.bannerURL {
                imgSpotLight.imageFromUrl(urlAdress: bannerURL)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgSpotLight)
        imgSpotLight.anchor(topAnchor: (topAnchor,0),
                            leftAnchor: (leftAnchor,0),
                            rightAnchor: (rightAnchor,0),
                            bottomAnchor: (bottomAnchor,0))
        borderRadiusAndShadow()
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        imgSpotLight.image = nil
    }
}
