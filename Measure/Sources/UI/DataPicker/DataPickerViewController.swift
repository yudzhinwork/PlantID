//
//  DataPickerViewController.swift
//  PlantID

import UIKit

enum DatePickerType {
    case watering
    case spraying
    case fertilize
    case time
    
    func title() -> String {
        switch self {
        case .watering:
            return "Next watering"
        case .spraying:
            return "Next Spraying"
        case .fertilize:
            return "Next Fertilize"
        case .time:
            return "Choose time to \nnotifications will arrive"
        }
    }
}

protocol DataPickerDelegate: AnyObject {
    func didSelectDate(_ controller: DataPickerViewController, date: Date, pickerType: DatePickerType)
}
final class DataPickerViewController: BaseViewController {
    
    @IBOutlet private weak var backgroundView: CornerView!
    @IBOutlet private weak var titleTextLabel: UILabel!
    @IBOutlet private weak var doneButton: UIButton!
    @IBOutlet private weak var pickerView: UIPickerView!
    
    private let timeUnits = ["days", "weeks", "months"]
    
    // Для времени
    private let hours = Array(1...12)
    private let minutes = Array(0...59).map { String(format: "%02d", $0) }
    private let amPm = ["AM", "PM"]
    
    var pickerType: DatePickerType!
    var indexPath: IndexPath!
    
    weak var delegate: DataPickerDelegate?
    
    private var selectedTimeAmount = 1
    private var selectedTimeUnit = "days"
    
    // Для времени
    private var selectedHour = 1
    private var selectedMinute = "00"
    private var selectedAmPm = "AM"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        }
    }
    
    func configure() {
        backgroundView.corners = [.topLeft, .topRight]
        Theme.buttonStyle(doneButton, title: "Continue")
        titleTextLabel.text = pickerType.title()
        pickerView.reloadAllComponents()
    }
    
    @IBAction func closeAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    @IBAction func doneAction(_ sender: UIButton) {
        let selectedDate: Date
        if pickerType == .time {
            selectedDate = calculateTime()
            removePreviousNotifications()
            scheduleLocalNotification(for: selectedDate)
        } else {
            selectedDate = calculateDate()
        }
        delegate?.didSelectDate(self, date: selectedDate, pickerType: pickerType)
        self.dismiss(animated: true)
    }
    
    func calculateDate() -> Date {
        let currentDate = Date()
        var dateComponent = DateComponents()
        
        switch selectedTimeUnit {
        case "days":
            dateComponent.day = selectedTimeAmount
        case "weeks":
            dateComponent.weekOfYear = selectedTimeAmount
        case "months":
            dateComponent.month = selectedTimeAmount
        default:
            break
        }
        
        // Добавляем интервал к текущей дате
        return Calendar.current.date(byAdding: dateComponent, to: currentDate) ?? currentDate
    }
    
    func calculateTime() -> Date {
        var dateComponent = DateComponents()
        dateComponent.hour = selectedHour + (selectedAmPm == "PM" ? 12 : 0)
        dateComponent.minute = Int(selectedMinute)
        
        return Calendar.current.date(from: dateComponent) ?? Date()
    }
    
    func removePreviousNotifications() {
        let center = UNUserNotificationCenter.current()
        center.removeAllPendingNotificationRequests()
    }
    
    func scheduleLocalNotification(for date: Date) {
        let center = UNUserNotificationCenter.current()
        
        // Создаем контент уведомления
        let content = UNMutableNotificationContent()
        content.title = "Plant Care Reminder"
        content.body = "Time to water, mist, or fertilize your plant!"
        
        content.sound = .default
        
        // Создаем триггер на выбранную дату и время
        let triggerDate = Calendar.current.dateComponents([.hour, .minute], from: date)
        let trigger = UNCalendarNotificationTrigger(dateMatching: triggerDate, repeats: true) // Установите повторение на true для ежедневных уведомлений
        
        // Создаем запрос на уведомление с уникальным идентификатором
        let request = UNNotificationRequest(identifier: "NotificationIdentifier", content: content, trigger: trigger)
        
        // Добавляем запрос в центр уведомлений
        center.add(request) { error in
            if let error = error {
                print("Error scheduling notification: \(error.localizedDescription)")
            }
        }
    }

}

extension DataPickerViewController: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerType == .time {
            return 3 // Часы, минуты, AM/PM
        } else {
            return 2 // Время (количество и единицы измерения)
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerType == .time {
            switch component {
            case 0:
                return hours.count
            case 1:
                return minutes.count
            case 2:
                return amPm.count
            default:
                return 0
            }
        } else {
            if component == 0 {
                return 99
            } else {
                return timeUnits.count
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerType == .time {
            switch component {
            case 0:
                selectedHour = hours[row]
            case 1:
                selectedMinute = minutes[row]
            case 2:
                selectedAmPm = amPm[row]
            default:
                break
            }
        } else {
            if component == 0 {
                selectedTimeAmount = row + 1
            } else {
                selectedTimeUnit = timeUnits[row]
            }
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let title: String
        
        if pickerType == .time {
            switch component {
            case 0:
                title = "\(hours[row])"
            case 1:
                title = "\(minutes[row])"
            case 2:
                title = amPm[row]
            default:
                title = ""
            }
        } else {
            if component == 0 {
                title = "\(row + 1)"
            } else {
                title = timeUnits[row]
            }
        }
        
        let attributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(hexString: "#12AD5C")
        ]
        
        return NSAttributedString(string: title, attributes: attributes)
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        if pickerType == .time {
            switch component {
            case 0:
                return 60 // Часы
            case 1:
                return 60 // Минуты
            case 2:
                return 80 // AM/PM
            default:
                return 50
            }
        } else {
            if component == 0 {
                return 50
            } else {
                return 150
            }
        }
    }
}
