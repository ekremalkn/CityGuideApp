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
    
    //MARK: - Lifecycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
        // Do any additional setup after loading the view.
    }
    
    //MARK: - Configure ViewController
    
    private func configureViewController() {
        view.backgroundColor = .white
        view = profileView
        configureNavBar()
        creatingCallbacks()
        profileViewModel.fetchProfilePhoto()
    }
    
    private func configureNavBar() {
            navigationController?.isNavigationBarHidden = false
        }
    
    
    private func creatingCallbacks() {
        createProfileViewButtonsCallbacks()
        createProfileViewModelCallbacks()
    }
    
    //MARK: - Creating Profile ViewButton Callbacks

    private func createProfileViewButtonsCallbacks() {
        
        profileView.editButton.rx.tap.subscribe(onNext: { [weak self] in
            self?.profileView.pickerControllerActivityIndicator.startAnimating()
            self?.presentPickerController()
        }).disposed(by: disposeBag)
        
        
        profileView.changePasswordButton.rx.tap.subscribe(onNext: { [weak self] in
            let controller = ResetPasswordController()
            self?.present(controller, animated: true)
        }).disposed(by: disposeBag)
        
        profileView.logOutButton.rx.tap.subscribe(onNext: {
            self.profileViewModel.signOut()
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
                print("fotoğraf ekleme işi bitii")
                self?.profileView.profileImageActivityIndicator.stopAnimating()
            })
        }).disposed(by: disposeBag)
        
        
        profileViewModel.isSigningOutSuccess.subscribe { _ in
            let signInVC = SignInController()
            signInVC.modalPresentationStyle = .fullScreen
            self.present(signInVC, animated: true)
        }.disposed(by: disposeBag)
    }
    


}


//MARK: - UIImagePicker

extension ProfileController {
    
    private func presentPickerController() {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.allowsEditing = true
        picker.delegate = self
        self.present(picker, animated: true) {
            self.profileView.pickerControllerActivityIndicator.stopAnimating()
        }
    }
    
    
}

//MARK: - UIImagePickerController Delegate

extension ProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        profileView.profileImageActivityIndicator.startAnimating()
        guard let image = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else { return }
        guard let imageData = image.pngData() else { return }
        //upload image data
        profileViewModel.uploadImageDataToFirebaseStorage(imageData)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    
}



