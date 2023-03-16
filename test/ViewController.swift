//
//  ViewController.swift
//  test
//
//  Created by Ricardo Alonso Diaz Alvarado on 15/03/23.
//

import UIKit
import RxSwift

class ViewController: UIViewController {

    private var disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        getTV_Popular()
    }
    
    internal func getTV_Popular() {
        
        return NetworkingService.request(endPoint: NetworkConstants.endPoint.TVPopular(nextPage: "1").url, model: DashboardCustomModel.self, method: .GET)
            .subscribe(on: MainScheduler.instance)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { data  in
                print("datos: ", data)
            }, onError: { error in
                print("error: ", error.localizedDescription)
            }, onCompleted: {
            }).disposed(by: disposeBag)

    }

}

