//
//  ViewController.swift
//  PhotoSearcher
//
//  Created by Tim Akhmetov on 04.12.2022.
//

import UIKit

class MainViewController: UIViewController {
    
    private lazy var photoTableView: UITableView = {
            let tableView = UITableView()
            tableView.rowHeight = 173
            tableView.backgroundColor = .specialCellBackground
            tableView.separatorColor = .specialLabel
            tableView.showsVerticalScrollIndicator = true
            tableView.translatesAutoresizingMaskIntoConstraints = false
            return tableView
    }()
    
    private lazy var sortBarButtonItem: UIBarButtonItem = {
        return UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal.decrease.circle"),
                                style: .plain,
                                target: self,
                                action: #selector(sortBarButtonTapped))
    }()
    
    private let errorLabel = UILabel(text: "SomeError",
                                     font: UIFont.boldSystemFont(ofSize: 20),
                                     color: .red,
                                     line: 1)
   
    private lazy var searchController = UISearchController()
    
    private var viewModel: MainViewModel?
    private var coordinator: Coordinator?
    
    private var tagsArray: [String] = []
    private var counter: Int = 0
    private var isPaging = true
    
    //MARK: - Override
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        errorLabel.isHidden = true
        if viewModel == nil {
            photoTableView.isHidden = true
        }
    }

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
        view.addSubview(errorLabel)
        
        
        let networkManager = NetworkManager()
        self.viewModel = MainViewModel(networkManager: networkManager)
        coordinator = Coordinator(viewControoler: self)
        
        photoTableView.register(PhotoTableViewCell.self,
                                forCellReuseIdentifier: Constants.CellsNames.photoTableViewCell)
    }
    
    //MARK: - SetDelegates
    
    private func setDelegates() {
        photoTableView.delegate = self
        photoTableView.dataSource = self
        
        searchController.searchBar.delegate = self
        searchController.searchBar.searchTextField.delegate = self
    }
    
    //MARK: - SetupNavigationBar
    
    private func setupNavigationBar() {
        let titleLabel = UILabel(text: "🌃 PhotoSearcher",
                                 font: UIFont.boldSystemFont(ofSize: 22),
                                 color: .specialLabel,
                                 line: 0)
        titleLabel.applyShadow(cornerRadius: 5)
        
        searchController.searchBar.placeholder = ""
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.rightBarButtonItem = sortBarButtonItem
        navigationItem.rightBarButtonItem?.isEnabled = false
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(customView: titleLabel)
        navigationItem.backButtonTitle = ""
        navigationItem.hidesSearchBarWhenScrolling = false

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.standardAppearance.backgroundColor = #colorLiteral(red: 0.1599434614, green: 0.165407896, blue: 0.1891466677, alpha: 1)
        navigationController?.navigationBar.scrollEdgeAppearance?.backgroundColor = #colorLiteral(red: 0.1599434614, green: 0.165407896, blue: 0.1891466677, alpha: 1)
    }
    
    private func removeAllAndReload() {
        self.counter = 0
        if let viewModel = viewModel {
            viewModel.items.removeAll()
            viewModel.sortedItems.removeAll()
            DispatchQueue.main.async { [weak self] in
                self?.searchController.searchBar.text = ""
                self?.photoTableView.reloadData()
                self?.errorLabel.isHidden = true
                self?.view.endEditing(true)
            }
        }
    }
    
    private func loadData() {
        self.errorLabel.isHidden = true
        if let viewModel = viewModel {
            viewModel.loadImageWhenTextChanges(tagsArray[counter]) {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.photoTableView.isHidden = false
                    self?.photoTableView.reloadData()
                    self?.counter += 1
                    self?.isPaging = true
                }
            } failureCompletion: { [weak self] error in
                DispatchQueue.main.async {
                    self?.errorLabel.isHidden = false
                    self?.errorLabel.text = error.rawValue
                }
            }
        }
    }
    
    private func createSortMethod(_ completion: @escaping (Items, Items) -> Bool) -> UIAction {
        return UIAction() { [weak self] action in
            if let viewModel = self?.viewModel {
                viewModel.sortedItems = viewModel.sortedItems.sorted(by: {
                    completion($0, $1)
                })
                DispatchQueue.main.async {
                    self?.photoTableView.reloadData()
                }
            }
        }
    }
    
    @objc private func sortBarButtonTapped(sender: UIBarButtonItem) {
        
        let alertController = UIAlertController(title: "", message: "Choose the sorting method:", preferredStyle: .actionSheet)
        let sortName = UIAlertAction(title: "Name", style: .default) { (action) in
            _ = self.createSortMethod({ lhs, rhs in
                lhs.title! < rhs.title!
            })
            self.photoTableView.reloadData()
        }
        
        let sortDate = UIAlertAction(title: "Date", style: .default) { (action) in
            _ = self.createSortMethod({ lhs, rhs in
                lhs.published! < rhs.published!
            })
            self.photoTableView.reloadData()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
        }
        alertController.addAction(sortName)
        alertController.addAction(sortDate)
        alertController.addAction(cancel)
        present(alertController, animated: true)
    }
}

extension MainViewController: UIScrollViewDelegate {
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let position = scrollView.contentOffset.y
        
        if position > self.photoTableView.contentSize.height - 100 - scrollView.frame.size.height {
            if isPaging {
                isPaging = false
                if counter == tagsArray.count {
                    return
                }
                loadData()
            }
        }
    }
}
//MARK: - UITableViewDelegates

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let viewModel = viewModel {
            return viewModel.items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.CellsNames.photoTableViewCell,
                                                       for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        cell.separatorInset.right = 16
        cell.separatorInset.left = 16
        
        if let viewModel = viewModel {
            cell.cellConfigure(viewModel.sortedItems[indexPath.row])
        }
        
    return cell
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let viewModel = viewModel {
            let item = viewModel.items[indexPath.row]
            coordinator?.showDetailViewController(for: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}


//MARK: - UISearchBarDelegate

extension MainViewController: UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        removeAllAndReload()
        return true
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
       
        if searchBar.isFirstResponder {
            guard let text = searchBar.text else { return }
            self.tagsArray = text.components(separatedBy: " ")
            navigationItem.rightBarButtonItem?.isEnabled = (searchText.count > 0 ? true : false)
            
            if searchText.isEmpty {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.view.endEditing(true)
                    self.removeAllAndReload()
                    return
                }
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        removeAllAndReload()
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            return
        }
        removeAllAndReload()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
        loadData()
    }
}

//MARK: - SetConstraints

extension MainViewController {
    
    private func setConstraints() {

        NSLayoutConstraint.activate([
            photoTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
            photoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            photoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            photoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
       
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0),
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0)
        ])
    }
}

