//
//  ViewController.swift
//  AnalyzeImageView
//
//  Created by 寺家 篤史 on 2018/05/29.
//  Copyright © 2018年 Yumemi Inc. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let analyzeImageView = AnalyzeImageView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(analyzeImageView)
        analyzeImageView.snp.makeConstraints { (make) in
            make.center.size.equalToSuperview()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        analyzeImageView.startEffect()
    }
}

