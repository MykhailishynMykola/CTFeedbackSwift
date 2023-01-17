//
//  FeedbackViewController.swift
//  CTFeedbackSwift
//
//  Created by 和泉田 領一 on 2017/09/07.
//  Copyright © 2017 CAPH TECH. All rights reserved.
//

import UIKit
import Dispatch
import MessageUI
import Photos

open class FeedbackViewController: UITableViewController {
    public var mailComposeDelegate:           MFMailComposeViewControllerDelegate?
    public var presentPrivacyPolicy:          (() -> ())?
    public var replacedFeedbackSendingAction: ((Feedback) -> ())?
    public var feedbackDidFailed:             ((MFMailComposeResult, NSError) -> ())?
    public var configuration:                 FeedbackConfiguration {
        didSet { updateDataSource(configuration: configuration) }
    }
    public var backgroundImage: UIImage?
    public var consents: [ConsentItemType: Bool] = [.toBeContacted: false,
                                                    .storageAndProcessing: false]

    internal var wireframe: FeedbackWireframeProtocol!

    private let cellFactories = [AnyCellFactory(UserEmailCell.self),
                                 AnyCellFactory(TopicCell.self),
                                 AnyCellFactory(BodyCell.self),
                                 AnyCellFactory(AttachmentCell.self),
                                 AnyCellFactory(DeviceNameCell.self),
                                 AnyCellFactory(SystemVersionCell.self),
                                 AnyCellFactory(AppNameCell.self),
                                 AnyCellFactory(AppVersionCell.self),
                                 AnyCellFactory(AppBuildCell.self),
                                 AnyCellFactory(ConsentCell.self),
                                 AnyCellFactory(ConsentDescriptionCell.self),
                                 AnyCellFactory(ShortInfoCell.self)]

    lazy var feedbackEditingService: FeedbackEditingServiceProtocol = {
        return FeedbackEditingService(editingItemsRepository: configuration.dataSource,
                                      feedbackEditingEventHandler: self)
    }()

    private var popNavigationBarHiddenState: (((Bool) -> ()) -> ())?
    private var attachmentDeleteAction: (() -> ())? {
        return feedbackEditingService.hasAttachedMedia ?
            { self.feedbackEditingService.update(attachmentMedia: .none) } : .none
    }
    
    weak var customPickerContainer: UIView?
    weak var customPicker: UIPickerView?
    var customPickerData = [TopicProtocol]()

    public init(configuration: FeedbackConfiguration) {
        self.configuration = configuration

        if #available(iOS 13, *) {
            super.init(style: .insetGrouped)
        } else {
            super.init(style: .grouped)
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)

        wireframe = FeedbackWireframe(viewController: self,
                                      transitioningDelegate: self,
                                      imagePickerDelegate: self,
                                      mailComposerDelegate: self,
                                      useCustomTopicPicker: configuration.useCustomTopicPicker,
                                      skipCameraAttachment: configuration.skipCameraAttachment,
                                      customPickerPresenter: self)
    }

    public required init?(coder aDecoder: NSCoder) { fatalError() }

    public override func viewDidLoad() {
        super.viewDidLoad()

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 44.0
        tableView.keyboardDismissMode = .onDrag
        tableView.cellLayoutMarginsFollowReadableWidth = true

        cellFactories.forEach(tableView.register(with:))
        updateDataSource(configuration: configuration)

        title = CTLocalizedString("CTFeedback.Feedback")
        navigationItem
            .rightBarButtonItem = UIBarButtonItem(title: CTLocalizedString("Contactform_sendbtn"),
                                                  style: .plain,
                                                  target: self,
                                                  action: #selector(mailButtonTapped(_:)))
        navigationItem.rightBarButtonItem?.isEnabled = false
        
        if let backgroundImage = backgroundImage {
            let imageView = UIImageView(frame: view.frame)
            imageView.image = backgroundImage
            tableView.backgroundView = imageView
        }
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        popNavigationBarHiddenState = push(navigationController?.isNavigationBarHidden)
        navigationController?.isNavigationBarHidden = false

        configureLeftBarButtonItem()
    }

    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        popNavigationBarHiddenState?({ self.navigationController?.isNavigationBarHidden = $0 })
    }

    public override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension FeedbackViewController {
    // MARK: - UITableViewDataSource

    override public func numberOfSections(in tableView: UITableView) -> Int {
        return configuration.dataSource.numberOfSections
    }

    override public func tableView(_ tableView: UITableView,
                                   numberOfRowsInSection section: Int) -> Int {
        return configuration.dataSource.section(at: section).count
    }

    override public func tableView(_ tableView: UITableView,
                                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = configuration.dataSource.section(at: indexPath.section)[indexPath.row]
        let cell = tableView.dequeueCell(to: item,
                                         from: cellFactories,
                                         for: indexPath,
                                         eventHandler: self)
        return cell
    }
    
    override public func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        let headerItem = configuration.dataSource.section(at: section)
        return headerItem.title == nil ? 0 : 44
    }
    
    override public func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 18)
        label.text = configuration.dataSource.section(at: section).title
        label.textColor = .white
        headerView.embed(label, insets: .init(top: 0, left: -10, bottom: 0, right: 0))
        
        return headerView
    }
}

