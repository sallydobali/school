package com.example.school.storage

import androidx.room.Database
import androidx.room.RoomDatabase
import com.example.school.storage.entity.StudentEntity

@Database(
    entities = [StudentEntity::class],
    version = 1,
    exportSchema = false
)
abstract class AppDatabase : RoomDatabase()


