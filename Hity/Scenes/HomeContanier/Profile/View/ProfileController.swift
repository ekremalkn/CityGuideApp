//
//  ProfileController.swift
//  Hity
//
//  Created by Ekrem Alkan on 19.02.2023.
//

import UIKit
import Photos
import PhotosUI
import RxSwift

final class ProfileController: UIViewController {
    
    
    //MARK: - Properties
    
    private let profileView = ProfileView()
    private let profileViewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Observable Variables
    
    let isPickerLoading = PublishSubject<Bool>()
    let isProfilePhotoLoading = PublishSubject<Bool>()
    
    
    //MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view.backgroundColor = .clear
        addSubview()
        setupConstraints()
        configureNavBar()
        createCallbacks()
        fetchUserData()
        
    }
    
    private func configureNavBar() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Create Callbacks
    
    private func createCallbacks() {
        createPhotoPickerControllerLifeCycleCallback()
        createProfileViewButtonCallbacks()
        createProfileViewModelCallbacks()
    }
    
    //MARK: - Fetch User Display Data
    
    private func fetchUserData() {
        profileViewModel.fetchProfilePhoto()
        profileViewModel.fetchUserDisplayName()
    }
    
    
    //MARK: - Creating ProfileView Button Callbacks
    
    private func createProfileViewButtonCallbacks() {
        
        // Profile Photo Edit Button
        profileView.editButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.isPickerLoading.onNext(true)
            self?.presentPHpickerController()
        }).disposed(by: profileView.disposeBag)
        
        // Change Username Button
        profileView.changeUserNameButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ChangeUsernamePopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: profileView.disposeBag)
        
        // Change Email Button
        profileView.changeEmailButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ChangeEmailPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: profileView.disposeBag)
        
        // Change Password Button
        profileView.changePasswordButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ResetPasswordController()
            controller.presentPopUpController(self)
        }).disposed(by: profileView.disposeBag)
        
        // Delete Account Button
        profileView.deleteAccountButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = DeleteAccountPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: profileView.disposeBag)
        
        // Log Out Button
        profileView.logOutButton.rx.tap.subscribe(onNext: {
            let controller = LogOutPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: profileView.disposeBag)
        
        
    }
    
    
    //MARK: - Creating ProfileViewModel Callbacks
    
    private func createProfileViewModelCallbacks() {
        
        // Profile photo uploading Success
        profileViewModel.isUploadingSuccess.subscribe(onNext: { [weak self] _ in
            //get download url
            self?.profileViewModel.fetchProfilePhoto()
        }).disposed(by: disposeBag)
        
        // Profile photo url downloading success
        profileViewModel.isDownloadingURLSuccess.subscribe(onNext: { [weak self] profileImageURL in
            self?.profileView.profileImageView.downloadSetImage(type: .onlyURL, url: profileImageURL, completion: {
                self?.isProfilePhotoLoading.onNext(false)
            })
        }).disposed(by: disposeBag)
        
        // Fetching User Displayname Success
        profileViewModel.isFetchingUserDisplayName.subscribe { [weak self] name in
            self?.profileView.userNameLabel.text = name
        }.disposed(by: disposeBag)
        
        // Sign Out Success
        profileViewModel.isSigningOutSuccess.subscribe { _ in
            let signInVC = SignInController()
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
    //MARK: - PickerController(Loading, Load, Cancelled), Photo(Uploading, Uploaded, Downloading, Downloaded, Setted)
    
    private func createPhotoPickerControllerLifeCycleCallback() {
        
        // Picker Controller Activity Indicator Start / Stop
        isPickerLoading.subscribe { [weak self] loading in
            if loading {
                self?.profileView.pickerControllerActivityIndicator.startAnimating()
            } else {
                self?.profileView.pickerControllerActivityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        // Profile Photo Activity Indicator Start / Stop
        isProfilePhotoLoading.subscribe { [weak self] loading in
            if loading {
                DispatchQueue.main.async {
                    self?.profileView.profileImageActivityIndicator.startAnimating()
                }
            } else {
                self?.profileView.profileImageActivityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
    }
    
}

//MARK: - if #available(iOS 14.0, *) PHPickerController

extension ProfileController: PHPickerViewControllerDelegate {
    
    // Present PHpicker Controller
    private func presentPHpickerController() {
        if #available(iOS 14.0, *) {
            var config = PHPickerConfiguration(photoLibrary: .shared())
            config.selectionLimit = 1
            config.filter = .images
            let vc = PHPickerViewController(configuration: config)
            vc.delegate = self
            present(vc, animated: true) {
                self.isPickerLoading.onNext(false)
                
            }
            
        } else {
            presentPickerController()
        }
        
    }
    
    @available(iOS 14, *)
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        
        results.forEach { result in
            
            result.itemProvider.loadObject(ofClass: UIImage.self) { [weak self] reading, error in
                guard let image = reading as? UIImage, error == nil else { return }
                
                guard let imageData = image.jpegData(compressionQuality: 0.3) else { return }
                //upload image data
                self?.isProfilePhotoLoading.onNext(true)
                self?.profileViewModel.uploadImageDataToFirebaseStorage(imageData)
            }
        }
    }
    
    
    
    
}

//MARK: - if not #available(iOS 14.0, *) UIImagePickerController

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // Present UIImagePickerController
    private func presentPickerController() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        
        self.present(picker, animated: true) { [weak self] in
            self?.isPickerLoading.onNext(false)
        }
        
    }
    
    // Did Finish Picking Media
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.jpegData(compressionQuality: 0.5) else { return }
        //upload image data
        self.isProfilePhotoLoading.onNext(true)
        self.profileViewModel.uploadImageDataToFirebaseStorage(imageData)
        
        
        // Did Cancel Picking
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
        
        
    }
}

//MARK: - SearchView AddSubview / Constraints

extension ProfileController {
    
    //MARK: - AddSubview
    
    private func addSubview() {
        view.addSubview(profileView)
    }
    
    //MARK: - Setup Constraints
    
    private func setupConstraints() {
        profileView.snp.makeConstraints { make in
            make.top.leading.bottom.equalTo(view)
            make.width.equalTo(view.safeAreaLayoutGuide.snp.width).multipliedBy(0.78)
        }
    }
}



