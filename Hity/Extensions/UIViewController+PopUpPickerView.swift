////
////  UIViewController+PopUpPickerView.swift
////  Hity
////
////  Created by Ekrem Alkan on 18.02.2023.
////
//
//import UIKit
//import RxSwift
//
//
//extension UIViewController {
//
//    func createDistancePopUpPickerView(_ pickerView: UIPickerView, _ button: UIButton, _ observableDistance: Observable<[String]>) -> UIAlertController {
//        self.preferredContentSize = CGSize(width: self.view.frame.width - 10, height: self.view.frame.height / 4)
//        self.view.addSubview(pickerView)
//        pickerView.snp.makeConstraints { make in
//            make.centerX.equalTo(self.view.snp.centerX)
//            make.centerY.equalTo(self.view.snp.centerY)
//        }
//
//        let alert = UIAlertController(title: "Select Search Distance", message: "", preferredStyle: .actionSheet)
//
//        alert.popoverPresentationController?.sourceView = button
//        alert.popoverPresentationController?.sourceRect = button.bounds
//
//        alert.setValue(self, forKey: "contentViewController")
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { UIAlertAction in
//        }))
//
//        pickerView.selectRow(5, inComponent: 0, animated: true)
//        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { UIAlertAction in
//            let distances = observableDistance.subscribe { distances in
//                let selectedDistance = distances[pickerView.selectedRow(inComponent: 0)]
//                button.setTitle("about in: \(selectedDistance)m", for: .normal)
//
//            }
//        }))
//        pickerView.selectRow(pickerView.selectedRow(inComponent: 0), inComponent: 0, animated: true)
//        return alert
//    }
//
//    func createSortPopUpPickerView(_ pickerView: UIPickerView, _ button: UIButton, observableSort: Observable<[SortType]>) -> UIAlertController {
//        self.preferredContentSize = CGSize(width: self.view.frame.width - 10, height: self.view.frame.height / 4)
//        self.view.addSubview(pickerView)
//        pickerView.snp.makeConstraints { make in
//            make.centerX.equalTo(self.view.snp.centerX)
//            make.centerY.equalTo(self.view.snp.centerY)
//        }
//
//        let alert = UIAlertController(title: "Sorted by:", message: "", preferredStyle: .actionSheet)
//
//        alert.popoverPresentationController?.sourceView = button
//        alert.popoverPresentationController?.sourceRect = button.bounds
//
//        alert.setValue(self, forKey: "contentViewController")
//        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { UIAlertAction in
//        }))
//
//        pickerView.selectRow(2, inComponent: 0, animated: true)
//        alert.addAction(UIAlertAction(title: "Select", style: .default, handler: { UIAlertAction in
//            let sortType = observableSort.subscribe { sortType in
//                switch sortType {
//
//                case .next(let sortType):
//                    let selectedSortType =  sortType[pickerView.selectedRow(inComponent: 0)]
//                default:
//                    break
//                }
//
//            }
//        }))
//
//
//        pickerView.selectRow(pickerView.selectedRow(inComponent: 0), inComponent: 0, animated: true)
//        return alert
//    }
//
//
//}
