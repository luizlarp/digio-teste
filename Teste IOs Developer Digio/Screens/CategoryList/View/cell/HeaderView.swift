//
//  HeaderView.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import UIKit

class HeaderView: UIView {
    var collectionViewSpotLight : UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 50, height: 180)
        layout.sectionInset = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
        let collectionView = UICollectionView(frame: UIScreen.main.bounds, collectionViewLayout: layout)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.register(SpotLightCollectionViewCell.self,
                                forCellWithReuseIdentifier: SpotLightCollectionViewCell.identifier)
        return collectionView
    }()
    private let lblDigio: UILabel = {
        let lblDigio = UILabel()
        lblDigio.text = "digio"
        lblDigio.font = UIFont.boldSystemFont(ofSize: 18)
        lblDigio.textColor = #colorLiteral(red: 0.1218487248, green: 0.1837033033, blue: 0.2947648168, alpha: 1)
        return lblDigio
    }()
    private let lblCash: UILabel = {
        let lblCash = UILabel()
        lblCash.text = "Cash"
        lblCash.font = UIFont.boldSystemFont(ofSize: 18)
        lblCash.textColor = #colorLiteral(red: 0.4745097756, green: 0.4745098948, blue: 0.4745098948, alpha: 1)
        return lblCash
    }()
    private let imgDigioCahs: UIImageView = {
        let imgView = UIImageView()
        imgView.contentMode = .scaleAspectFit
        imgView.clipsToBounds = true
        imgView.isUserInteractionEnabled = true
        imgView.borderRadius(size: 20)
        return imgView
    }()
    var categoryViewModel: CategoryViewModel? {
        didSet {
            collectionViewSpotLight.reloadData()
            categoryViewModel?.fillDataCash = { [weak self] cashViewModel in
                guard let self = self else {return}
                DispatchQueue.main.async {
                    self.imgDigioCahs.imageFromUrl(urlAdress: cashViewModel.bannerURL)
                }
            }
        }
    }
    @objc func imgDigiCardTapped(sender: UITapGestureRecognizer) {
        guard let cashViewModel = categoryViewModel?.cashViewModel else {return}
        categoryViewModel?.openCategoryDetail?(cashViewModel.title,
                                               cashViewModel.bannerURL,
                                               cashViewModel.description)
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(collectionViewSpotLight)
        let emptyView = UIView()
        emptyView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        let stackViewDigioCashTitle = UIStackView(arrangedSubviews: [lblDigio,
                                                                     lblCash, emptyView])
        stackViewDigioCashTitle.axis = .horizontal
        stackViewDigioCashTitle.spacing = 5
        let stackViewDigioImage = UIStackView(arrangedSubviews: [stackViewDigioCashTitle,
                                                                 imgDigioCahs])
        stackViewDigioImage.axis = .vertical
        stackViewDigioImage.spacing = 10
        addSubview(stackViewDigioImage)
        collectionViewSpotLight.dataSource = self
        collectionViewSpotLight.delegate = self
        collectionViewSpotLight.anchor(topAnchor: (topAnchor, 10),
                                       leftAnchor: (leftAnchor,0),
                                       rightAnchor: (rightAnchor, 5),
                                       bottomAnchor: nil,
                                       height: 200)
        stackViewDigioImage.anchor(topAnchor: (collectionViewSpotLight.bottomAnchor, 15),
                                   leftAnchor: (leftAnchor, 10),
                                   rightAnchor: (rightAnchor,10),
                                   bottomAnchor: (bottomAnchor,5),
                                   height:150)
        imgDigioCahs.addGestureRecognizer(UITapGestureRecognizer(target: self,
                                                                 action: #selector(self.imgDigiCardTapped)))
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
extension HeaderView : UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryViewModel?.spotLightCellsViewModel.count ?? 0
    }
    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let identifier = SpotLightCollectionViewCell.identifier
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: identifier,
                                                            for: indexPath) as? SpotLightCollectionViewCell
        else {
            fatalError("xib does not exists")
        }
        cell.spotLightCellViewModel = categoryViewModel?.getSpotLightCellViewModel(at: indexPath)
        return cell
    }
}

extension HeaderView : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let spotLightViewCell = self.categoryViewModel?.getSpotLightCellViewModel(at: indexPath)
        guard let spotLightViewCell = spotLightViewCell else {return}
        self.categoryViewModel?.openCategoryDetail?(spotLightViewCell.name,
                                                    spotLightViewCell.bannerURL,
                                                    spotLightViewCell.description)
    }
}
