//
//  ViewController.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private let photoTableView: UITableView = {
        let tableView = UITableView()
        tableView.rowHeight = 150
        tableView.backgroundColor = .specialCellBackground
        tableView.separatorColor = .specialLabel
        tableView.showsVerticalScrollIndicator = false
        tableView.translatesAutoresizingMaskIntoConstraints = false
        return tableView
    }()
   
    private let searchController = UISearchController()
    private var coordinator: Coordinator?
    
    //MARK: - ViewDidLoad

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setDelegates()
        setupNavigationBar()
        setConstraints()
    }
    
    //MARK: - SetupViews
    
    private func setupViews() {
        view.backgroundColor = #colorLiteral(red: 0.09410236031, green: 0.09412645549, blue: 0.09410081059, alpha: 1)
        view.addSubview(photoTableView)
        
        coordinator = Coordinator(viewControoler: self)
        photoTableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: Constants.CellsNames.photoTableViewCell)
    }
    
    //MARK: - SetDelegates
    
    private func setDelegates() {
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        searchController.searchBar.delegate = self
    }
    
    //MARK: - SetupNavigationBar
    
    private func setupNavigationBar() {
        let titleLabel = UILabel(text: "PhotoSearcher",
                                 font: UIFont.boldSystemFont(ofSize: 22),
                                 color: .specialLabel,
                                 line: 0)
        
        searchController.searchBar.placeholder = "Search photo..."
        navigationItem.searchController = searchController
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.searchController?.hidesNavigationBarDuringPresentation = false
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = #colorLiteral(red: 0.1599434614, green: 0.165407896, blue: 0.1891466677, alpha: 1)
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = #colorLiteral(red: 0.1599434614, green: 0.165407896, blue: 0.1891466677, alpha: 1)
    }
}

//MARK: - UITableViewDelegates

extension MainViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsNames.photoTableViewCell,
                                                       for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        cell.separatorInset.right = 16
    return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        coordinator?.showDetailViewController()
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - UISearchBarDelegate
extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
       
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}



//MARK: - SetConstraints

extension MainViewController {
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            photoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            photoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            photoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            photoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        ])
    }
}

