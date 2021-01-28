//
//  DateRangePicker.swift
//  Movee
//
//  Created by jjurlits on 12/25/20.
//

import UIKit

class DateRangePicker: ProgrammaticCollectionReusableView, SelfConfiguringView {
    let minDatePicker: UIDatePicker = createView {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
    }
    
    let maxDatePicker: UIDatePicker = createView {
        $0.datePickerMode = .date
        $0.preferredDatePickerStyle = .compact
    }
    
    override func setupViews() {
        [minDatePicker, maxDatePicker].forEach { addSubview($0) }
        
        minDatePicker.anchor(top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil)
        maxDatePicker.anchor(top: topAnchor, leading: minDatePicker.trailingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
    }
    
    
}
