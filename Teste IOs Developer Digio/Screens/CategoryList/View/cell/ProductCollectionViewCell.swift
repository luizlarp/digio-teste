//
//  ProductCollectionViewCell.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import UIKit

class ProductCollectionViewCell: UICollectionViewCell {

    private let imgProduct : UIImageView = {
        let imgProduct = UIImageView()
        imgProduct.contentMode = .scaleAspectFill
        imgProduct.clipsToBounds = true
        imgProduct.borderRadius(size: 5)
        return imgProduct
    }()
    var productCellViewModel: ProductCellViewModel? {
        didSet {
            if let imageURL = productCellViewModel?.imageURL {
                imgProduct.imageFromUrl(urlAdress: imageURL)
            }
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(imgProduct)
        borderRadiusAndShadow()
        imgProduct.anchorCenter(centerX: centerXAnchor,
                                centerY: centerYAnchor,
                                width: 50,
                                height: 50)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func prepareForReuse() {
        imgProduct.image = nil
    }

}
