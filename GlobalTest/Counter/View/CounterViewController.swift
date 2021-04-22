//
//  CounterViewController.swift
//  GlobalTest
//
//  Created by Shayan Mehranpoor on 4/21/21.
//

import UIKit
import RxSwift
import RxCocoa

final class CounterViewController: UIViewController, Storyboarded {
    
    weak var coordinator: AppCoordinator?
    
    private var counterViewModel = CounterViewModel(counterService: CounterService.shared)
    
    private let disposeBag = DisposeBag()
    
    lazy var mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 8
        // Constraints
        self.view.addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 8).isActive = true
        stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -8).isActive = true
        stackView.addArrangedSubview(responseCodeLabel)
        stackView.addArrangedSubview(timeFetchedLabel)
        return stackView
    }()
    
    lazy var countButton: UIButton = {
        let button = UIButton()
        self.view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.topAnchor.constraint(equalTo: mainStackView.bottomAnchor, constant: 16).isActive = true
        button.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        button.widthAnchor.constraint(equalToConstant: 150).isActive = true
        button.layer.cornerRadius = 15
        button.backgroundColor = .systemBlue
        button.setTitle("Fetch Content", for: .normal)
        return button
    }()
    
    lazy var responseCodeLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.text = "Response Code: \(counterViewModel.savedResponseCode)"
        codeLabel.textColor = .systemGray
        codeLabel.textAlignment = .left
        codeLabel.numberOfLines = 0
        return codeLabel
    }()
    
    lazy var timeFetchedLabel: UILabel = {
        let codeLabel = UILabel()
        codeLabel.text = "Times Fetched: \(counterViewModel.savedCounter)"
        codeLabel.textColor = .systemGray
        codeLabel.textAlignment = .left
        return codeLabel
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
        setupBindings()
    }
    
    private func callService() {
        counterViewModel.fetchContent()
    }
    
    private func setupBindings() {
        
        counterViewModel.successResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
                self.setData(model: result.model, counter: result.counter)
            }).disposed(by: disposeBag)
        
        counterViewModel.errorResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                switch error {
                case .networkError(let error):
                    self.showAlertWith(error.localizedDescription)
                case .tooManyRequestError:
                    self.showAlertWith("Too Many Requests")
                }
            }).disposed(by: disposeBag)
        
        countButton.rx.tap
            .throttle(.seconds(1), scheduler: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                self.callService()
            }).disposed(by: disposeBag)
    }
    
    private func showAlertWith(_ message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
    
    private func setupViews() {
        self.view.addSubview(mainStackView)
        self.view.addSubview(countButton)
    }
    
    private func setData(model: ResponseCode, counter: Int) {
        self.responseCodeLabel.text = "Response Code: \(model.responseCode ?? "")"
        self.timeFetchedLabel.text = "Times Fetched: \(counter)"
    }
}
