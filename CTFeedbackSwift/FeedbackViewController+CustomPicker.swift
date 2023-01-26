//
//  FeedbackViewController+CustomPicker.swift
//  CTFeedbackSwift
//
//  Created by Mykhailishyn, Mykola (ADM) on 09.01.2023.
//

import UIKit

protocol CustomPickerPresenter {
    func addPicker(data: [TopicProtocol], selectedItem: TopicProtocol?)
}

extension FeedbackViewController: CustomPickerPresenter {
    private var containerView: UIView {
        // It is better not to use inner view of
        // UITableViewController if it is possible
        navigationController?.view ?? view
    }
    
    func addPicker(data: [TopicProtocol], selectedItem: TopicProtocol?) {
        customPickerContainer?.removeFromSuperview()
        customPickerData = data

        let pickerContainer = UIView(frame: CGRect(x: 0, y: containerView.frame.size.height, width: containerView.frame.size.width, height: 400))
        pickerContainer.backgroundColor = configuration.style?.backgroundColor ?? .white
        
        let picker = UIPickerView()
        picker.delegate = self
        picker.dataSource = self
        picker.isHidden = false
        var frame = picker.frame
        frame.origin.y = 40
        frame.size.width = containerView.frame.size.width
        picker.frame = frame
        pickerContainer.addSubview(picker)
        self.customPicker = picker
        
        let toolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: containerView.frame.size.width, height: 44))
        toolbar.barTintColor = UIColor(red: 176/255, green: 213/255, blue: 213/255, alpha: 1.0)
        toolbar.tintColor = .white
        
        var barItems = [UIBarButtonItem]()
        let flex = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        barItems.append(flex)
        
        let barButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(choseSettings))
        let font = UIFont(name: "HelveticaNeue", size: 16) ?? .systemFont(ofSize: 16)
        barButton.setTitleTextAttributes([.font: font, .foregroundColor: UIColor.black], for: .normal)
        barItems.append(barButton)
        
        toolbar.setItems(barItems, animated: true)
        pickerContainer.addSubview(toolbar)

        containerView.addSubview(pickerContainer)
        containerView.bringSubviewToFront(pickerContainer)
        self.customPickerContainer = pickerContainer
        
        if let selectedItem = selectedItem,
            let index = data.firstIndex(where: { $0.localizedTitle == selectedItem.localizedTitle }) {
            picker.selectRow(index, inComponent: 0, animated: false)
        }
        picker.showsSelectionIndicator = true
        showPickerViewContainer()
    }
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if customPickerContainer?.alpha == 1.0 {
            hidePickerViewContainer()
        }
    }
    
    @objc private func choseSettings(_ sender: Any) {
        hidePickerViewContainer()
    }
    
    private func showPickerViewContainer() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.customPickerContainer?.frame = CGRect(x: 0, y: self.containerView.frame.size.height-200, width: self.containerView.frame.size.width, height: 400)
            self.customPickerContainer?.alpha = 1.0
        }, completion: nil)
    }
    
    private func hidePickerViewContainer() {
        guard let row = customPicker?.selectedRow(inComponent: 0) else {
            return
        }
        feedbackEditingService.update(selectedTopic: customPickerData[row])
        
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveLinear, animations: {
            self.customPickerContainer?.frame = CGRect(x: 0, y: self.containerView.frame.size.height, width: self.containerView.frame.size.width, height: 400)
            self.customPickerContainer?.alpha = 0.0
        }, completion: nil)
    }
}

extension FeedbackViewController: UIPickerViewDelegate {
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        customPickerData[row].localizedTitle
    }
}

extension FeedbackViewController: UIPickerViewDataSource {
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }
    
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        customPickerData.count
    }
}
