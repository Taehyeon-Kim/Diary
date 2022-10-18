//
//  Diary.swift
//  DDAK
//
//  Created by taekki on 2022/08/23.
//

import Foundation

import RealmSwift

protocol DiaryInterface: AnyObject {
    var photoURLString: String? { get set }
    var diaryTitle: String { get set }
    var diaryContent: String? { get set }
    var diaryDate: Date { get set }
    var createdAt: Date { get set }
    var favorite: Bool { get set }
}

class Diary: Object, DiaryInterface {
    
    var interface: DiaryInterface?
    
    // PK(필수): Int, UUID, ObjectID
    @Persisted(primaryKey: true) var objectId: ObjectId
    @Persisted var photoURLString: String?
    @Persisted var diaryTitle: String
    @Persisted var diaryContent: String?
    @Persisted var diaryDate = Date()
    @Persisted var createdAt = Date()
    @Persisted var favorite: Bool
    
    convenience init(interface: DiaryInterface) {
        self.init(
            photoURLString: interface.photoURLString,
            diaryTitle: interface.diaryTitle,
            diaryContent: interface.diaryContent,
            diaryDate: interface.diaryDate,
            createdAt: interface.createdAt
        )
        self.interface = interface
    }
    
    convenience init(
        photoURLString: String?,
        diaryTitle: String,
        diaryContent: String?,
        diaryDate: Date,
        createdAt: Date
    ) {
        self.init()
        self.photoURLString = photoURLString
        self.diaryTitle = diaryTitle
        self.diaryContent = diaryContent
        self.diaryDate = diaryDate
        self.createdAt = createdAt
        self.favorite = false
    }
}
