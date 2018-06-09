//
//  DonorRegistrationViewController.swift
//  BloodDonation
//
//  Created by Olteanu Andrei on 03/06/2018.
//  Copyright © 2018 Olteanu Andrei. All rights reserved.
//

import UIKit

protocol DonorRegistrationFlowDelegate: class {
    func didTapRegistration(id: Int)
}

class DonorRegistrationViewController: BaseStoryboardViewController {

    // MARK: - Outlets
    @IBOutlet weak var firstNameTextField: RoundedBorderTextField!
    @IBOutlet weak var lastNameTextField: RoundedBorderTextField!
    @IBOutlet weak var cityTextField: RoundedBorderTextField!
    @IBOutlet weak var countyTextField: RoundedBorderTextField!
    @IBOutlet weak var ageButton: UIButton!
    @IBOutlet weak var birthDateButton: UIButton!
    @IBOutlet weak var addressTextField: RoundedBorderTextField!
    @IBOutlet weak var residenceTextField: RoundedBorderTextField!
    @IBOutlet weak var scrollView: UIScrollView!

    @IBOutlet weak var selectWeightButton: UIButton!
    @IBOutlet weak var selectBloodButton: UIButton!

    // Animations
    @IBOutlet weak var contentHeight: NSLayoutConstraint!
    private var activeTextField: UITextField?
    private var lastOffset: CGFloat?
    private var keyboardHeight: CGFloat = 0
    private var isDragging = false

    var userId: Int!
    var weight: Int!
    var bloodType: String!
    var age: Int!
    var date: String!

    weak var flowDelegate: DonorRegistrationFlowDelegate?

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }

    override func setupView() {
        super.setupView()
        Keyboardly.shared.delegate = self

        scrollView.delegate = self

        firstNameTextField.delegate = self
        lastNameTextField.delegate = self
        cityTextField.delegate = self
        countyTextField.delegate = self
        addressTextField.delegate = self
        residenceTextField.delegate = self
    }

    @IBAction func selectAgeButtonTapped(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Age", message: nil)

        let frameSizes: [CGFloat] = (18...30).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { _, _, index, _ in
            self.ageButton.setTitle(pickerViewValues[index.column][index.row], for: .normal)
            self.age = Int(frameSizes[index.row])
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    @IBAction func selectBirthDateButtonTapped(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Select date")
        let minDate = Calendar.current.date(byAdding: .year, value: -18, to: Date())
        let maxDate = Calendar.current.date(byAdding: .year, value: -30, to: Date())
        alert.addDatePicker(mode: .date, date: minDate, minimumDate: minDate, maximumDate: maxDate) { date in
            let stringDate = date.toString(format: .isoDate)
            self.date = stringDate
            self.birthDateButton.setTitle(stringDate, for: .normal)
        }
        alert.addAction(title: "OK", style: .cancel)
        alert.show()
    }

    @IBAction func selectBloodButtonTapped(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Blood Type", message: nil)

        let pickerViewValues: [[String]] = [["0", "1", "A2", "B3", "AB4"]]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { _, _, index, _ in
            self.selectBloodButton.setTitle(pickerViewValues[index.column][index.row], for: .normal)
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    @IBAction func selectWeightButtonTapped(_ sender: Any) {
        let alert = UIAlertController(style: .actionSheet, title: "Weight", message: nil)

        let frameSizes: [CGFloat] = (45...90).map { CGFloat($0) }
        let pickerViewValues: [[String]] = [frameSizes.map { Int($0).description }]
        let pickerViewSelectedValue: PickerViewViewController.Index = (column: 0, row: 0)

        alert.addPickerView(values: pickerViewValues, initialSelection: pickerViewSelectedValue) { _, _, index, _ in
            self.selectWeightButton.setTitle(pickerViewValues[index.column][index.row], for: .normal)
            self.weight = Int(frameSizes[index.row])
        }
        alert.addAction(title: "Done", style: .cancel)
        alert.show()
    }

    @IBAction func sendRegistrationButtonTapped(_ sender: Any) {
        AuthenticationService.shared.getMaxIdFor(type: .donor) { maxId in
            let donor = Donor(DID: NSNumber(value: maxId),
                              AID: NSNumber(value: self.userId),
                              firstName: self.firstNameTextField.text!,
                              lastName: self.lastNameTextField.text!,
                              age: NSNumber(value: self.age),
                              birthDate: self.date!,
                              address: self.addressTextField.text ?? "",
                              city: self.cityTextField.text ?? "",
                              county: self.countyTextField.text ?? "",
                              residence: self.residenceTextField.text ?? "",
                              rCity: "",
                              rCounty: "",
                              weight: NSNumber(value: self.weight),
                              lastDonation: nil,
                              bloodType: self.selectBloodButton.titleLabel?.text!)
            AuthenticationService.shared.createDonor(donor: donor.dictionary())
            self.flowDelegate?.didTapRegistration(id: maxId)
        }
    }
}

extension DonorRegistrationViewController: KeyboardlyDelegate {
    func keyboardWillShow(keyboardHeight: CGFloat) {
        self.keyboardHeight = keyboardHeight
    }

    func keyboardWillDissappear() {
    }
}

extension DonorRegistrationViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if isDragging {
            guard let lastOffset = self.lastOffset else { return }
            if abs(scrollView.contentOffset.y - lastOffset) < 20 {
                self.view.endEditing(true)
            }
        }
    }

    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isDragging = true
        lastOffset = scrollView.contentOffset.y
    }

    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        isDragging = false
    }
}

extension DonorRegistrationViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        let textFieldY = textField.convert(textField.center, to: view).y
        let middleOfScreen = UIScreen.main.bounds.size.width / 2
        if middleOfScreen > textFieldY {
            scrollView.setContentOffset(CGPoint(x: 0, y: middleOfScreen - textFieldY), animated: true)
        } else {
            scrollView.setContentOffset(CGPoint(x: 0, y: textFieldY - middleOfScreen), animated: true)
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
}
