//
//  ViewController.swift
//  SwinjectReactorKitExample
//
//  Created by 한상진 on 2021/05/21.
//

import UIKit
import RxSwift
import RxCocoa
import ReactorKit

class ViewController: UIViewController, StoryboardView {
    @IBOutlet weak var testButton: UIButton!
    
    var disposeBag: DisposeBag = .init()
    
    init?(coder: NSCoder, reactor: ViewReactor) {
        super.init(coder: coder)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func bind(reactor: ViewReactor) {
        testButton.rx.tap
            .map { Reactor.Action.buttonDidTapped }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map(\.purchaseResult)
            .subscribe(onNext: {
                print($0)
            })
            .disposed(by: disposeBag)
    }
}

