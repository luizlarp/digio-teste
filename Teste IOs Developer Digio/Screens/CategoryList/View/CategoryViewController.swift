//
//  CategoryViewController.swift
//  Teste IOs Developer Digio
//
//  Created by Luiz on 25/01/23.
//

import UIKit

class CategoryViewController: UIViewController {
    let tableView: UITableView =
    {
        let table = UITableView()
        table.separatorColor = .white
        table.allowsSelection = false
        table.tableHeaderView = HeaderView()
        table.register(ProductTableViewCell.self,
                       forCellReuseIdentifier: ProductTableViewCell.identifier)
        return table
    }()
    lazy var viewModel = {
        CategoryViewModel(categoryServiceProtocol: CategoryService())
    }()
    var spinner = UIActivityIndicatorView(style: .gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        addGreetingNavigationItem()
        initView()
        initViewModel()
    }
    func addGreetingNavigationItem() {
        let lblTitle: UILabel = {
            let lblTitle = UILabel()
            lblTitle.text = "Olá, Luiz Augusto"
            lblTitle.textColor = #colorLiteral(red: 0.1218487248, green: 0.1837033033, blue: 0.2947648168, alpha: 1)
            lblTitle.font = UIFont.boldSystemFont(ofSize: 16)
            return lblTitle
        }()
        let stackViewGreeting = UIStackView(arrangedSubviews:
                                                [UIImageView(image: UIImage(named: "AppIcon")), lblTitle])
        stackViewGreeting.spacing = 5
        stackViewGreeting.axis = .horizontal
        navigationItem.leftBarButtonItem = UIBarButtonItem(customView: stackViewGreeting)
    }
    func initView() {
        view.addSubview(tableView)
        view.addSubview(spinner)
        tableView.dataSource = self
        tableView.anchor(topAnchor: (view.topAnchor,0),
                         leftAnchor: (view.leftAnchor,0),
                         rightAnchor: (view.rightAnchor,0),
                         bottomAnchor: (view.bottomAnchor,0),
                         enableInsets: false)
        spinner.anchorCenter(centerX: view.centerXAnchor, centerY: view.centerYAnchor)
    }
    func initViewModel() {
        viewModel.showMessage = { [weak self] message in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                AlertWarning.alert(title: "Warning!", msgDesc: message, viewController: self)
            }
        }
        viewModel.reloadDataTable = { [weak self]  in
            guard let self = self else {return}
            DispatchQueue.main.async {
                self.spinner.stopAnimating()
                self.tableView.reloadData()
            }
        }
        viewModel.reloadSpotLightCollection = { [weak self]  in
            guard let self = self else {return}
            DispatchQueue.main.async {
                if let headerTableView = self.tableView.tableHeaderView as? HeaderView {
                    headerTableView.collectionViewSpotLight.reloadData()
                }
            }
        }
        viewModel.openCategoryDetail = { [weak self] (titleItem, urlImage, description) in
            guard let self = self else {return}
                let categoryDetailViewController = CategoryDetailViewController()
                let categoryDetailViewModel = CategoryDetailViewModel(title: titleItem,
                                                                      description: description,
                                                                      urlImage: urlImage)
                categoryDetailViewController.viewModel = categoryDetailViewModel
                self.navigationController?.pushViewController(categoryDetailViewController, animated: true)
        }
        if let headerView = tableView.tableHeaderView as? HeaderView {
            headerView.categoryViewModel = viewModel
        }
        spinner.startAnimating()
        viewModel.getCategory()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = self.tableView.tableHeaderView else {
            return
        }
        let width = self.tableView.bounds.size.width
        let height = UIView.layoutFittingCompressedSize.height
        let size = headerView.systemLayoutSizeFitting(CGSize(width: width,height: height))
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            self.tableView.tableHeaderView = headerView
        }
    }
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let idenfitier = ProductTableViewCell.identifier
        guard let cell = tableView.dequeueReusableCell(withIdentifier: idenfitier,
                                                       for: indexPath) as? ProductTableViewCell
        else {
            fatalError("xib does not exists")
        }
        cell.categoryViewModel = viewModel
        return cell
    }
}
