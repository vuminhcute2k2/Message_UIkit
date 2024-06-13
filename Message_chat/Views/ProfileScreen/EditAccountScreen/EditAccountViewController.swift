//
//  EditAccountViewController.swift
//  Message_chat
//
//  Created by Minh Vũ on 11/06/2024.
//

import UIKit
import FirebaseAuth
import FirebaseStorage
import FirebaseFirestore
class EditAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {

    @IBOutlet weak var backgroundColorView: UIView!
    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var imageAccount: UIImageView!
    @IBOutlet weak var borderIconView: UIView!
    @IBOutlet weak var popImage: UIImageView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cameraIconImage: UIImageView!
    var currentUser: User?
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        backgroundColorView.updateGradientFrame()
        setupCameraIconGesture()
        setupPopImageGesture()
        loadCurrentUser()
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        backgroundColorView.updateGradientFrame()
        borderView.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
        makeCircularViews()
        setupPopImageGesture()
    }
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundColorView.updateGradientFrame()
            self.borderView.updateBorderView(corners: [.topLeft, .topRight], radius: 18, borderColor: .white, borderWidth: 1)
        }, completion: nil)
    }
    private func setupUI() {
        backgroundColorView.applyGradient()
        fullnameTextField.borderStyle = .none
        phoneNumberTextField.borderStyle = .none
        dateTextField.borderStyle = .none
        fullnameTextField.addBottomLine(to: fullnameTextField)
        phoneNumberTextField.addBottomLine(to: phoneNumberTextField)
        dateTextField.addBottomLine(to: dateTextField)
        if let personIcon = UIImage(named: "image_person"),
           let phoneIcon = UIImage(named: "image_phone"),
           let dateIcon = UIImage(named: "image_date"){
            fullnameTextField.addRightIcon(personIcon)
            phoneNumberTextField.addRightIcon(phoneIcon)
            dateTextField.addRightIcon(dateIcon)
        } else {
            print("Failed images")
        }
        
    }
    private func makeCircularViews() {
        imageAccount.layer.cornerRadius = imageAccount.frame.width / 2
        imageAccount.layer.masksToBounds = true
        
        borderIconView.layer.cornerRadius = borderIconView.frame.width / 2
        borderIconView.layer.masksToBounds = true

    }
    private func setupPopImageGesture() {
        let tapGesture = UITapGestureRecognizer(target: self,
                                                action: #selector(handlePopImageTap))
        popImage.addGestureRecognizer(tapGesture)
        popImage.isUserInteractionEnabled = true
    }
    @objc private func handlePopImageTap() {
        AppRouters.homeTabBar.navigate(from: self)
    }
    private func setupCameraIconGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleCameraIconTap))
        cameraIconImage.addGestureRecognizer(tapGesture)
        cameraIconImage.isUserInteractionEnabled = true
    }
    @objc private func handleCameraIconTap() {
        let alertController = UIAlertController(title: "Chọn Ảnh", message: nil, preferredStyle: .actionSheet)
        
        let choosePhotoAction = UIAlertAction(title: "Chọn từ Thư viện", style: .default) { _ in
            self.openPhotoLibrary()
        }
        let takePhotoAction = UIAlertAction(title: "Chụp Ảnh", style: .default) { _ in
            self.openCamera()
        }
        let cancelAction = UIAlertAction(title: "Hủy", style: .cancel, handler: nil)
        
        alertController.addAction(choosePhotoAction)
        alertController.addAction(takePhotoAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
    func loadCurrentUser() {
        FirebaseService.shared.loadCurrentUser { [weak self] user in
            if let user = user {
                self?.currentUser = user
                self?.populateUserData(user)
            }
        }
    }
    private func openPhotoLibrary() {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .photoLibrary
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Thư viện ảnh không khả dụng")
        }
    }
    
    private func openCamera() {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            present(imagePicker, animated: true, completion: nil)
        } else {
            print("Camera không khả dụng")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            imageAccount.image = selectedImage // Gán ảnh đã chọn cho imageAccount
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveButtonTapped(_ sender: Any) {
        guard let fullname = fullnameTextField.text,
              let phoneNumber = phoneNumberTextField.text,
              let birthday = dateTextField.text,
              let image = imageAccount.image else {
            return
        }
        guard var updatedUser = currentUser else {
            print("No current user")
            return
        }
        updatedUser.fullName = fullname
        updatedUser.numberPhone = phoneNumber
        updatedUser.birthday = birthday
        FirebaseService.shared.uploadImageAndUpdateUser(updatedUser, image: image) { result in
            switch result {
            case .success:
                print("User updated successfully")
            case .failure(let error):
                print("Error updating user: \(error.localizedDescription)")
            }
        }
    }
    private func populateUserData(_ user: User) {
        fullnameTextField.text = user.fullName
        phoneNumberTextField.text = user.numberPhone
        dateTextField.text = user.birthday
        // Load image User
        if let imageURL = URL(string: user.image) {
            DispatchQueue.global().async {
                if let imageData = try? Data(contentsOf: imageURL) {
                    if let image = UIImage(data: imageData) {
                        DispatchQueue.main.async {
                            self.imageAccount.image = image
                        }
                    }
                }
            }
        }
    }

}
