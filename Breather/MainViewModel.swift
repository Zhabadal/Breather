//
//  MainViewModel.swift
//  Breather
//
//  Created by Alexandr Badmaev on 28.09.2020.
//  Copyright © 2020 Alexandr Badmaev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import Moya

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    
    var input: Input { get }
    var output: Output { get }
}

class MainViewModel: ViewModel {
    
    // MARK: - Dependencies
    let provider = MoyaProvider<AirVisualAPI>()
    let lat = 40.676906
    let lon = -73.942275
    
    // MARK: - Inputs
    let input: Input
    
    struct Input {
        let viewDidRefresh: AnyObserver<Void>
        let aqiStandard: AnyObserver<Int>
    }
    
    private let viewDidRefreshSubject = PublishSubject<Void>()
    private let aqiStandardSubject = BehaviorSubject<Int>(value: 0)
    
    // MARK: - Outputs
    let output: Output
    
    struct Output {
        let city: Driver<String>
        let weatherImage: Driver<UIImage?>
        let temperature: Driver<String>
        let temperatureColor: Driver<UIColor>
        let humidity: Driver<String>
        let pressure: Driver<String>
        let windSpeed: Driver<String>
        let windDirection: Driver<CGFloat>
        let airQuality: Driver<String>
        let airQualityColor: Driver<UIColor>
        let aqi: Driver<String>
        let mainPollutant: Driver<String>
        let asthmaRisk: Driver<String>
        let asthmaRiskColor: Driver<UIColor>
        let asthmaProbability: Driver<String>
        // Loading
        let isLoading: Driver<Bool>
        // Error
        let error: Driver<Error>
    }
    
    private let cityConditionsSubject = PublishSubject<CityConditions>()
    private let disposeBag = DisposeBag()
    
    private let isLoadingSubject = PublishSubject<Bool>()
    private let errorSubject = PublishSubject<Error>()
    
    // MARK: - Initialization
    init() {
        input = Input(viewDidRefresh: viewDidRefreshSubject.asObserver(),
                      aqiStandard: aqiStandardSubject.asObserver())
        
        let city = cityConditionsSubject
            .map { $0.city }
            .asDriver(onErrorJustReturn: "...")
        let weatherImage = cityConditionsSubject
            .map { UIImage(named: Asset.forIconCode($0.weather.iconCode)) }
            .asDriver(onErrorJustReturn: nil)
        let temperature = cityConditionsSubject
            .map { "\($0.weather.temperature)℃" }
            .asDriver(onErrorJustReturn: "...℃")
        let temperatureColor = cityConditionsSubject
            .map { Color.forTemperature($0.weather.temperature) }
            .asDriver(onErrorJustReturn: UIColor.black)
        let humidity = cityConditionsSubject
            .map { "Humidity: \($0.weather.humidity)%" }
            .asDriver(onErrorJustReturn: "Humidity: ...%")
        let pressure = cityConditionsSubject
            .map { "Pressure: \($0.weather.pressure) hPa" }
            .asDriver(onErrorJustReturn: "Pressure: ... hPa")
        let windSpeed = cityConditionsSubject
            .map { "Wind: \($0.weather.windSpeed) m/s" }
            .asDriver(onErrorJustReturn: "Wind: ... m/s")
        let windDirection = cityConditionsSubject
            .map { CGFloat($0.weather.windDirection) * .pi / 180.0 }
            .asDriver(onErrorJustReturn: 0)
        let airQuality = Observable
            .combineLatest(cityConditionsSubject, aqiStandardSubject)
            .map { Text.forAQI($1 == 0 ? $0.pollution.aqiUS : $0.pollution.aqiChina) }
            .asDriver(onErrorJustReturn: "...")
        let airQualityColor = Observable
            .combineLatest(cityConditionsSubject, aqiStandardSubject)
            .map { Color.forAQI($1 == 0 ? $0.pollution.aqiUS : $0.pollution.aqiChina) }
            .asDriver(onErrorJustReturn: UIColor.black)
        let aqi = Observable
            .combineLatest(cityConditionsSubject, aqiStandardSubject)
            .map { "AQI: \($1 == 0 ? $0.pollution.aqiUS : $0.pollution.aqiChina)" }
            .asDriver(onErrorJustReturn: "AQI: ...")
        let mainPollutant = Observable
            .combineLatest(cityConditionsSubject, aqiStandardSubject)
            .map { "Main pollutant: \(Text.forMainPollutant($1 == 0 ? $0.pollution.mainPollutantUS : $0.pollution.mainPollutantChina))" }
            .asDriver(onErrorJustReturn: "Main pollutant: ...")
        let asthmaRisk = cityConditionsSubject
            .map { $0.asthma.risk.capitalized }
            .asDriver(onErrorJustReturn: "...")
        let asthmaRiskColor = cityConditionsSubject
            .map { Color.forAsthmaRisk($0.asthma.risk) }
            .asDriver(onErrorJustReturn: UIColor.black)
        let asthmaProbability = cityConditionsSubject
            .map { "Probability: \($0.asthma.probability)%" }
            .asDriver(onErrorJustReturn: "Probability: ...%")

        output = Output(city: city,
                        weatherImage: weatherImage,
                        temperature: temperature,
                        temperatureColor: temperatureColor,
                        humidity: humidity,
                        pressure: pressure,
                        windSpeed: windSpeed,
                        windDirection: windDirection,
                        airQuality: airQuality,
                        airQualityColor: airQualityColor,
                        aqi: aqi,
                        mainPollutant: mainPollutant,
                        asthmaRisk: asthmaRisk,
                        asthmaRiskColor: asthmaRiskColor,
                        asthmaProbability: asthmaProbability,
                        isLoading: isLoadingSubject.asDriver(onErrorJustReturn: false),
                        error: errorSubject.asDriver(onErrorJustReturn: BreatherError.unknown))
        
        viewDidRefreshSubject
            .do(onNext: { [unowned self] _ in
                self.isLoadingSubject.onNext(true)
            })
            .flatMap { [unowned self] _ in
                return self.provider.rx.request(.nearestCity(lat: self.lat, lon: self.lon))
                .asObservable()
                .materialize()
            }
            .do(onNext: { [unowned self] _ in
                self.isLoadingSubject.onNext(false)
            })
            .subscribe(onNext: { [unowned self] event in
                switch event {
                case let .next(element): print("next:", element)
                case let .error(error): self.errorSubject.onNext(error)
                case .completed: break
                }
            })
            .disposed(by: disposeBag)
    }
    
}
