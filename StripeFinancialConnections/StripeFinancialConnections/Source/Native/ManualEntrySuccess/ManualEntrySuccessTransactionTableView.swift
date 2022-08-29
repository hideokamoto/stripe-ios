//
//  ManualEntrySuccessTableView.swift
//  StripeFinancialConnections
//
//  Created by Krisjanis Gaidis on 8/29/22.
//

import Foundation
import UIKit
@_spi(STP) import StripeUICore

private struct Label {
    let title: String
    let isHighlighted: Bool
    
    init(title: String, isHighlighted: Bool = false) {
        self.title = title
        self.isHighlighted = isHighlighted
    }
}

final class ManualEntrySuccessTransactionTableView: UIView {
    
    private let rows: [[Label]] = [
        [
            Label(title: "SMXXXX", isHighlighted: true),
            Label(title: "$0.01"),
            Label(title: "ACH CREDIT")
        ],
//        [
//            Label(title: "AMTS"),
//            Label(title: "$0.XX", isHighlighted: true),
//            Label(title: "ACH CREDIT")
//        ],
//        [
//            Label(title: "AMTS"),
//            Label(title: "$0.XX", isHighlighted: true),
//            Label(title: "ACH CREDIT")
//        ],
        [
            Label(title: "GROCERIES"),
            Label(title: "$56.12"),
            Label(title: "VISA")
        ],
    ]
    
    init() {
        super.init(frame: .zero)
        
        let verticalStackView = UIStackView()
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 4
        verticalStackView.isLayoutMarginsRelativeArrangement = true
        verticalStackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 14,
            leading: 20,
            bottom: 14,
            trailing: 20
        )
        verticalStackView.backgroundColor = .backgroundContainer
        verticalStackView.layer.cornerRadius = 5
        verticalStackView.layer.borderColor = UIColor.borderNeutral.cgColor
        verticalStackView.layer.borderWidth = 1.0 / UIScreen.main.nativeScale
        addAndPinSubview(verticalStackView)
        
        verticalStackView.addArrangedSubview(CreateTableTitleView())
        
        let transactionColumnTuple = CreateColumnView(
            title: "Transaction",
            prioritize: true,
            rowLabels: rows.compactMap { $0[0] }
        )
        
        let amountColumnTuple = CreateColumnView(
            title: "Amount",
            alignment: .trailing,
            rowLabels: rows.compactMap { $0[1] }
        )
//        amountColumnTuple.stackView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        let typeColumnTuple = CreateColumnView(
            title: "Type",
            rowLabels: rows.compactMap { $0[2] }
        )
        
        let horizontalStackView = UIStackView(
            arrangedSubviews: [
                transactionColumnTuple.stackView,
                amountColumnTuple.stackView,
                typeColumnTuple.stackView,
            ]
        )
        horizontalStackView.axis = .horizontal
        horizontalStackView.spacing = 2
        horizontalStackView.distribution = .fillProportionally
        //horizontalStackView.distribution = .fillEqually
        
        horizontalStackView.setCustomSpacing(10, after: amountColumnTuple.stackView)
