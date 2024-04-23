//
//  MYRCalendarView.swift
//  DesignSystem
//
//  Created by 김요한 on 2024/03/21.
//  Copyright © 2024 Moyeora. All rights reserved.
//

import UIKit
import RxRelay
import RxCocoa
import SnapKit
import RxSwift

public final class MYRCalendarView: UIView {
    public enum Feature {
        case home
        case ceate
    }
    
    public let disposeBag = DisposeBag()
    private var hadPlans: [Date] = []
    public let selectedDate = BehaviorRelay<Date>(value: Date())
    
    public lazy var calendar: UICalendarView = {
        let view = UICalendarView()
        view.tintColor = .moyeora(.primary(.primary1))
        view.locale = .init(identifier: "ko_KR")
        view.timeZone = .init(identifier: "Asia/Seoul")
        view.wantsDateDecorations = true
        let dateSelection = UICalendarSelectionSingleDate(delegate: self)
        view.selectionBehavior = dateSelection
        dateSelection.selectedDate = self.createDateComponents()
        dateSelection.selectedDate?.timeZone = TimeZone.init(identifier: "Asia/Seoul")
        return view
    }()
    
    public init(feature: MYRCalendarView.Feature) {
        super.init(frame: .zero)
        
        self.configureCalendar(feature: feature)
        self.configureUI()
        self.configureAttribute()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MYRCalendarView {
    func configureAttribute() {
        self.clipsToBounds = true
        self.layer.cornerRadius = MYRConstants.cornerRadiusMedium
        self.backgroundColor = .moyeora(.neutral(.gray5))
        
    }
    
    func configureUI() {
        self.addSubview(self.calendar)
        self.calendar.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    func configureCalendar(feature: MYRCalendarView.Feature) {
        switch feature {
        case .home:
            self.calendar.delegate = self
            return
        case .ceate:
            self.calendar.delegate = nil
            return
        }
    }
}

public extension MYRCalendarView {
    func bindCalendarView(plans: [Date]) {
        self.hadPlans = plans
    }
    
}

extension MYRCalendarView: UICalendarViewDelegate, UICalendarSelectionSingleDateDelegate {
    public func dateSelection(_ selection: UICalendarSelectionSingleDate, didSelectDate dateComponents: DateComponents?) {
        guard let selectionDate = selection.selectedDate,
              let date = selectionDate.date
        else { return }
        self.selectedDate.accept(date)
    }
    
    public func calendarView(_ calendarView: UICalendarView, decorationFor dateComponents: DateComponents) -> UICalendarView.Decoration? {
        guard let date = dateComponents.date else { return nil}
        let dateCount = hadPlans.filter { Calendar.current.isDate($0, inSameDayAs: date) }.count
        
        guard dateCount > 0 else { return nil }
        
        return .customView {
            let view = UIView()
            
            if dateCount <= 3 {
                let stackView = self.createCalendarStackView()
                view.addSubview(stackView)
                stackView.snp.makeConstraints { make in
                    make.centerX.equalToSuperview()
                    make.bottom.equalToSuperview()
                }
                
                for _ in 0 ..< dateCount {
                    let dot = self.createCalendarDotView()
                    stackView.addArrangedSubview(dot)
                }
            } else {
                let label = self.createCalendarCountLabel(count: dateCount)
                view.addSubview(label)
                label.snp.makeConstraints { make in
                    make.center.equalToSuperview()
                }
            }
            
            return view
        }
    }
    
    private func createCalendarCountLabel(count: Int) -> UILabel {
        let label = UILabel()
        label.text = "\(count)+"
        label.font = .moyeora(.caption)
        
        return label
    }
    
    private func createCalendarStackView() -> UIStackView {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 2
        
        return stackView
    }
    
    private func createCalendarDotView() -> UIView {
        let dotView = UIView()
        dotView.backgroundColor = .black // 점의 색상
        dotView.layer.cornerRadius = 2.5 // 점을 원형으로 만들기 위해 너비의 절반 값 설정
        dotView.snp.makeConstraints { make in
            make.width.height.equalTo(5)
        }
        return dotView
    }
    
    private func createDateComponents() -> DateComponents? {
        let today = Date()
        var calendar = Calendar.autoupdatingCurrent
        guard let timeZone = TimeZone.init(identifier: "Asia/Seoul")
        else { return nil }
        calendar.timeZone = timeZone
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: today)
        return components
    }
}

