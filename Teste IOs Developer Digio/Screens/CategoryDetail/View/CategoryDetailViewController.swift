//
//  CategoryDetailViewController.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 26/01/23.
//

import UIKit

class CategoryDetailViewController: UIViewController {

    private let lblTitle: UILabel = {
        let lblTitle = UILabel()
        lblTitle.text = "Nome Item"
        lblTitle.textColor = #colorLiteral(red: 0.1218487248, green: 0.1837033033, blue: 0.2947648168, alpha: 1)
        lblTitle.font = UIFont.boldSystemFont(ofSize: 18)
        return lblTitle
    }()
    private let imgItem : UIImageView = {
        let imgProduct = UIImageView()
        imgProduct.contentMode = .scaleAspectFit
        imgProduct.clipsToBounds = true
        imgProduct.borderRadius(size: 30)
        return imgProduct
    }()
    private let txtDescription: UITextView = {
        let txtDescription = UITextView()
        txtDescription.isEditable = false
        txtDescription.dataDetectorTypes = .link
        txtDescription.isScrollEnabled = false
        return txtDescription
    }()
    private let scrollView: UIScrollView = {
       let scrollView = UIScrollView()
       return scrollView
    }()
    var viewModel: CategoryDetailViewModel? {
        didSet {
            lblTitle.text = viewModel?.title
            if let urlImage = viewModel?.urlImage {
                imgItem.imageFromUrl(urlAdress: urlImage)
            }
            txtDescription.attributedText = viewModel?.description
                .convertHtmlToAttributedString(font: UIFont.systemFont(ofSize: 16), alignment: "justify")
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let uistackViewITem = UIStackView(arrangedSubviews: [lblTitle,imgItem,txtDescription])
        uistackViewITem.axis = .vertical
        uistackViewITem.distribution = .fill
        scrollView.addSubview(uistackViewITem)
        view.addSubview(scrollView)
        scrollView.backgroundColor = .white
        scrollView.anchor(topAnchor: (view.topAnchor,0),
                          leftAnchor: (view.leftAnchor,0),
                          rightAnchor: (view.rightAnchor,0),
                          bottomAnchor: (view.bottomAnchor,0))
        uistackViewITem.anchor(topAnchor: (view.safeAreaLayoutGuide.topAnchor,5),
                               leftAnchor: (view.leftAnchor,5),
                               rightAnchor: (view.rightAnchor,5),
                               bottomAnchor: nil)
        lblTitle.anchor(topAnchor: (uistackViewITem.topAnchor,0),
                                leftAnchor: (uistackViewITem.leftAnchor,0),
                                rightAnchor: (uistackViewITem.rightAnchor,0),
                                bottomAnchor: nil)
        imgItem.anchor(topAnchor: (lblTitle.bottomAnchor,5),
                               leftAnchor: (uistackViewITem.leftAnchor,0),
                               rightAnchor: (uistackViewITem.rightAnchor,0),
                               bottomAnchor: nil,
                               width: UIScreen.main.bounds.width  - 30, height: 150)
    }
}
