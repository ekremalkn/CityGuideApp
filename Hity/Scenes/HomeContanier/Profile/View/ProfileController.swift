//
//  ProfileController.swift
//  Hity
//
//  Created by Ekrem Alkan on 19.02.2023.
//

import UIKit
import RxSwift

final class ProfileController: UIViewController {
    
    
    //MARK: - Properties
    
    private let profileView = ProfileView()
    private let profileViewModel = ProfileViewModel()
    private let disposeBag = DisposeBag()
    
    //MARK: - Observable
    
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
        creatingCallbacks()
        profileViewModel.fetchProfilePhoto()
        profileViewModel.fetchUserDisplayName()
    }
    
    private func configureNavBar() {
        title = "Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.isNavigationBarHidden = false
    }
    
    
    private func creatingCallbacks() {
        createPickerControllerLifeCycleCallback()
        createProfileViewButtonsCallbacks()
        createProfileViewModelCallbacks()
    }
    
    //MARK: - Creating Profile ViewButton Callbacks
    
    private func createProfileViewButtonsCallbacks() {
        
        profileView.editButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.isPickerLoading.onNext(true)
            self?.presentPickerController()
        }).disposed(by: disposeBag)
        
        profileView.changeUserNameButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ChangeUsernamePopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: disposeBag)
        
        profileView.changeEmailButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ChangeEmailPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: disposeBag)
        
        profileView.changePasswordButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = ResetPasswordController()
            controller.presentPopUpController(self)
        }).disposed(by: disposeBag)
        
        profileView.deleteAccountButton.rx.tap.subscribe(onNext: { [unowned self] in
            let controller = DeleteAccountPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: disposeBag)
        
        profileView.logOutButton.rx.tap.subscribe(onNext: {
            let controller = LogOutPopUpController()
            controller.presentPopUpController(self)
        }).disposed(by: disposeBag)
        
        
    }
    
    
    //MARK: - Creating ProfileViewModel Callbacks
    
    private func createProfileViewModelCallbacks() {
        profileViewModel.isUploadingSuccess.subscribe(onNext: { [weak self] _ in
            //get download url
            self?.profileViewModel.fetchProfilePhoto()
        }).disposed(by: disposeBag)
        
        
        profileViewModel.isDownloadingURLSuccess.subscribe(onNext: { [weak self] profileImageURL in
            self?.profileView.profileImageView.downloadSetImage(type: .onlyURL, url: profileImageURL, completion: {
                self?.isProfilePhotoLoading.onNext(false)
            })

        }).disposed(by: disposeBag)
        
        profileViewModel.isFetchingUserDisplayName.subscribe { [weak self] name in
            self?.profileView.userNameLabel.text = name
        }.disposed(by: disposeBag)
        
        profileViewModel.isSigningOutSuccess.subscribe { _ in
            let signInVC = SignInController()
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: true)
        }.disposed(by: disposeBag)
    }
    
    
    
}


//MARK: - UIImagePickerController

extension ProfileController {
    
    private func presentPickerController() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true) { [weak self] in
            self?.isPickerLoading.onNext(false)
        }
    }
    
    // picker view lifecycle callbacks
    
    private func createPickerControllerLifeCycleCallback() {
        isPickerLoading.subscribe { [weak self] loading in
            if loading {
                self?.profileView.pickerControllerActivityIndicator.startAnimating()
            } else {
                self?.profileView.pickerControllerActivityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
        
        isProfilePhotoLoading.subscribe { [weak self] loading in
            if loading {
                self?.profileView.profileImageActivityIndicator.startAnimating()
            } else {
                self?.profileView.profileImageActivityIndicator.stopAnimating()
            }
        }.disposed(by: disposeBag)
    }
    
    
}

//MARK: - UIImagePickerController Delegate

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) { [weak self] in
            self?.isProfilePhotoLoading.onNext(true)
        }
        
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        //upload image data
        self.profileViewModel.uploadImageDataToFirebaseStorage(imageData)
        
        
        
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



