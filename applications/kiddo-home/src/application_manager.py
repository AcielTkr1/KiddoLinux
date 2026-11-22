import json
import shlex
import shutil
import subprocess

from pathlib import Path
from PySide6.QtCore import QObject, Signal, Slot


class ApplicationManager(QObject):

    messageChanged = Signal(str, str)

    def __init__(self):
        super().__init__()

        self.applications = {}
        self.application_data = []

        self.loadApplications()

    def loadApplications(self):

        data_file = (
            Path(__file__).resolve().parent.parent
            / "data"
            / "applications.json"
        )

        try:
            with open(data_file, "r", encoding="utf-8") as file:
                data = json.load(file)

            self.application_data = data["applications"]

            for application in self.application_data:
                self.applications[application["name"]] = (
                    application["command"]
                )

            print(
                f"{len(self.applications)} aplikasi berhasil dimuat."
            )

        except (FileNotFoundError, json.JSONDecodeError, KeyError) as error:
            print(f"Gagal membaca daftar aplikasi: {error}")

    @Slot(str, result="QVariantList")
    def applicationsForCategory(self, category):

        icons = {
            "GCompris": "🧩",
            "Tux Paint": "🎨",
            "Tux Math": "🔢",
            "Tux Typing": "⌨️",
            "Thonny": "🐍",
            "Python": "💻"
        }

        result = []

        for application in self.application_data:

            if application["category"] != category:
                continue

            command = shlex.split(application["command"])

            available = (
                bool(command)
                and shutil.which(command[0]) is not None
            )

            description_id = application["description_id"]
            description_en = application["description_en"]

            result.append({
                "name": application["name"],
                "icon": icons.get(application["name"], "📦"),
                "description": description_id,
                "description_id": description_id,
                "description_en": description_en,
                "available": available
            })

        return result

    @Slot(str)
    def launch(self, name):

        command = self.applications.get(name)

        if command is None:
            self.messageChanged.emit(
                f"{name} tidak ditemukan.",
                f"{name} was not found."
            )
            return

        try:
            command_parts = shlex.split(command)

            if not command_parts:
                self.messageChanged.emit(
                    f"Perintah {name} tidak valid.",
                    f"The command for {name} is invalid."
                )
                return

            if shutil.which(command_parts[0]) is None:
                self.messageChanged.emit(
                    f"{name} belum terpasang di sistem.",
                    f"{name} is not installed on this system."
                )
                return

            subprocess.Popen(
                command_parts,
                start_new_session=True
            )

            self.messageChanged.emit(
                f"{name} berhasil dijalankan!",
                f"{name} launched successfully!"
            )

        except Exception as error:
            self.messageChanged.emit(
                f"Gagal menjalankan {name}: {error}",
                f"Failed to launch {name}: {error}"
            )
