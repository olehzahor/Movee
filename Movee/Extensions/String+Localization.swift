//
//  String+Localization.swift
//  Movee
//
//  Created by jjurlits on 3/26/21.
//

import Foundation

extension String {
    var l10ed: String {
        NSLocalizedString(self, comment: "")
    }
}
