import sys
from pathlib import Path

from PySide6.QtGui import QGuiApplication
from PySide6.QtQuick import QQuickView
from PySide6.QtCore import QUrl

app = QGuiApplication(sys.argv)

view = QQuickView()
view.setResizeMode(QQuickView.ResizeMode.SizeRootObjectToView)

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
