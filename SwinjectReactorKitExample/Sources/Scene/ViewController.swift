//
//  ViewController.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import Then
import UIKit
import SnapKit
import RxCocoa
import ReactorKit

final class ViewController: UIViewController {
    
    var disposeBag: DisposeBag = .init()
    
    private let startButton: UIButton = .init(type: .system).then {
        $0.setTitle("startButton", for: UIControl.State())
    }
    
    init(reactor: ViewReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpUI()
    }
}

extension ViewController {
    private func setUpUI() {
        self.view.addSubview(self.startButton)
        self.startButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension ViewController: View {
    func bind(reactor: ViewReactor) {
        startButton.rx.tap
            .map { Reactor.Action.buttonDidTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.searchResult)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}

