//
//  MovieDetailsTableViewController.swift
//  Movee
//
//  Created by jjurlits on 11/12/20.
//
//
//import UIKit
//
//fileprivate let movieCellId = "movieCell"
//fileprivate let placeholderCellId = "placeholderCell"
//
//class PopularMoviesController: UITableViewController, PopularMoviesViewModelDelegate {
//    var viewModel: PopularMoviesViewModel!
//
//    func didFinishLoading() {
//        tableView.reloadData()
//    }
//    
//    func setupTableView() {
//        tableView.register(MovieCell.self, forCellReuseIdentifier: movieCellId)
//        tableView.register(PlaceholderCell.self, forCellReuseIdentifier: placeholderCellId)
//
//        tableView.rowHeight = UITableView.automaticDimension
//        tableView.estimatedRowHeight = 182
//    }
//    
//    func setupNavigationItem() {
//        navigationItem.title = "Popular Movies"
//        navigationController?.navigationBar.prefersLargeTitles = true
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupTableView()
//        setupNavigationItem()
//        navigationItem.title = "Popular Movies"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        viewModel = PopularMoviesViewModel()
//        viewModel?.delegate = self
//    }
//
//    // MARK: - Table view data source
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return viewModel.rowsCount
//    }
//
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let movieViewModel = viewModel.movieViewModel(at: indexPath.row) else {
//            return tableView.dequeueReusableCell(withIdentifier: placeholderCellId, for: indexPath)
//        }
//        
//        let cell = tableView.dequeueReusableCell(withIdentifier: movieCellId, for: indexPath) as! MovieCell
//
//        movieViewModel.configure(cell)
//        
//        return cell
//    }
//    
//    // MARK: - Table view delegate
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = MovieDetailsController()
//        navigationController?.navigationItem.largeTitleDisplayMode = .never
//
//        if let movieViewModel = viewModel.movieViewModel(at: indexPath.row) {
//            vc.movieViewModel = movieViewModel
//        }
//        
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//    
//}
