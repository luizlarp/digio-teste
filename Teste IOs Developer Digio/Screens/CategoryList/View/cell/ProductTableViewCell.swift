//
//  ProductTableViewCell.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import UIKit

class ProductTableViewCell: UITableViewCell {
    private let lblTitle: UILabel = {
        let lblTitle = UILabel()
        lblTitle.text = "Produtos"
        lblTitle.textColor = #colorLiteral(red: 0.1218487248, green: 0.1837033033, blue: 0.2947648168, alpha: 1)
        lblTitle.font = UIFont.boldSystemFont(ofSize: 18)
        return lblTitle
    }()
    private var collectionViewProduct : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 15, bottom: 5, right: 5)
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(ProductCollectionViewCell.self,
                                forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
        return collectionView
    }()
    var categoryViewModel: CategoryViewModel? {
        didSet {
            collectionViewProduct.reloadData()
        }
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        let stackView = UIStackView(arrangedSubviews: [lblTitle,collectionViewProduct])
        stackView.axis = .vertical
        addSubview(stackView)
        sendSubviewToBack(contentView)
        collectionViewProduct.dataSource = self
        collectionViewProduct.delegate = self
        stackView.anchor(topAnchor: (topAnchor,20),
                         leftAnchor: (leftAnchor,10),
                         rightAnchor: (rightAnchor,0),
                         bottomAnchor: (bottomAnchor,0),
                         height: 150)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension ProductTableViewCell : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel?.productCellsViewModel.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = ProductCollectionViewCell.identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                            for: indexPath) as? ProductCollectionViewCell
        else {
            fatalError("xib does not exists")
        }
        cell.productCellViewModel = categoryViewModel?.getProductCellViewModel(at: indexPath)
        return cell
    }
}
extension ProductTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let productViewCell = self.categoryViewModel?.getProductCellViewModel(at: indexPath)
        guard let productViewCell = productViewCell else {return}
        self.categoryViewModel?.openCategoryDetail?(productViewCell.name,
                                                    productViewCell.imageURL,
                                                    productViewCell.description)
    }
}
