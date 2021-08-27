//
//  ImagePicker.swift
//  RAWG
//
//  Created by Iman Faizal on 27/08/21.
//

import UIKit

extension EditProfileViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    func imagePickerController(
        _ picker: UIImagePickerController,
        didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]
    ) {
        if let result = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.ivPhotos.contentMode = .scaleToFill
            self.ivPhotos.image = result
            dismiss(animated: true, completion: nil)
        } else {
            let alert = UIAlertController(
                title: "Failed",
                message: "Image can't be loaded.",
                preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
