//
//  ReviewViewModel.swift
//  Movee
//
//  Created by jjurlits on 3/15/21.
//

import Foundation
import MarkdownKit

class ReviewViewModel {
    var review: Review?
    static let markdownParser: MarkdownParser = {
        let parser = MarkdownParser(font: .preferredFont(forTextStyle: .body), color: .label)
        return parser
    }()
    
    var author: String { review?.author ?? "" }
    var url: String { review?.url ?? "https://www.themoviedb.org" }
    
    var shortContent: String { review?.content ?? "" }
    var fullContent: String {
        return "\n" + shortContent + "\n\n© [\(author)](\(url))"
    }
    
    var clearedShortContent: String {
        return shortContent//Self.markdownParser.parse(shortContent).string
    }
    
    var attributedContent: NSAttributedString {
        Self.markdownParser.parse(fullContent)
    }
    
    func configure(_ view: ReviewCell) {
        view.reviewLabel.text = clearedShortContent
    }
    
    init(review: Review) { self.review = review }
    
}

extension Review {
    var viewModel: ReviewViewModel { return ReviewViewModel(review: self) }
}
