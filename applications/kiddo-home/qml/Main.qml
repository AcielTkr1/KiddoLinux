import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Rectangle {
    id: root

    width: 1366
    height: 850
    color: "#EAF4FF"

    property string currentPage: "Home"
    property string selectedMessage: "Pilih aktivitas untuk memulai!"
    property var profileData: ({})
    property var progressData: ({})

    function refreshProgress() {
        profileData = progressManager.getProfile()
        progressData = progressManager.getProgress()
    }
    property string searchText: ""
    property int appRefreshCounter: 0

    function itemsForPage() {
    var refreshVersion = root.appRefreshCounter

    if (currentPage === "Learn" ||
        currentPage === "Create" ||
        currentPage === "Coding") {

        var apps = appLauncher.applicationsForCategory(currentPage)

        return apps.filter(function(item) {
            var keyword = root.searchText.toLowerCase()

            return item.name.toLowerCase().includes(keyword)
                || item.description.toLowerCase().includes(keyword)
        })
    }

    switch (currentPage) {
    case "Games":
        return [
            { name: "Puzzle", icon: "🧩", description: "Asah kemampuan berpikir" },
            { name: "Memory Game", icon: "🧠", description: "Latih daya ingat" },
            { name: "Math Challenge", icon: "➗", description: "Tantangan matematika" }
        ]

    case "Library":
        return [
            { name: "Science", icon: "🔬", description: "Materi ilmu pengetahuan" },
            { name: "Mathematics", icon: "📐", description: "Materi matematika" },
            { name: "Languages", icon: "🌍", description: "Belajar bahasa" },
            { name: "Technology", icon: "🚀", description: "Mengenal teknologi" }
        ]

    case "Achievements":
        return [
            { name: "First Explorer", icon: "🌟", description: "Memulai petualangan" },
            { name: "Little Creator", icon: "🎨", description: "Membuat karya pertama" },
            { name: "Code Beginner", icon: "💻", description: "Mengenal pemrograman" }
        ]

    case "Settings":
        return [
            { name: "Language", icon: "🌐", description: "Bahasa Indonesia / English" },
            { name: "Sound", icon: "🔊", description: "Pengaturan suara" },
            { name: "Appearance", icon: "🎨", description: "Pengaturan tampilan" },
            { name: "About", icon: "ℹ️", description: "Tentang Kiddo Home" }
        ]
    }

    return []
}

	Connections {
    target: appLauncher

    function onMessageChanged(message) {
        root.selectedMessage = message
    }
}

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // SIDEBAR
        Rectangle {
            Layout.preferredWidth: 100
            Layout.fillHeight: true
            radius: 24
            color: "white"

            Component.onCompleted: {
              refreshProgress()
            }

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 8

                Text {
                    text: "🤖"
                    font.pixelSize: 40
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "KIDDO"
                    font.pixelSize: 16
                    font.bold: true
                    color: "#2454A6"
                    Layout.alignment: Qt.AlignHCenter
                }

                Rectangle {
                    Layout.fillWidth: true
                    height: 2
                    color: "#EAF0FA"
                }

                Repeater {
                    model: [
                        { name: "Home", icon: "🏠" },
                        { name: "Learn", icon: "🎓" },
                        { name: "Games", icon: "🎮" },
                        { name: "Create", icon: "🎨" },
                        { name: "Coding", icon: "💻" },
                        { name: "Library", icon: "📚" },
                        { name: "Achievements", icon: "🏆" }
                    ]

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 65
                        radius: 15

                        color: root.currentPage === modelData.name
                               ? "#DCEBFF" : "white"

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Text {
                                text: modelData.icon
                                font.pixelSize: 24
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.name
                                font.pixelSize: 10
                                font.bold: true
                                color: "#24477E"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.currentPage = modelData.name
                                root.searchText = ""
                                root.selectedMessage = "Pilih aktivitas untuk memulai!"
                            }
                        }
                    }
                }

                Item {
                    Layout.fillHeight: true
                }

                Rectangle {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 62
                    radius: 15
                    color: root.currentPage === "Settings"
                           ? "#DCEBFF" : "white"

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            text: "⚙️"
                            font.pixelSize: 24
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: "Settings"
                            font.pixelSize: 10
                            font.bold: true
                            color: "#24477E"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            root.currentPage = "Settings"
                            root.selectedMessage = "Pengaturan Kiddo Home"
                            root.searchText = ""
                        }
                    }
                }
            }
        }

        // MAIN CONTENT
        ColumnLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 14

            // HEADER
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 64
                radius: 20
                color: "white"

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: 22
                    anchors.rightMargin: 22

                    Text {
                        text: root.currentPage
                        font.pixelSize: 23
                        font.bold: true
                        color: "#24477E"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    Text {
                        text: "🌟 Selamat datang, "
                         + (root.profileData.name || "Teman Hebat") + "!"
                        font.pixelSize: 15
                        color: "#536987"
                    }

                    Text {
                        text: "🤖"
                        font.pixelSize: 30
                    }
                }
            }

            // WELCOME BANNER
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 170
                radius: 26
                color: "#3987F6"
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: currentPage === "Home"
                                  ? "Halo, Teman Hebat! 👋"
                                  : "Ayo, Jelajahi " + currentPage + "!"

                            font.pixelSize: 29
                            font.bold: true
                            color: "white"
                        }

                        Text {
                            text: "KiddoBot siap menemanimu!"
                            font.pixelSize: 19
                            font.bold: true
                            color: "white"
                        }

                        Text {
                            text: root.pageDescription()
                            font.pixelSize: 14
                            color: "#EAF4FF"
                        }
                    }

                    Text {
                        text: "🤖"
                        font.pixelSize: 100
                    }
                }
            }

            // APPLICATION SEARCH AND REFRESH
            RowLayout {
                visible: root.currentPage === "Learn"
                        || root.currentPage === "Create"
                        || root.currentPage === "Coding"

                Layout.fillWidth: true
                Layout.preferredHeight: 48
                spacing: 12

                TextField {
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    placeholderText: "🔍 Cari aplikasi..."
                    text: root.searchText

                    onTextChanged: root.searchText = text

                    background: Rectangle {
                        radius: 14
                        color: "white"
                        border.color: "#DCEBFF"
                    }
                }

                Button {
                    text: "⟳ Refresh"

                    Layout.preferredWidth: 120
                    Layout.fillHeight: true

                    onClicked: {
                        root.appRefreshCounter++
                        root.selectedMessage = "Status aplikasi berhasil diperbarui!"
                    }
                }
            }

            // HOME CATEGORY GRID
            Text {
                visible: root.currentPage === "Home"
                text: "⭐ Ayo Mulai Petualanganmu!"
                font.pixelSize: 22
                font.bold: true
                color: "#24477E"
            }

            GridLayout {
                visible: root.currentPage === "Home"
                Layout.fillWidth: true
                Layout.fillHeight: false
                Layout.preferredHeight: 260
                columns: 3
                rowSpacing: 14
                columnSpacing: 14

                Repeater {
                    model: [
                        { name: "Learn", icon: "📚", color: "#3987F6" },
                        { name: "Games", icon: "🎮", color: "#56C98D" },
                        { name: "Create", icon: "🎨", color: "#FF896B" },
                        { name: "Coding", icon: "💻", color: "#A995F5" },
                        { name: "Library", icon: "📖", color: "#42C7C5" },
                        { name: "Achievements", icon: "🏆", color: "#F5BE43" }
                    ]

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 110
                        radius: 22
                        color: modelData.color

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                text: modelData.icon
                                font.pixelSize: 40
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.name
                                font.pixelSize: 19
                                font.bold: true
                                color: "white"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.currentPage = modelData.name
                                root.selectedMessage = "Pilih aktivitas untuk memulai!"
                            }
                        }
                    }
                }
            }

            // CATEGORY CONTENT
            GridLayout {
                visible: root.currentPage !== "Home"
                Layout.fillWidth: true
                Layout.fillHeight: true
                columns: 3
                rowSpacing: 14
                columnSpacing: 14

                Repeater {
                    model: root.itemsForPage()

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 205
                        radius: 22
                        color: "white"
                        border.color: "#DCEBFF"
                        border.width: 2

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                           onClicked: {
                         appLauncher.launch(modelData.name)
                            }
                    }

                        Column {
                            anchors.centerIn: parent
                            spacing: 9

                            Text {
                                text: modelData.icon
                                font.pixelSize: 43
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.name
                                font.pixelSize: 19
                                font.bold: true
                                color: "#24477E"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: modelData.description
                                font.pixelSize: 12
                                color: "#71839B"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                  text: modelData.available
                                    ? "● Terpasang"
                                    : "● Belum terpasang"

                                    color: modelData.available
                                    ? "#35A879"
                                    : "#E58A45"

                                    font.pixelSize: 11
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                            Button {
                                        text: "✓ Tandai Selesai"

                                        visible: modelData.available

                                        anchors.horizontalCenter: parent.horizontalCenter

                                        onClicked: {
                                            progressManager.completeActivity(
                                                modelData.name,
                                                root.currentPage,
                                                20
                                            )

                                            root.refreshProgress()

                                            root.selectedMessage =
                                                modelData.name + " selesai! Kamu mendapatkan 20 XP!"
                                        }
                                    }
                        }

                        
                    }
                }
            }

            // LEVEL PROGRESS
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 95

                radius: 20
                color: "white"

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 16
                    spacing: 10

                    RowLayout {
                        Layout.fillWidth: true

                        Text {
                            text: "🚀 Perjalanan Level Berikutnya"
                            font.pixelSize: 15
                            font.bold: true
                            color: "#24477E"
                        }

                        Item {
                            Layout.fillWidth: true
                        }

                        Text {
                            text: (root.progressData.currentLevelXP || 0)
                                + " / 100 XP"

                            font.pixelSize: 13
                            font.bold: true
                            color: "#3987F6"
                        }
                    }

                    Rectangle {
                        Layout.fillWidth: true
                        Layout.preferredHeight: 15

                        radius: 8
                        color: "#EAF0FA"

                        Rectangle {
                            width: parent.width *
                                ((root.progressData.progressPercent || 0) / 100)

                            height: parent.height
                            radius: 8
                            color: "#3987F6"

                            Behavior on width {
                                NumberAnimation {
                                    duration: 500
                                }
                            }
                        }
                    }
                }
            }

            // STATUS PANEL
            Rectangle {
                Layout.fillWidth: true
                Layout.preferredHeight: 75
                radius: 20
                color: "white"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 18

                    Text {
                        text: "🤖"
                        font.pixelSize: 30
                    }

                    Text {
                        text: root.selectedMessage
                        font.pixelSize: 14
                        color: "#536987"
                        Layout.fillWidth: true
                        wrapMode: Text.WordWrap
                    }

                     Text {
                        text: "🌟 Level "
                            + (root.progressData.level || 1)
                            + " | "
                            + (root.progressData.experience || 0)
                            + " XP"

                        font.pixelSize: 17
                        font.bold: true
                        color: "#3987F6"
                    }
                }
            }
        }
    }
}
