////
////  ViewController.swift
////  Movee
////
////  Created by jjurlits on 10/27/20.
////
//
//import UIKit
//import SDWebImage
//
//class ViewController: UITableViewController {
//    let tmdb = TMDBClient()
//    var movies: Movies?
//    var genres: Genres?
//    var fetching = false
//    
//    func updateUI() {
//        guard let movies = movies else { return }
//        var indices = movies.lastUpdated.compactMap { (i) -> IndexPath in
//            return IndexPath(row: i, section: 0)
//        }
//        let placeholderIndex = IndexPath(row: movies.lastUpdated.max()! + 1, section: 0)
//        indices.append(placeholderIndex)
//        
//        let lastRowIndex = tableView.numberOfRows(inSection: 0) - 1
//        self.tableView.beginUpdates()
//        self.tableView.deleteRows(at: [IndexPath(row: lastRowIndex, section: 0)], with: .fade)
//        self.tableView.insertRows(at: indices, with: .fade)
//       
//        self.tableView.endUpdates()
//    }
//    
//    func getMoviesData(start: Int, completion: @escaping () -> ()) {
//        guard fetching == false else { return }
//        fetching = true
//        let page = (movies != nil) ? movies!.page(where: start) : 1
//        tmdb.getPopularMovies(page: page) { result in
//            switch result {
//            case .success(let movies):
//                if self.movies == nil {
//                    self.movies = Movies(from: movies)
//                } else {
//                    self.movies?.update(with: movies)
//                }
//                self.fetching = false
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            completion()
//        }
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        navigationItem.title = "Popular Movies"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        
//        tableView.register(MovieCell.self, forCellReuseIdentifier: "MovieCell")
//        tableView.register(PlaceholderCell.self, forCellReuseIdentifier: "PlaceholderCell")
//        
//        let group = DispatchGroup()
//        
//        group.enter()
//        tmdb.getGenresList { result in
//            self.genres = try? result.get()
//            group.leave()
//        }
//        
//        group.enter()
//        getMoviesData(start: 0) {
//            group.leave()
//        }
//        
//        group.notify(queue: .main) {
//            self.updateUI()
//        }
//    }
//    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 182
//    }
//    
//    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let vc = MovieDetailsController()
//        
//        if let movie = movies?.at(indexPath.row) {
//            let movieViewModel = MovieViewModel(movie: movie, genres: genres)
//            vc.movieViewModel = movieViewModel
//        }
////        vc.movie = movies?.at(indexPath.row)
////        vc.genres = genres
//        navigationController?.pushViewController(vc, animated: true)
//    }
//    
//   
//    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let movies = movies else { return tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell")! }
//        //print(movies.loaded)
//        if !movies.isPreloaded(index: indexPath.row) {
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PlaceholderCell")
//            if !fetching {
//                getMoviesData(start: indexPath.row) {
//                    tableView.reloadData()
//                    //self.updateUI()
//                }
//            }
//            return cell!
//        }
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: "MovieCell") as? MovieCell else {
//            fatalError()
//        }
//        
//        
//        
//        guard let movie = movies.at(indexPath.row) else { return cell }
//        let genresString = genres?.string(from: movie.genre_ids) ?? ""
//        
////        cell.configureWithData(title: movie.title,
////                               overview: movie.overview,
////                               poster: movie.isPosterAvaiable,
////                               rating: movie.vote_average ?? 0.0,
////                               genres: genresString,
////                               year: movie.release_date)
//        
//        cell.tag = indexPath.row
//        
//        cell.ratingLabel.text = "\(movie.vote_average ?? 0.0)"
//        
//        guard let posterPath = movie.poster_path else { return cell }
//        let posterURL = URL(string: "https://image.tmdb.org/t/p/w500/\(posterPath)")
//        
//        cell.posterImageView.sd_setImage(with: posterURL, placeholderImage: UIImage(named: "placeholder"), options: [.progressiveLoad, .scaleDownLargeImages])
//        
//        
//        return cell
//    }
//    
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        guard let movies = movies else { return 1 }
//        return movies.total == movies.loaded ? movies.loaded : movies.loaded + 1
//    }
//
//
//}
//
