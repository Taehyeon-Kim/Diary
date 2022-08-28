//
//  DiaryRepository.swift
//  DDAK
//
//  Created by taekki on 2022/08/26.
//

import UIKit

import DDAK_Core
import RealmSwift

protocol DiaryRepositoryType {
    var count: Int { get }
    func fetch() -> Results<Diary>
    func fetch(by date: Date) -> Results<Diary>
    func sort(by byKeyPath: String) -> Results<Diary>
    func filter() -> Results<Diary>
    func write(photoURLString: String, diaryTitle: String, diaryContent: String, diaryDate: Date, createdAt: Date, completion: ((Diary) -> ())?)
    func update(item: Diary, completion: @escaping ((Diary) -> ()))
    func delete(item: Diary)
}

struct DiaryRepository: DiaryRepositoryType {

    private let localRealm = try! Realm()
    
    var count: Int {
        return localRealm.objects(Diary.self).count
    }
    
    /// 읽어오기
    func fetch() -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: true)
    }
    
    /// 날짜 기준으로 읽어오기
    func fetch(by date: Date) -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("diaryDate >= %@ AND diaryDate < %@", date, Date(timeInterval: 86400, since: date))
    }
    
    /// 정렬
    func sort(by byKeyPath: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: byKeyPath, ascending: false)
    }
    
    /// 필터
    func filter() -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("diaryTitle CONTAINS[c] '날'")
    }
    
    /// 작성
    func write(
        photoURLString: String,
        diaryTitle: String,
        diaryContent: String,
        diaryDate: Date = Date(),
        createdAt: Date = Date(),
        completion: ((Diary) -> ())?
    ) {
        let diary = Diary(
            photoURLString: photoURLString,
            diaryTitle: diaryTitle,
            diaryContent: diaryContent,
            diaryDate: diaryDate,
            createdAt: createdAt
        )
            
        do {
            try localRealm.write {
                localRealm.add(diary)
                completion?(diary)
            }
            
        } catch let error {
            Logger.log(error, .error, "error occured")
        }
    }
    
    /// 업데이트
    func update(item: Diary, completion: @escaping ((Diary) -> ())) {
        do {
            try localRealm.write {
                completion(item)
            }
            
        } catch let error {
            Logger.log(error, .error, "error occured")
        }
    }
    
    /// 삭제
    func delete(item: Diary) {
        do {
            removeImageFromDocument(fileName: "\(item.objectId).jpg")
            try localRealm.write {
                localRealm.delete(item)
            }
            
        } catch let error {
            Logger.log(error, .error, "error occured")
        }
    }
    
    /// 이미지 제거
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            
        } catch let error {
            Logger.log(error, .error, "error occured")
        }
    }
    
    /// 이미지 저장
    public func saveImageToDocument(fileName: String, image: UIImage) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
        let fileURL = documentDirectory.appendingPathComponent(fileName)
        guard let data = image.jpegData(compressionQuality: 0.5) else { return }
        
        do {
            try data.write(to: fileURL)
        } catch let error {
            print("file save err", error)
        }
    }
}
