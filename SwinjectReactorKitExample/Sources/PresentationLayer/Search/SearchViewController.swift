//
//  ViewController.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Then
import UIKit
import Lottie
import SnapKit
import RxCocoa
import ReactorKit

final class SearchViewController: UIViewController {
    
    // MARK: Property
    
    var disposeBag: DisposeBag = .init()
    
    // MARK: UI Property
    
    private let searchIDTextField: UITextField = .init().then {
        $0.placeholder = "Git id 입력"
    }
    
    private let startButton: UIButton = .init(type: .system).then {
        $0.setTitle("startButton", for: UIControl.State())
    }
    
    private let resultText: UILabel = .init()
    
    private let resultImageView: UIImageView = .init().then {
        $0.contentMode = .scaleAspectFit
    }

    private let indicator: AnimationView = .init(name: "progress_bar").then {
        $0.contentMode = .scaleAspectFit
        $0.isHidden = true
    }
    
    private let resultIDText: UILabel = .init()
    
    // MARK: Init
    
    init(reactor: SearchReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let temp = R.image.initial_empty_image()
        self.resultImageView.image = temp
    }
}

// MARK: UI

extension SearchViewController {
    private func setUpUI() {
        view.backgroundColor = .systemGray6
        
        self.view.addSubview(self.indicator)
        self.indicator.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.size.equalTo(50)
        }
        
        self.view.addSubview(self.searchIDTextField)
        self.searchIDTextField.snp.makeConstraints { 
            $0.top.equalToSuperview().offset(300)
            $0.width.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints {
            $0.top.equalTo(self.searchIDTextField.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.resultText)
        self.resultText.snp.makeConstraints { 
            $0.top.equalTo(self.startButton.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.resultImageView)
        self.resultImageView.snp.makeConstraints { 
            $0.top.equalTo(self.resultText.snp.bottom).offset(20)
            $0.size.equalTo(200)
            $0.centerX.equalToSuperview()
        }
        
        self.view.addSubview(self.resultIDText)
        self.resultIDText.snp.makeConstraints { 
            $0.top.equalTo(self.resultImageView.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }
    }
}

// MARK: Bind

extension SearchViewController: View {
    func bind(reactor: SearchReactor) {
        bindAction(reactor: reactor)
        bindState(reactor: reactor)
    }
    
    private func bindAction(reactor: SearchReactor) {
        startButton.rx.tap
            .map { [weak self] in
                return Reactor.Action.searchUser(id: self?.searchIDTextField.text ?? "")
            }
            .do(onNext: { [weak self] _ in
                self?.indicator.isHidden = false
                self?.indicator.play()
            })
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    private func bindState(reactor: SearchReactor) {
        reactor.state
            .map(\.searchResult)
            .bind(to: resultText.rx.text)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.searchAvartarImageData)
            .map { $0 == nil ? R.image.no_url_image() : UIImage(data: $0!) }
            .do(onNext: { [weak self] _ in
                self?.indicator.isHidden = true
                self?.indicator.stop()
            })
            .bind(to: resultImageView.rx.image)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.searchIDResult)
            .bind(to: resultIDText.rx.text)
            .disposed(by: disposeBag)
        
        reactor.errorResult
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in
                self?.indicator.isHidden = true
                self?.indicator.stop()
            })
            .subscribe(onNext: {
                print("error: ", $0)
            })
            .disposed(by: disposeBag)
    }
}