private extension UIView {
    func embed(_ view: UIView, insets: UIEdgeInsets) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
        leftAnchor.constraint(equalTo: view.leftAnchor, constant: insets.left).isActive = true
        view.rightAnchor.constraint(equalTo: rightAnchor, constant: insets.right).isActive = true
        topAnchor.constraint(equalTo: view.topAnchor, constant: insets.top).isActive = true
        view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: insets.bottom).isActive = true
    }
}

extension FeedbackViewController {
    // MARK: - UITableViewDelegate

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = configuration.dataSource.section(at: indexPath.section)[indexPath.row]
        switch item {
        case _ as TopicItem:
            wireframe.showTopicsView(with: feedbackEditingService)
        case _ as AttachmentItem:
            guard let cell = tableView.cellForRow(at: indexPath) else {
                fatalError("Can't get cell");
            }
            wireframe.showAttachmentActionSheet(
                cellRect: cell.superview!.convert(cell.frame, to: view),
                authorizePhotoLibrary: { completion in
                    PHPhotoLibrary.requestAuthorization { status in
                        DispatchQueue.main.async {
                            completion(status == .authorized)
                        }
                    }
                },
                authorizeCamera: { completion in
                    AVCaptureDevice.requestAccess(for: AVMediaType.video) { result in
                        DispatchQueue.main.async {
                            completion(result)
                        }
                    }
                },
                deleteAction: attachmentDeleteAction)
        default: ()
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension FeedbackViewController: FeedbackEditingEventProtocol {
    public func updated(at indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}

extension FeedbackViewController: UserEmailCellEventProtocol {
    func userEmailTextDidChange(_ text: String?) {
        feedbackEditingService.update(userEmailText: text)
    }
}

extension FeedbackViewController: BodyCellEventProtocol {
    func bodyCellHeightChanged() {
        tableView.beginUpdates()
        tableView.endUpdates()
    }

    func bodyTextDidChange(_ text: String?) {
        feedbackEditingService.update(bodyText: text)
    }
}

extension FeedbackViewController: AttachmentCellEventProtocol {
    func showImage(of item: AttachmentItem) {
        // Pending
    }
}

extension FeedbackViewController: ConsentCellEventProtocol {
    func toggleConsent(type: ConsentItemType, to enabled: Bool) {
        consents[type] = enabled
        let consentDisabled = consents.contains(where: { $0.value == false })
        navigationItem.rightBarButtonItem?.isEnabled = !consentDisabled
    }
}

extension FeedbackViewController: ConsentDescriptionCellEventProtocol {
    func showPrivacyPolicy() {
        presentPrivacyPolicy?()
    }
}

extension FeedbackViewController {
    private func configureLeftBarButtonItem() {
        if let navigationController = navigationController {
            if navigationController.viewControllers[0] === self {
                navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                                   target: self,
                                                                   action: #selector(cancelButtonTapped(_:)))
            } else {
                // Keep the standard back button instead of "Cancel"
                navigationItem.leftBarButtonItem = .none
            }
        } else {
            navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel,
                                                               target: self,
                                                               action: #selector(cancelButtonTapped(_:)))
        }
    }

    private func updateDataSource(configuration: FeedbackConfiguration) { tableView.reloadData() }

    @objc func cancelButtonTapped(_ sender: Any) {
        if let navigationController = navigationController {
            if navigationController.viewControllers.first === self {
                wireframe.dismiss(completion: .none)
            } else {
                wireframe.pop()
            }
        } else {
            wireframe.dismiss(completion: .none)
        }
    }

    @objc func mailButtonTapped(_ sender: Any) {
        do {
            let feedback = try feedbackEditingService.generateFeedback(configuration: configuration)
            (replacedFeedbackSendingAction ?? wireframe.showMailComposer(with:))(feedback)
        } catch {
            wireframe.showFeedbackGenerationError()
        }
    }

    private func terminate(_ result: MFMailComposeResult, _ error: Error?) {
        if presentingViewController?.presentedViewController != .none {
            wireframe.dismiss(completion: .none)
        } else {
            navigationController?.popViewController(animated: true)
        }

        if result == .failed, let error = error as NSError? {
            feedbackDidFailed?(result, error)
        }
    }
}

extension FeedbackViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    public func imagePickerController(_ picker: UIImagePickerController,
                                      didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Local variable inserted by Swift 4.2 migrator.
        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)
        
        switch getMediaFromImagePickerInfo(info) {
        case let media?:
            feedbackEditingService.update(attachmentMedia: media)
            wireframe.dismiss(completion: .none)
        case _:
            wireframe.dismiss(completion: .none)
            wireframe.showUnknownErrorAlert()
        }
    }

    public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        wireframe.dismiss(completion: .none)
    }
}

extension FeedbackViewController: MFMailComposeViewControllerDelegate {
    public func mailComposeController(_ controller: MFMailComposeViewController,
                                      didFinishWith result: MFMailComposeResult,
                                      error: Error?) {
        if result == .failed, let error = error as NSError? {
            wireframe.showMailComposingError(error)
        }

        wireframe.dismiss(completion:
                          result == .cancelled ? .none : { self.terminate(result, error) })

        mailComposeDelegate?.mailComposeController?(controller, didFinishWith: result, error: error)
    }
}

extension FeedbackViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController,
                                       presenting: UIViewController?,
                                       source: UIViewController) -> UIPresentationController? {
        return DrawUpPresentationController(presentedViewController: presented,
                                            presenting: presenting)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
