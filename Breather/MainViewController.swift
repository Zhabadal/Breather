//
//  MainViewController.swift
//  Breather
//
//  Created by Alexandr Badmaev on 25.09.2020.
//  Copyright © 2020 Alexandr Badmaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MainViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherImageView: UIImageView!
    
    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var windLabel: UILabel!
    @IBOutlet weak var windDirectionImageView: UIImageView!
    
    @IBOutlet weak var aqiStandartSegmentedControl: UISegmentedControl!
    @IBOutlet weak var airQualityLabel: UILabel!
    @IBOutlet weak var aqiLabel: UILabel!
    @IBOutlet weak var mainPollutantLabel: UILabel!
    
    @IBOutlet weak var asthmaRiskLabel: UILabel!
    @IBOutlet weak var asthmaProbabilityLabel: UILabel!
    
    // MARK: - Properties
    var viewModel = MainViewModel()
    private let disposeBag = DisposeBag()
    private let refreshSubject = PublishSubject<Void>()
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
        refresh()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        heightConstraint.constant = view.bounds.height > 622 ? view.bounds.height : 622
    }
    
    // MARK: - Methods
    private func bindViewModel() {
        // Inputs
        refreshSubject
            .subscribe(viewModel.input.viewDidRefresh)
            .disposed(by: disposeBag)
        
        aqiStandartSegmentedControl.rx.selectedSegmentIndex
            .subscribe(viewModel.input.aqiStandard)
            .disposed(by: disposeBag)
        
        // Outputs
        viewModel.output.city.drive(cityLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.weatherImage.drive(weatherImageView.rx.image).disposed(by: disposeBag)
        viewModel.output.temperature.drive(temperatureLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.temperatureColor.drive(onNext: { [unowned self] color in
            self.temperatureLabel.textColor = color
        }).disposed(by: disposeBag)
        viewModel.output.humidity.drive(humidityLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.pressure.drive(pressureLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.windSpeed.drive(windLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.windDirection.drive(onNext: { [unowned self] direction in
            self.windDirectionImageView.transform = CGAffineTransform(rotationAngle: direction)
        }).disposed(by: disposeBag)
        viewModel.output.airQuality.drive(airQualityLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.airQualityColor.drive(onNext: { [unowned self] color in
            self.airQualityLabel.textColor = color
        }).disposed(by: disposeBag)
        viewModel.output.aqi.drive(aqiLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.mainPollutant.drive(onNext: { [unowned self] text in
            self.mainPollutantLabel.setAttributedTextWithSubscripts(
                text: text,
                indicesOfSubscripts: text.indicesOfNumbers)
        }).disposed(by: disposeBag)
        viewModel.output.asthmaRisk.drive(asthmaRiskLabel.rx.text).disposed(by: disposeBag)
        viewModel.output.asthmaRiskColor.drive(onNext: { [unowned self] color in
            self.asthmaRiskLabel.textColor = color
        }).disposed(by: disposeBag)
        viewModel.output.asthmaProbability.drive(asthmaProbabilityLabel.rx.text).disposed(by: disposeBag)
    }
    
    @objc private func refresh() {
        refreshSubject.onNext(())
    }
    
}
