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
                    completed_activities INTEGER DEFAULT 0,
                    avatar TEXT DEFAULT 'robot_blue'
                )
            """)

            columns = [
                row[1]
                for row in connection.execute(
                    "PRAGMA table_info(profiles)"
                ).fetchall()
            ]

            if "avatar" not in columns:
                connection.execute("""
                    ALTER TABLE profiles
                    ADD COLUMN avatar TEXT DEFAULT 'robot_blue'
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
                """, ("Super Friend",))

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

    @Slot(str, result=bool)
    def updateProfileName(self, new_name):

        new_name = new_name.strip()

        if not new_name:
            return False

        with self.connectDatabase() as connection:

            connection.execute("""
                UPDATE profiles
                SET name = ?
                WHERE id = (
                    SELECT id FROM profiles LIMIT 1
                )
            """, (new_name,))

            connection.commit()

        return True

    @Slot(str, result=bool)
    def updateProfileAvatar(self, avatar):

        allowed_avatars = [
            "robot_blue",
            "robot_pink",
            "robot_green",
            "robot_yellow"
        ]

        if avatar not in allowed_avatars:
            return False

        with self.connectDatabase() as connection:

            connection.execute("""
                UPDATE profiles
                SET avatar = ?
                WHERE id = (
                    SELECT id FROM profiles LIMIT 1
                )
            """, (avatar,))

            connection.commit()

        return True

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
    @Slot(str, str, int, result=bool)
    def completeActivity(self, name, category, experience):

        if not name.strip() or not category.strip():
            return False

        if experience <= 0:
            return False

        with self.connectDatabase() as connection:

            profile = connection.execute("""
                SELECT id, experience
                FROM profiles
                LIMIT 1
            """).fetchone()

            if profile is None:
                return False

            profile_id, current_experience = profile

            # Periksa apakah aktivitas sudah pernah diselesaikan
            existing_activity = connection.execute("""
                SELECT id
                FROM activities
                WHERE profile_id = ?
                AND activity_name = ?
                AND category = ?
                LIMIT 1
            """, (
                profile_id,
                name,
                category
            )).fetchone()

            if existing_activity is not None:
                return False

            # Hitung XP dan level baru
            new_experience = current_experience + experience
            new_level = (new_experience // 100) + 1

            # Simpan riwayat aktivitas
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

            # Perbarui progres profil
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

        return True

    @Slot(str, str, result=bool)
    def isActivityCompleted(self, name, category):

        with self.connectDatabase() as connection:

            profile = connection.execute("""
                SELECT id
                FROM profiles
                LIMIT 1
            """).fetchone()

            if profile is None:
                return False

            profile_id = profile[0]

            activity = connection.execute("""
                SELECT id
                FROM activities
                WHERE profile_id = ?
                AND activity_name = ?
                AND category = ?
                LIMIT 1
            """, (
                profile_id,
                name,
                category
            )).fetchone()

            return activity is not None

    @Slot(result="QVariantList")
    def getActivityHistory(self):

        with self.connectDatabase() as connection:

            profile = connection.execute("""
                SELECT id
                FROM profiles
                LIMIT 1
            """).fetchone()

            if profile is None:
                return []

            profile_id = profile[0]

            activities = connection.execute("""
                SELECT
                    activity_name,
                    category,
                    experience_earned,
                    completed_at
                FROM activities
                WHERE profile_id = ?
                ORDER BY completed_at DESC
            """, (profile_id,)).fetchall()

            return [
                {
                    "name": activity[0],
                    "category": activity[1],
                    "xp": activity[2],
                    "date": activity[3]
                }
                for activity in activities
            ]