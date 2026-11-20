import sqlite3

from pathlib import Path
from PySide6.QtCore import QObject, Slot


class ProgressManager(QObject):

    def __init__(self):
        super().__init__()

        self.database_path = (
            Path(__file__).resolve().parent.parent
            / "data"
            / "kiddo.db"
        )

        self.database_path.parent.mkdir(
            parents=True,
            exist_ok=True
        )

        self.initializeDatabase()

    def connectDatabase(self):
        return sqlite3.connect(self.database_path)

    def initializeDatabase(self):

        with self.connectDatabase() as connection:

            cursor = connection.cursor()

            cursor.execute("""
                CREATE TABLE IF NOT EXISTS profiles (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    name TEXT NOT NULL,
                    level INTEGER DEFAULT 1,
                    experience INTEGER DEFAULT 0,
                    completed_activities INTEGER DEFAULT 0
                )
            """)

            cursor.execute("""
                CREATE TABLE IF NOT EXISTS activities (
                    id INTEGER PRIMARY KEY AUTOINCREMENT,
                    profile_id INTEGER NOT NULL,
                    activity_name TEXT NOT NULL,
                    category TEXT NOT NULL,
                    experience_earned INTEGER DEFAULT 0,
                    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                    FOREIGN KEY (profile_id) REFERENCES profiles(id)
                )
            """)

            cursor.execute("""
                SELECT COUNT(*) FROM profiles
            """)

            profile_count = cursor.fetchone()[0]

            if profile_count == 0:
                cursor.execute("""
                    INSERT INTO profiles (name)
                    VALUES (?)
                """, ("Teman Hebat",))

            connection.commit()

        print("Database Kiddo Home berhasil disiapkan.")

    @Slot(result="QVariantMap")
    def getProfile(self):

        with self.connectDatabase() as connection:

            connection.row_factory = sqlite3.Row

            profile = connection.execute("""
                SELECT * FROM profiles LIMIT 1
            """).fetchone()

            return dict(profile) if profile else {}

    @Slot(result="QVariantMap")
    def getProgress(self):

            profile = self.getProfile()

            experience = profile.get("experience", 0)

            return {
            "level": profile.get("level", 1),
            "experience": experience,
            "completedActivities": profile.get(
                "completed_activities", 0
            ),
            "currentLevelXP": experience % 100,
            "nextLevelXP": 100,
            "progressPercent": experience % 100
        }
    @Slot(str, str, int)
    def completeActivity(self, name, category, experience):

        with self.connectDatabase() as connection:

            profile = connection.execute("""
                SELECT id, experience
                FROM profiles
                LIMIT 1
            """).fetchone()

            if profile is None:
                return

            profile_id, current_experience = profile

            new_experience = current_experience + experience
            new_level = (new_experience // 100) + 1

            connection.execute("""
                INSERT INTO activities (
                    profile_id,
                    activity_name,
                    category,
                    experience_earned
                )
                VALUES (?, ?, ?, ?)
            """, (
                profile_id,
                name,
                category,
                experience
            ))

            connection.execute("""
                UPDATE profiles
                SET experience = ?,
                    level = ?,
                    completed_activities = completed_activities + 1
                WHERE id = ?
            """, (
                new_experience,
                new_level,
                profile_id
            ))

            connection.commit()