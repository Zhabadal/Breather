//
//  MainViewController.swift
//  Breather
//
//  Created by Alexandr Badmaev on 25.09.2020.
//  Copyright © 2020 Alexandr Badmaev. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
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
    
    private let data = CityConditions.sampleData()

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        heightConstraint.constant = view.bounds.height > 622 ? view.bounds.height : 622
    }
    
    @IBAction func aqiStandartSegmentedControlValueChanged(_ sender: UISegmentedControl) {
        updateAirQualityUI()
    }
    
    private func updateUI() {
        cityLabel.text = data.city
        updateWeatherUI()
        updateAirQualityUI()
        updateAsthmaUI()
    }
    
    private func updateWeatherUI() {
        weatherImageView.image = UIImage(named: Asset.forIconCode(data.weather.iconCode))
        temperatureLabel.text = "\(data.weather.temperature)℃"
        temperatureLabel.textColor = Color.forTemperature(data.weather.temperature)
        humidityLabel.text = "Humidity: \(data.weather.humidity)%"
        pressureLabel.text = "Pressure: \(data.weather.pressure) hPa"
        windLabel.text = "Wind: \(data.weather.windSpeed) m/s"
        let rotationAngle = (CGFloat(data.weather.windDirection) * .pi) / 180.0
        windDirectionImageView.transform = CGAffineTransform(rotationAngle: rotationAngle)
    }
    
    private func updateAirQualityUI() {
        let standartUS = aqiStandartSegmentedControl.selectedSegmentIndex == 0
        
        airQualityLabel.text = Text.forAQI(standartUS ? data.pollution.aqiUS : data.pollution.aqiChina)
        airQualityLabel.textColor = Color.forAQI(standartUS ? data.pollution.aqiUS : data.pollution.aqiChina)
        aqiLabel.text = "AQI: \(standartUS ? data.pollution.aqiUS : data.pollution.aqiChina)"
        let text = "Main pollutant: \(Text.forMainPollutant(standartUS ? data.pollution.mainPollutantUS : data.pollution.mainPollutantChina))"
        mainPollutantLabel.setAttributedTextWithSubscripts(text: text, indicesOfSubscripts: text.indicesOfNumbers)
    }
    
    private func updateAsthmaUI() {
        asthmaRiskLabel.text = data.asthma.risk.capitalized
        asthmaRiskLabel.textColor = Color.forAsthmaRisk(data.asthma.risk)
        asthmaProbabilityLabel.text = "Probability: \(data.asthma.probability)%"
    }

}