//        horizontalStackView.customSpacing(after: amountColumnTuple,
        
        verticalStackView.addArrangedSubview(horizontalStackView)
        
        for tuple in [transactionColumnTuple, amountColumnTuple, typeColumnTuple] {
            
            
            
            let separatorView = UIView()
            separatorView.backgroundColor = .borderNeutral
            separatorView.setContentHuggingPriority(.defaultHigh, for: .vertical)
        //    separatorView.setContentHuggingPriority(.defaultLow, for: .horizontal)
//            separatorView.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
            separatorView.translatesAutoresizingMaskIntoConstraints = false
            tuple.stackView.insertArrangedSubview(separatorView, at: 1)
            verticalStackView.setCustomSpacing(10, after: separatorView)
            
            NSLayoutConstraint.activate([
                separatorView.heightAnchor.constraint(equalToConstant: 1.0 / UIScreen.main.nativeScale),
                separatorView.widthAnchor.constraint(equalTo: tuple.stackView.widthAnchor)
        //        separatorView.widthAnchor.constraint(lessThanOrEqualToConstant: 100),
                
        //        separatorView.widthAnchor.constraint(equalTo: )
                //separatorView.widthAnchor.constraint(equalToConstant: 40),
                //separatorView.widthAnchor.constraint(lessThanOrEqualToConstant: UIScreen.main.bounds.width),
        //        separatorView.widthAnchor.constraint(equalToConstant: 30),
            ])
            
            // tuple.stackView.setCustomSpacing(5, after: tuple.titleView)
            
        }
        
        
        // add manual constraints
        for i in 0..<transactionColumnTuple.rowViews.count {
            let transactionRowView = transactionColumnTuple.rowViews[i]
            let amountRowView = amountColumnTuple.rowViews[i]
            let typeRowView = typeColumnTuple.rowViews[i]

            NSLayoutConstraint.activate([
                transactionRowView.heightAnchor.constraint(equalTo: amountRowView.heightAnchor),
                amountRowView.heightAnchor.constraint(equalTo: typeRowView.heightAnchor),
            ])
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Helpers

private func CreateTableTitleView() -> UIView {
    
    let iconImageView = UIImageView()
    if #available(iOSApplicationExtension 13.0, *) {
        iconImageView.image = UIImage(systemName: "building.columns.fill")?.withTintColor(.secondaryLabel, renderingMode: .alwaysOriginal)
    } else {
        // Fallback on earlier versions
    }
    NSLayoutConstraint.activate([
        iconImageView.widthAnchor.constraint(equalToConstant: 16),
        iconImageView.heightAnchor.constraint(equalToConstant: 16),
    ])
    
    let titleLabel = UILabel()
    if #available(iOSApplicationExtension 13.0, *) {
        titleLabel.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
    } else {
        // Fallback on earlier versions
        assertionFailure()
    }
    titleLabel.textColor = .textSecondary
    titleLabel.numberOfLines = 0
    titleLabel.text = "••••6789 BANK STATEMENT"
    
    let horizontalStackView = UIStackView(
        arrangedSubviews: [
            iconImageView,
            titleLabel,
        ]
    )
    horizontalStackView.axis = .horizontal
    horizontalStackView.spacing = 5
    return horizontalStackView
}

private func CreateColumnView(
    title: String,
    prioritize: Bool = false,
    alignment: UIStackView.Alignment = .leading,
    rowLabels: [Label]
) -> (stackView: UIStackView, titleView: UIView, rowViews: [UIView]) {
    let verticalStackView = UIStackView()
    verticalStackView.axis = .vertical
    verticalStackView.spacing = 4 // spacing for rows
    verticalStackView.alignment = alignment
//    verticalStackView.backgroundColor = .yellow
//    verticalStackView.distribution = .equalSpacing

    // Title
    let titleLabel = UILabel()
    if #available(iOSApplicationExtension 13.0, *) {
        titleLabel.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
    } else {
        assertionFailure()
    }
    titleLabel.textColor = .textSecondary
    titleLabel.text = title
    titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
//    if prioritize {
//        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//    } else {
//        titleLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//    }
//    else {
//        titleLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
//    }
    
    verticalStackView.addArrangedSubview(titleLabel)
    verticalStackView.setCustomSpacing(5, after: titleLabel)

    // Rows
    var rowViews: [UIView] = []
    for label in rowLabels {
        let rowLabel = UILabel()
        if #available(iOSApplicationExtension 13.0, *) {
            rowLabel.font = .monospacedSystemFont(ofSize: 16, weight: .bold)
        } else {
            assertionFailure()
        }
        rowLabel.numberOfLines = 0
        rowLabel.textColor = label.isHighlighted ? .textBrand : .textPrimary
        //.stripeFont(forTextStyle: .caption)
        rowLabel.text = label.title
        rowLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        rowLabel.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        verticalStackView.addArrangedSubview(rowLabel)
        
//        if prioritize {
//            rowLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
//        } else {
//            rowLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
//        }
        
        rowViews.append(rowLabel)
    }
    
    // Spacer
    verticalStackView.addArrangedSubview(UIView())
    
    return (verticalStackView, titleLabel, rowViews)
}


#if DEBUG

import SwiftUI

@available(iOS 13.0, *)
@available(iOSApplicationExtension, unavailable)
private struct ManualEntrySuccessTransactionTableViewUIViewRepresentable: UIViewRepresentable {
    
    func makeUIView(context: Context) -> ManualEntrySuccessTransactionTableView {
        ManualEntrySuccessTransactionTableView()
    }
    
    func updateUIView(_ uiView: ManualEntrySuccessTransactionTableView, context: Context) {}
}

@available(iOSApplicationExtension, unavailable)
struct ManualEntrySuccessTransactionTableView_Previews: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        if #available(iOS 14.0, *) {
            VStack(spacing: 16) {
                ManualEntrySuccessTransactionTableViewUIViewRepresentable()
            }
            .frame(maxHeight: 200)
            .frame(maxWidth: 320)
            .padding()
            .background(Color(UIColor.customBackgroundColor))
        }
    }
}

#endif
