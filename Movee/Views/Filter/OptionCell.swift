//
//  OptionCell.swift
//  Movee
//
//  Created by jjurlits on 12/12/20.
//

import UIKit

class OptionCell: ProgrammaticCollectionViewCell, SelfConfiguringView {
    private static let defaultBackgroundColor = UIColor.secondarySystemBackground
    private static let selectedBackgroundColor = UIColor.secondarySystemFill
    
    enum State {
        case included, excluded, ignored
    }
    
    var state = State.ignored
    var option: String?
    
    func ignore() {
        background.backgroundColor = .secondarySystemBackground
    }
    
    func include() {
        background.backgroundColor = .systemGreen
    }
    
    func exclude() {
        guard let option = option else { return }
        background.backgroundColor = .systemRed
        label.text = "-\(option)"
        state = .excluded
    }
    
    let label: UILabel = createView {
        $0.backgroundColor = .clear
        $0.font = UIFont.systemFont(ofSize: 16)
    }
    
    private let background = createView {
        $0.backgroundColor = OptionCell.defaultBackgroundColor
        $0.layer.cornerRadius = 8
        $0.clipsToBounds = true
    }
    
    override func setupViews() {
        [background].forEach { addSubview($0) }
        
        background.fillSuperview()
        background.addSubview(label)
        label.fillSuperview(padding: .init(top: 4, left: 4, bottom: 4, right: 4))
    }
}

extension OptionCell {
    func setState(_ state: FilterController.Option.State) {
        switch state {
        case .checked, .included:
            include()
        case .excluded:
            exclude()
        default:
            ignore()
        }
    }
}
