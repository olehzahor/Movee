////
////  FilterController.swift
////  Movee
////
////  Created by jjurlits on 12/14/20.
////
//
//import Foundation
//
//enum FilterSection: String {
//    typealias Option = FilterController.Option
//    case genres = "Genres"
//    case rating = "Rating"
//    case votes = "Votes Count"
//    case runtime = "Runtime"
//    case dates = "Release Date"
//    
//    var title: String {
//        return self.rawValue
//    }
//    
//    func options(controlledBy controller: FilterController) -> [Option] {
//        switch self {
//        case .genres:
//            return controller.genresOptions
//        case .rating:
//            return controller.ratingOptions
//        case .votes:
//            return controller.votesCountOptions
//        case .runtime:
//            return controller.runtimeOptions
//        case .dates:
//            return controller.datesOptions
//        default:
//            return []
//        }
//    }
//}
//
////protocol UDPersistent {
////    var defaultsKey: String { get set }
////    func loadData<T: Codable>() -> T?
////    func save<T: Codable>(_ object: T)
////}
////
////extension UDPersistent {
////    func loadData<T: Codable>() -> T? {
////        let decoder = JSONDecoder()
////        let defaults = UserDefaults.standard
////        if let savedObject = defaults.object(forKey: defaultsKey) as? Data {
////            if let loadedObject = try? decoder.decode(T.self, from: savedObject) {
////                return loadedObject
////            }
////        }
////        return nil
////    }
////
////    func save<T: Codable>(_ object: T) {
////        let encoder = JSONEncoder()
////        let defaults = UserDefaults.standard
////        if let encoded = try? encoder.encode(object) {
////            defaults.set(encoded, forKey: defaultsKey)
////        }
////    }
////}
////
//
//class FilterController {
//    //typealias T = Filter
//
//    
//    public var shortGenres = true
//    private(set) var filter = Filter()
//    private(set) var selectedOptions: SelectedOptions = SelectedOptions() {
//        didSet {
//            filter.withGenres = selectedOptions.includedGenres.compactMap { $0.id }
//            filter.withoutGenres = selectedOptions.excludedGenres.compactMap { $0.id }
//            filter.rating.min = selectedOptions.lowerRating
//            filter.votes.min = selectedOptions.lowerVotesCount
//            filter.runtime = selectedOptions.runtimeRange
//            if let minDate = selectedOptions.minDate,
//               let maxDate = selectedOptions.maxDate {
//                filter.releaseDate = minDate...maxDate
//            }
//        }
//    }
//    
//    private var genres = [Genre]()
//    private var ratings = [9, 8, 7, 6]
//    private var votesCount = [500, 2000, 5000, 7000, 10000]
//    private var runtimes = [
//        ["<1 hour": 0...60],
//        ["1 to 1.5 hours" : 61...90],
//        ["1.5 to 2 hours": 91...120],
//        [">2 hours": 121...SelectedOptions.maxRuntime]]
//    
//    private lazy var dates: [[String: ClosedRange<Date>]] = {
//        var dates: [[String: ClosedRange<Date>]] = []
//        let currentYear = Calendar.current.component(.year, from: Date())
//        for i in 0...2 {
//            let year = currentYear - i
//            if let range = createDateRangeForYear(year) {
//                dates.append(["\(year)": range])
//            }
//        }
//        
//        for decade in stride(from: 2020, to: 1920, by: -10) {
//            if let range = createDateRangeForYears(
//                from: decade - 10, to: decade) {
//                dates.append(["\(decade)s": range])
//            }
//        }
//        return dates
//    }()
//    
//    func pickGenres(option: Option) {
//        guard let genre = option.value as? Genre else { return }
//        selectedOptions.pickGenre(genre)
//    }
//    
//    func pickRating(option: Option) {
//        guard let rating = option.value as? Int else { return }
//        return selectedOptions.pickRating(rating)
//    }
//    
//    func pickVotesCount(option: Option) {
//        guard let votes = option.value as? Int else { return }
//        return selectedOptions.pickVotesCount(votes)
//    }
//    
//    func pickRuntime(option: Option) {
//        guard let runtime = option.value as? ClosedRange<Int> else { return }
//        return selectedOptions.pickRuntime(runtime)
//    }
//    
//    func pickDates(option: Option) {
//        guard let dates = option.value as? ClosedRange<Date> else {
//            return
//        }
//        return selectedOptions.pickDate(dates)
//    }
//    
//    var genresOptions: [Option] {
//        let genres = shortGenres ? Array(self.genres[..<10]) : self.genres
//        return genres.compactMap {
//            Option(name: $0.name, value: $0,
//                   state: selectedOptions.state(ofGenre: $0),
//                   pickHandler: pickGenres(option:))
//        }
//    }
//    
//    var ratingOptions: [Option] {
//        ratings.compactMap {
//            Option(name: "\($0)+", value: $0,
//                   state: selectedOptions.state(ofRating: $0),
//                   pickHandler: pickRating(option:))
//        }
//    }
//    
//    var votesCountOptions: [Option] {
//        votesCount.compactMap {
//            Option(name: "\($0)+", value: $0,
//                   state: selectedOptions.state(ofVotesCount: $0),
//                   pickHandler: pickVotesCount(option:))
//        }
//    }
//    
//    var runtimeOptions: [Option] {
//        return runtimes.compactMap {
//            guard let dict = $0.first else { return nil }
//            return Option(name: dict.key, value: dict.value,
//                          state: selectedOptions.state(ofRuntime: dict.value),
//                          pickHandler: pickRuntime(option:))
//        }
//    }
//    
//    func createDateRangeForYears(from minYear: Int, to maxYear: Int) -> ClosedRange<Date>? {
//        var minDateComponents = DateComponents()
//        minDateComponents.year = minYear
//        minDateComponents.month = 1
//        minDateComponents.day = 1
//        
//        var maxDateComponents = DateComponents()
//        maxDateComponents.year = maxYear
//        maxDateComponents.month = 12
//        maxDateComponents.day = 31
//        
//        let minDate = Calendar(identifier: .gregorian).date(from: minDateComponents)
//        let maxDate = Calendar(identifier: .gregorian).date(from: maxDateComponents)
//        
//        if let minDate = minDate, let maxDate = maxDate {
//            return minDate...maxDate
//        } else { return nil }
//    }
//    
//    func createDateRangeForYear(_ year: Int) -> ClosedRange<Date>? {
//        createDateRangeForYears(from: year, to: year)
//    }
//        
//    var datesOptions: [Option] {
//        dates.compactMap {
//            guard let dict = $0.first else { return nil }
//            return Option(name: dict.key, value: dict.value,
//                   state: selectedOptions.state(ofDate: dict.value),
//                   pickHandler: pickDates(option:))
//        }
//    }
//        
////
////        var options: [Option] = []
////        let currentYear = Calendar.current.component(.year, from: Date())
////        for i in 0...2 {
////            let year = currentYear - i
////            if let range = createDateRangeForYear(year) {
////                options.append(
////                    Option(name: "\(year)", value: range,
////                           state: selectedOptions.state(ofDate: range),
////                           pickHandler: pickDates(option:)))
////            }
////        }
////
////        for decade in stride(from: 2010, to: 1920, by: -10) {
////            if let range = createDateRangeForYears(
////                from: decade - 10, to: decade) {
////                options.append(
////                    Option(name: "\(decade)s", value: range,
////                           state: selectedOptions.state(ofDate: range),
////                           pickHandler: pickDates(option:)))
////            }
////        }
////
////        return options
////    }
//    
//    init() {
//        if let genres = TMDBClient.shared.genres {
//            self.genres = genres.genres
//        } else {
//            TMDBClient.shared.loadGenres { genres in
//                self.genres = genres.genres
//            }
//        }
//    }
//    
//    convenience init(filter: Filter) {
//        self.init()
//        self.filter = filter
//    }
//    
//    //var votesCount = ["500+", "2000+", "5000+", "7000+", "10000+"]
//    //var runtimes = ["<1 hour", "1 to 1.5 hours", "1.5 to 2 hours", ">2 hours" ]
//}
//
//extension FilterController {
//    struct SelectedOptions {
//        var includedGenres: [Genre] = []
//        var excludedGenres: [Genre] = []
//        var lowerRating: Int?
//        var lowerVotesCount: Int?
//        var runtimeLower: Int? //= Self.minRuntime
//        var runtimeUpper: Int? //= Self.minRuntime
//        var minDate: Date?
//        var maxDate: Date?
//        
//        static let minRuntime = 0
//        static let maxRuntime = Int(UInt16.max)
//    }
//    
//    struct Option: Hashable {
//        static func == (lhs: FilterController.Option, rhs: FilterController.Option) -> Bool {
//            lhs.hashValue == rhs.hashValue
//        }
//        
//        func hash(into hasher: inout Hasher) {
//            hasher.combine(name)
//            hasher.combine(value)
//            hasher.combine(state)
//            hasher.combine(section)
//        }
//        
//        enum State {
//            case included, excluded, ignored, checked
//        }
//        var name: String
//        var value: AnyHashable
//        var state: State
//        var section: FilterSection?
//        
//        var pickHandler: ( (Option) -> Void )? = nil
//        
//        func pick() {
//            pickHandler?(self)
//        }
//    }
//    
//    struct Country: Hashable {
//        var name: String?
//        var code: String
//    }
//    
//    struct NamedRange: Hashable {
//        var upper: Int! = Int(UInt16.max)
//        var lower: Int! = 0
//        var name: String
//        
//        var range: ClosedRange<Int> {
//            return ClosedRange(uncheckedBounds: (upper, lower))
//        }
//    }
//
//}
//
////MARK: - Release Date
//extension FilterController.SelectedOptions {
//    
//    mutating func pickDate(_ pickedRange: ClosedRange<Date>) {
//        guard let datesRange = datesRange else {
//            updateDates(with: pickedRange)
//            return
//        }
//
//        if pickedRange == datesRange {
//            resetDates()
//        }
//
//        else if pickedRange.overlaps(datesRange) {
//            if pickedRange.lowerBound == minDate {
//                updateDates(lowerBound: pickedRange.upperBound.tommorow)
//            } else if pickedRange.upperBound == maxDate {
//                updateDates(upperBound: pickedRange.lowerBound.yesterday)
//            } else {
//                updateDates(with: pickedRange)
//            }
//        }
//
//        else if pickedRange.lowerBound.yesterday == maxDate {
//            updateDates(upperBound: pickedRange.upperBound)
//        } else if pickedRange.lowerBound.tommorow == minDate {
//            updateDates(lowerBound: pickedRange.lowerBound)
//        }
//
//        else if !pickedRange.overlaps(datesRange) {
//            updateDates(with: pickedRange)
//        }
//
//    }
//    
//    func state(ofDate date: ClosedRange<Date>) -> FilterController.Option.State {
//        guard let datesRange = datesRange else { return .ignored }
//        
//        let isOverlaps = datesRange.overlaps(date)
//        
//        return isOverlaps ? .checked : .ignored
//    }
//    
//    var datesRange: ClosedRange<Date>? {
//        guard let min = minDate, let max = maxDate else {
//            return nil
//        }
//        return min...max
//    }
//    
//    mutating func updateDates(with newRange: ClosedRange<Date>) {
//        minDate = newRange.lowerBound
//        maxDate = newRange.upperBound
//    }
//    
//    mutating func updateDates(lowerBound: Date? = nil, upperBound: Date? = nil) {
//        minDate = lowerBound ?? minDate
//        maxDate = upperBound ?? maxDate
//    }
//    
//    mutating func resetDates() {
//        minDate = nil
//        maxDate = nil
//    }
//}
//
//extension FilterController.SelectedOptions {
//    enum GenreState {
//        case included, excluded, ignored
//    }
//    
//    
//    
//    
//    var runtimeRange: ClosedRange<Int>? {
//        guard let lower = runtimeLower, let upper = runtimeUpper else {
//            return nil
//        }
//        return ClosedRange(uncheckedBounds: (lower, upper))
//    }
//    
//    mutating func updateRuntime(with newRange: ClosedRange<Int>) {
//        runtimeLower = newRange.lowerBound
//        runtimeUpper = newRange.upperBound
//    }
//    
//    
//    mutating func updateRuntime(lowerBound: Int? = nil, upperBound: Int? = nil) {
//        runtimeLower = lowerBound ?? runtimeLower
//        runtimeUpper = upperBound ?? runtimeUpper
//    }
//    
//    
//    
//    mutating func resetRuntime() {
//        runtimeLower = nil
//        runtimeUpper = nil
//    }
//    
//        
//    mutating func includeGenre(_ genre: Genre) {
//        ignoreGenre(genre)
//        includedGenres.append(genre)
//    }
//    
//    mutating func excludeGenre(_ genre: Genre) {
//        ignoreGenre(genre)
//        excludedGenres.append(genre)
//    }
//    
//    mutating func ignoreGenre(_ genre: Genre) {
//        includedGenres.removeAll { $0 == genre }
//        excludedGenres.removeAll { $0 == genre }
//    }
//    
//    //MARK: - Picker Functions
//    mutating func pickGenre(_ genre: Genre) {
//        switch state(ofGenre: genre) {
//        case .ignored:
//            includeGenre(genre)
//        case .included:
//            excludeGenre(genre)
//        case .excluded:
//            ignoreGenre(genre)
//        default:
//            break
//        }
//    }
//    
//    mutating func pickRating(_ rating: Int) {
//        lowerRating = lowerRating == rating ? 0 : rating
//    }
//    
//    mutating func pickVotesCount(_ count: Int) {
//        lowerVotesCount = lowerVotesCount == count ? 0 : count
//    }
//    
//    
//    mutating func pickRuntime(_ pickedRange: ClosedRange<Int>) {
//        guard let runtimeRange = runtimeRange else {
//            updateRuntime(with: pickedRange)
//            return
//        }
//        
//        if pickedRange == runtimeRange {
//            resetRuntime()
//        }
//        
//        else if pickedRange.overlaps(runtimeRange) {
//            if pickedRange.lowerBound == runtimeLower {
//                updateRuntime(lowerBound: pickedRange.upperBound + 1)
//            } else if pickedRange.upperBound == runtimeUpper {
//                updateRuntime(upperBound: pickedRange.lowerBound - 1)
//            } else {
//                updateRuntime(with: pickedRange)
//            }
//        }
//
//        else if pickedRange.lowerBound - 1 == runtimeUpper {
//            updateRuntime(upperBound: pickedRange.upperBound)
//        } else if pickedRange.upperBound + 1 == runtimeLower {
//            updateRuntime(lowerBound: pickedRange.lowerBound)
//        }
//        
//        else if !pickedRange.overlaps(runtimeRange) {
//            updateRuntime(with: pickedRange)
//        }
//
//    }
//    
//    //MARK: - State Functions
//    func state(ofGenre genre: Genre) -> FilterController.Option.State {
//        if includedGenres.contains(genre) { return .included }
//        if excludedGenres.contains(genre) { return .excluded }
//
//        return .ignored
//    }
//    
//    func state(ofRating rating: Int) -> FilterController.Option.State {
//        guard let lowerRating = lowerRating else { return .ignored }
//        return rating <= lowerRating ? .checked : .ignored
//    }
//    
//    func state(ofVotesCount count: Int) -> FilterController.Option.State {
//        guard let lowerVotesCount = lowerVotesCount else { return .ignored }
//        return count <= lowerVotesCount ? .checked : .ignored
//    }
//    
//    func state(ofRuntime runtime: ClosedRange<Int>) -> FilterController.Option.State {
//        guard let runtimeRange = runtimeRange else { return .ignored }
//        
//        let isOverlaps = runtimeRange.overlaps(runtime)
//        
//        return isOverlaps ? .checked : .ignored
//    }
//    
//
//}
//
//
////private var topCountryCodes = ["US", "CN", "JP", "KR", "UK", "FR", "IN", "DE", "RU"]
////
////    private lazy var allCountryCodes = {
////        return NSLocale.isoCountryCodes.filter { !topCountryCodes.contains($0) }
////    }()
////
////    private func countryCodesToCountryList(codes: [String]) -> [Country] {
////        print(Locale.current)
////        return codes.compactMap {
////            Country(
////                name:
////                    (Locale.current as NSLocale).displayName(
////                        forKey: .countryCode, value: $0),
////                code: $0)
////        }
////    }
////
////    lazy var topCountries = {
////        return countryCodesToCountryList(codes: topCountryCodes)
////    }()
////
////    lazy var allCountries = {
////        return topCountries + countryCodesToCountryList(codes: allCountryCodes)
////            .sorted(by: { $0.name ?? "" < $1.name ?? "" })
////    }()
////
//
////    func state(ofOption option: Option, controlledBy controller: FilterController) -> Option.State {
////        switch self {
////        case .genres:
////            guard let genre = option.value as? Genre else { break }
////            return controller.selectedOptions.state(ofGenre: genre)
////        case .rating:
////            guard let rating = option.value as? Int else { break }
////            return controller.selectedOptions.state(ofRating: rating)
////        case .votes:
////            guard let votes = option.value as? Int else { break }
////            return controller.selectedOptions.state(ofVotesCount: votes)
////        case .runtime:
////            guard let runtime = option.value as? ClosedRange<Int> else { break }
////            return controller.selectedOptions.state(ofRuntime: runtime)
////
////        default:
////            break
////        }
////        return .ignored
////    }
//
////    func pick(option: Option, controlledBy controller: FilterController) {
////        switch self {
//////        case .genres:
//////            guard let genre = option.value as? Genre else { break }
//////            return controller.pick(genre: genre)
//////        case .rating:
//////            guard let rating = option.value as? Int else { break }
//////            return controller.pick(rating: rating)
//////        case .votes:
//////            guard let votes = option.value as? Int else { break }
//////            return controller.pick(votesCount: votes)
//////        case .runtime:
//////            guard let runtime = option.value as? ClosedRange<Int> else { break }
//////            return controller.pick(runtime: runtime)
////
////        default:
////            return
////        }
////    }
////    func pick(rating: Int) {
////        selectedOptions.pickRating(rating)
////    }
////
////    func pick(votesCount count: Int) {
////        selectedOptions.pickVotesCount(count)
////    }
////
////
////    func pick(genre: Genre) {
////        selectedOptions.pickGenre(genre)
////    }
////
////    func pick(runtime: ClosedRange<Int>) {
////        selectedOptions.pickRuntime(runtime)
////    }
//    
////    func picker(option: Option) {
////        guard let section = option.section else { return }
////        switch section {
////        case .genres:
////            guard let genre = option.value as? Genre else { break }
////            return selectedOptions.pickGenre(genre)
////        case .rating:
////            guard let rating = option.value as? Int else { break }
////            return selectedOptions.pickRating(rating)
////        case .votes:
////            guard let votes = option.value as? Int else { break }
////            return selectedOptions.pickVotesCount(votes)
////        case .runtime:
////            guard let runtime = option.value as? ClosedRange<Int> else { break }
////            return selectedOptions.pickRuntime(runtime)
////
////        default:
////            return
////        }
////
////    }
//
//
