//
//  ErrorView.swift
//  GalleryApp-Features
//
//  Created by Alexander Sivko on 14.06.24.
//

import UIKit
import SnapKit

// MARK: - ErrorView
final class ErrorView: UIView {
    
    // MARK: Properties
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = Consts.stackViewSpacing
        return stackView
    }()
    
    private let topLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.text = Consts.topLabelText
        return label
    }()
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.textColor = .gray
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: 22, weight: .regular)
        label.text = Consts.errorLabelText
        return label
    }()
    
    private lazy var retryButton: UIButton = {
        let button = UIButton()
        button.setTitle(Consts.retryButtonTitle, for: .normal)
        button.titleLabel?.textColor = .white
        button.titleLabel?.font = .systemFont(ofSize: 36, weight: .regular)
        button.backgroundColor = .systemIndigo
        button.layer.cornerRadius = Consts.buttonCornerRadius
        button.setContentHuggingPriority(.defaultHigh, for: .vertical)
        button.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: Callbacks
    var retryAction: (() -> Void)?
    
    // MARK: Initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpHierarchy()
        setUpConstraints()
        setUpAppearance()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Methods
    @objc private func retryButtonTapped() {
        retryAction?()
    }
}

// MARK: - Private
private extension ErrorView {
    func setUpHierarchy() {
        [stackView, retryButton].forEach { addSubview($0) }
        stackView.addArrangedSubview(topLabel)
        stackView.addArrangedSubview(errorLabel)
    }
    
    func setUpConstraints() {
        stackView.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.height.height.equalToSuperview().multipliedBy(0.2)
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-30)
        }
        
        retryButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(250)
            make.centerX.equalToSuperview()
            make.top.equalTo(stackView.snp.bottom).offset(50)
        }
    }
    
    func setUpAppearance() {
        backgroundColor = .white
    }
}

// MARK: - Consts
private extension ErrorView {
    enum Consts {
        static let topLabelText = "Oops!"
        static let errorLabelText = "We couldn't load images. Please try again"
        static let retryButtonTitle = "Retry"
        static let stackViewSpacing: CGFloat = 10
        static let buttonCornerRadius: CGFloat = 8
    }
}
