//
//  DiaryRepository.swift
//  DDAK
//
//  Created by taekki on 2022/08/26.
//

import Foundation

import DDAK_Core
import RealmSwift

protocol DiaryRepositoryType {
    var count: Int { get }
    func fetch() -> Results<Diary>
    func sort(by byKeyPath: String) -> Results<Diary>
    func filter() -> Results<Diary>
    func update(item: Diary)
    func delete(item: Diary)
}

struct DiaryRepository: DiaryRepositoryType {
    
    // Realm 객체는 구조체이다.
    // 구조체이기 때문에 싱글톤 패턴이 의미가 없다. (클래스안에 구조체가 있을 때)
    
    private let localRealm = try! Realm()
    
    var count: Int {
        return localRealm.objects(Diary.self).count
    }
    
    func fetch() -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: "diaryDate", ascending: true)
    }
    
    func sort(by byKeyPath: String) -> Results<Diary> {
        return localRealm.objects(Diary.self).sorted(byKeyPath: byKeyPath, ascending: false)
    }
    
    func filter() -> Results<Diary> {
        return localRealm.objects(Diary.self).filter("diaryTitle CONTAINS[c] '날'")
    }
    
    func update(item: Diary) {
        try! localRealm.write {
            item.favorite.toggle()
        }
    }
    
    func delete(item: Diary) {
        try! localRealm.write {
            localRealm.delete(item)
        }
        
        removeImageFromDocument(fileName: "\(item.objectId).jpg")
    }
    
    func removeImageFromDocument(fileName: String) {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return } // Document 경로
        let fileURL = documentDirectory.appendingPathComponent(fileName) // 세부 경로. 이미지를 저장할 위치
        
        do {
            try FileManager.default.removeItem(at: fileURL)
            
        } catch let error {
            Logger.log(error)
        }
    }
}
