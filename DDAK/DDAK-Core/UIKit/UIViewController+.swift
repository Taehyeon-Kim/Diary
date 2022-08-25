//
//  UIViewController+.swift
//  DDAK-Core
//
//  Created by taekki on 2022/08/23.
//

import UIKit

extension UIViewController {

    public func presentAlert(
        title: String,
        message: String? = nil,
        isCancelActionIncluded: Bool = false,
        preferredStyle style: UIAlertController.Style = .alert,
        handler: ((UIAlertAction) -> Void)? = nil
    )
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        let confirmAction = UIAlertAction(title: "확인", style: .default, handler: handler)
        alert.addAction(confirmAction)
        if isCancelActionIncluded {
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(cancelAction)
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension UIViewController {
    
    public enum TransitionStyle {
        case present
        case presentNavigation
        case presentFullNavigation
        case push
    }
    
    public func transition<T: UIViewController>(_ viewController: T, transitionStyle: TransitionStyle = .present) {
        
        switch transitionStyle {
        case .present:
            self.present(viewController, animated: true)
            
        case .presentNavigation:
            let navi = UINavigationController(rootViewController: viewController)
            self.present(navi, animated: true)
            
        case .presentFullNavigation:
            self.navigationController?.pushViewController(viewController, animated: true)
            
        case .push:
            let navi = UINavigationController(rootViewController: viewController)
            navi.modalPresentationStyle = .fullScreen
            self.present(navi, animated: true)
        }
    }
}

extension UIViewController {
    
    public func getDocumentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil }
        return documentDirectory
    }
    
    public func loadImageFromDocument(fileName: String) -> UIImage? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로. 이미지를 저장할 위치
        
        if FileManager.default.fileExists(atPath: fileURL.path) {
            return UIImage(contentsOfFile: fileURL.path)
        } else {
            return UIImage(systemName: "star.fill")
        }
    }
    
    public func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로. 이미지를 저장할 위치
        guard let data = image.jpegData(compressionQuality: 0.5) else { return } // 용량을 줄이기 위함
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save err", error)
        }
    }
    
    public func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로. 이미지를 저장할 위치
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            
        } catch let error {
            Logger.log(error)
        }
    }
    
    public func fetchDocumentZipFile() {
        do {
            guard let path = getDocumentDirectoryPath() else { return }
            
            let docs = try FileManager.default.contentsOfDirectory(at: path, includingPropertiesForKeys: nil)
            print("docs: \(docs)")
            
            let zip = docs.filter { $0.pathExtension == "zip" }
            print("zip: \(zip)")
            
            let result = zip.map { $0.lastPathComponent }
            print("result: \(result)")
            
        } catch {
            print("Error")
        }
    }
}
