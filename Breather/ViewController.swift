//
//  ViewController.swift
//  Breather
//
//  Created by Alexandr Badmaev on 24.09.2020.
//  Copyright © 2020 Alexandr Badmaev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        heightConstraint.constant = view.bounds.height > 622 ? view.bounds.height : 622
    }

}

