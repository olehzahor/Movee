//
//  ExploreController.swift
//  Movee
//
//  Created by jjurlits on 12/11/20.
//

import Foundation

class DiscoverController {
    private(set) var lists = [DiscoverListItem]()
    private(set) var isNested = false
    private(set) var name: String?
    
    func moved(to list: DiscoverListItem) -> DiscoverController? {
        return DiscoverController(lists: list.nestedLists, isNested: true, name: list.name)
    }
    
    init(lists: [DiscoverListItem], isNested: Bool = false, name: String? = nil) {
        self.lists = lists
        self.isNested = isNested
        self.name = name
    }
}


//extension DiscoverController {
//    class List: Hashable {
//        static func == (lhs: DiscoverController.List, rhs: DiscoverController.List) -> Bool {
//            lhs.title == rhs.title
//        }
//
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(title)
//        }
//
//        var title: String
//        var nestedLists = [List]()
//        var moviesController: MoviesListController?
//
//        var isNested: Bool {
//            return !nestedLists.isEmpty
//        }
//
//        init(title: String, filter: Filter) {
//            self.title = title
//            self.moviesController = MoviesListController.filteredList(filter: filter, title: title)
//        }
//
//        init(title: String, nestedLists: [List]) {
//            self.title = title
//            self.nestedLists = nestedLists
//        }
//
//        init(moviesController: MoviesListController) {
//            self.title = moviesController.title
//            self.moviesController = moviesController
//        }
//    }
//
//    enum ListItemType {
//        case filtered, nested, custom
//    }
//}
//var savedLists: [List] {
//        var lists = [
//            DiscoverListItem(name: "Top Movies of All Time",
//                             path: "discover/movie",
//                             query: "vote_count.gte=7000&sort_by=vote_average.desc"),
//            DiscoverListItem(name: "Best Movies of 2021",
//                             path: "discover/movie",
//                             query: "primary_release_date.lte=2021-12-31&vote_average.gte=6&primary_release_date.gte=2021-01-01&sort_by=vote_count.desc"),
//            DiscoverListItem(name: "Best Movies of 2020",
//                             path: "discover/movie",
//                             query: "primary_release_date.lte=2020-12-31&vote_average.gte=6&primary_release_date.gte=2020-01-01&sort_by=vote_count.desc"),
//            DiscoverListItem(name: "Greatest Movies of 21st Century",
//                             path: "discover/movie",
//                             query: "sort_by=vote_average.desc&primary_release_date.lte=2099-12-31&primary_release_date.gte=2000-01-01&vote_count.gte=3000"),
//        ]
//
//        let genreLists = TMDBClient.shared.genres?.genres.compactMap {
//            DiscoverListItem(name: "Top \($0.name) Movies", path: "discover/movie", query: "with_genres=\($0.id)&sort_by=vote_count.desc" )
//        } ?? []
//
//        lists.append(DiscoverListItem(name: "Top by Genre", nestedLists: genreLists))
//        guard let json = try? JSONEncoder().encode(lists) else { return [] }
//        print(String(data: json, encoding: .utf8))
////        let json = """
////            [
////                {
////                    "name": "Top Movies of All Time",
////                    "path": "discover/movie",
////                    "query": "vote_count.gte=10000&sort_by=vote_average.desc"
////                },
////            ]
////        """
//        let decoder = JSONDecoder()
//        let items = try? decoder.decode([DiscoverListItem].self, from: json)
//
//        if let items = items {
//            return items.compactMap() { $0.list }
//        } else { return [] }
//    }
//extension DiscoverController {
//
//
//    private func createTopRatedList() -> List {
//        let title = "Top Movies of All Time"
//
//        var filter = Filter()
//        filter.sortBy = .voteAverageDescending
//        filter.votes.min = 10000
//
//        return List(title: title, filter: filter)
//    }
//
//    private func createYearTopRatedList(year: Int) -> List {
//        let title = "Best Movies of \(year)"
//
//        let startDate = Calendar.current.date(from: DateComponents(year: year, month: 1, day: 1))
//        let endDate = Calendar.current.date(from: DateComponents(year: year, month: 12, day: 31))
//
//        var filter = Filter()
//
//        if let startDate = startDate, let endDate = endDate {
//            filter.primaryReleaseDate = startDate ... endDate
//        }
//
//        filter.sortBy = .voteCountDescending
//        filter.rating.min = 6
//
//        return List(title: title, filter: filter)
//    }
//
//    private func createPreviousYearTopRatedList() -> List {
//        let year = Calendar.current.component(.year, from: Date()) - 1
//        return createYearTopRatedList(year: year)
//    }
//
//    private func createCurrentYearTopRatedList() -> List {
//        let year = Calendar.current.component(.year, from: Date())
//        return createYearTopRatedList(year: year)
//    }
//
//    private func create21TopRatedList() -> List {
//        let title = "Greatest Movies of 21st Century"
//        let date = Calendar.current.date(from: DateComponents(year: 2000, month: 1, day: 1))
//        var filter = Filter()
//        filter.primaryReleaseDate = date! ... Date()
//        filter.sortBy = .voteAverageDescending
//        filter.votes.min = 3000
//
//        return List(title: title, filter: filter)
//    }
//}
//    var list: DiscoverController.List {
//        if nestedLists.isEmpty, let path = path, let query = query {
//            let controller = MoviesListController.customList(
//                title: name, path: path, query: query)
//            return DiscoverController.List(moviesController: controller)
//        } else {
//            let lists: [DiscoverController.List] = nestedLists.compactMap {
//                guard let path = $0.path, let query = $0.query else { return nil }
//                let controller = MoviesListController.customList(title: $0.name, path: path, query: query)
//                return DiscoverController.List(moviesController: controller)
//            }
//            return DiscoverController.List(title: name, nestedLists: lists)
//        }
//    }
