import sys
import json
import shlex
import shutil
import subprocess

from pathlib import Path
from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl, QObject, Slot, Signal, QSettings
from application_manager import ApplicationManager
from progress_manager import ProgressManager

# PENGELOLA PENGATURAN
class SettingsManager(QObject):

    def __init__(self, settings):
        super().__init__()
        self.settings = settings

    @Slot(str)
    def saveLanguage(self, language):
        self.settings.setValue("language", language)
        self.settings.sync()






app = QGuiApplication(sys.argv)

# IDENTITAS APLIKASI UNTUK QSETTINGS
app.setOrganizationName("KiddoLinux")
app.setApplicationName("KiddoHome")

# PENYIMPANAN PENGATURAN
settings = QSettings()

# BAHASA TERAKHIR
saved_language = settings.value("language", "id")

settings_manager = SettingsManager(settings)

launcher = ApplicationManager()
progress_manager = ProgressManager()
view = QQuickView()
view.setResizeMode(QQuickView.ResizeMode.SizeRootObjectToView)

view.rootContext().setContextProperty("appLauncher", launcher)
view.rootContext().setContextProperty("progressManager", progress_manager)
view.rootContext().setContextProperty("savedLanguage", saved_language)
view.rootContext().setContextProperty("settingsManager", settings_manager)

qml_file = (
    Path(__file__).resolve().parent.parent
    / "qml"
    / "Main.qml"
)

view.setSource(QUrl.fromLocalFile(str(qml_file)))

if view.status() == QQuickView.Status.Error:
    for error in view.errors():
        print(error.toString())
    sys.exit(1)

view.setTitle("Kiddo Home")
view.resize(1366, 850)
view.show()

sys.exit(app.exec())
