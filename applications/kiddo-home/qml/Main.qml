import QtQuick
import QtQuick.Layouts

Rectangle {
    id: root

    width: 1366
    height: 850
    color: "#EAF4FF"

    property string currentPage: "Home"

    readonly property var categories: [
        { name: "Learn", subtitle: "Belajar sesuatu yang baru", icon: "📚", color: "#3987F6" },
        { name: "Games", subtitle: "Bermain sambil belajar", icon: "🎮", color: "#56C98D" },
        { name: "Create", subtitle: "Bebaskan kreativitasmu", icon: "🎨", color: "#FF896B" },
        { name: "Coding", subtitle: "Jadilah programmer muda", icon: "💻", color: "#A995F5" },
        { name: "Library", subtitle: "Kumpulan materi belajar", icon: "📖", color: "#42C7C5" },
        { name: "Achievements", subtitle: "Lihat pencapaianmu", icon: "🏆", color: "#F5BE43" }
    ]

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16

        // SIDEBAR
        Rectangle {
            Layout.preferredWidth: 100
            Layout.fillHeight: true
            radius: 24
            color: "#FFFFFF"

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 14

                Text {
                    text: "🤖"
                    font.pixelSize: 42
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
                        { name: "Coding", icon: "💻" }
                    ]

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 76
                        radius: 16

                        color: root.currentPage === modelData.name
                               ? "#DCEBFF" : "#FFFFFF"

                        Column {
                            anchors.centerIn: parent
                            spacing: 3

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.icon
                                font.pixelSize: 27
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                color: "#24477E"
                                font.pixelSize: 12
                                font.bold: true
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: root.currentPage = modelData.name
                            cursorShape: Qt.PointingHandCursor
                        }
                    }
                }

                Item { Layout.fillHeight: true }

                Text {
                    text: "⚙️"
                    font.pixelSize: 27
                    Layout.alignment: Qt.AlignHCenter
                }

                Text {
                    text: "Settings"
                    font.pixelSize: 12
                    color: "#536987"
                    Layout.alignment: Qt.AlignHCenter
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
                color: "#FFFFFF"

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

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "🌟  Selamat datang, Teman Hebat!"
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
                Layout.preferredHeight: 190
                radius: 26
                color: "#3987F6"
                clip: true

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24
                    spacing: 20

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 12

                        Text {
                            text: "Halo, Teman Hebat! 👋"
                            font.pixelSize: 30
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Text {
                            text: "Selamat datang di KiddoLinux!"
                            font.pixelSize: 19
                            font.bold: true
                            color: "#FFFFFF"
                        }

                        Text {
                            text: "Mari belajar, bermain, dan berkreasi bersama KiddoBot."
                            font.pixelSize: 14
                            color: "#EAF4FF"
                            wrapMode: Text.WordWrap
                        }
                    }

                    Text {
                        text: "🤖"
                        font.pixelSize: 112
                    }
                }
            }

            // SECTION TITLE
            Text {
                text: root.currentPage === "Home"
                      ? "⭐ Ayo Mulai Petualanganmu!"
                      : "✨ Jelajahi " + root.currentPage

                font.pixelSize: 22
                font.bold: true
                color: "#24477E"
            }

            // CATEGORY CARDS
            GridLayout {
                Layout.fillWidth: true
                columns: 3
                rowSpacing: 14
                columnSpacing: 14

                Repeater {
                    model: root.categories

                    delegate: Rectangle {
                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 145
                        radius: 22
                        color: modelData.color

                        Column {
                            anchors.centerIn: parent
                            spacing: 8

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.icon
                                font.pixelSize: 42
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.name
                                font.pixelSize: 19
                                font.bold: true
                                color: "#FFFFFF"
                            }

                            Text {
                                anchors.horizontalCenter: parent.horizontalCenter
                                text: modelData.subtitle
                                font.pixelSize: 11
                                color: "#FFFFFF"
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.currentPage = modelData.name
                            }
                        }
                    }
                }
            }

            // PROGRESS
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 95
                radius: 22
                color: "#FFFFFF"

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 20

                    Text {
                        text: "🏆"
                        font.pixelSize: 42
                    }

                    ColumnLayout {
                        spacing: 5

                        Text {
                            text: "Perjalanan Belajarmu"
                            font.pixelSize: 17
                            font.bold: true
                            color: "#24477E"
                        }

                        Text {
                            text: "Terus belajar dan kumpulkan pencapaian!"
                            font.pixelSize: 13
                            color: "#71839B"
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "🌟 Level 1"
                        font.pixelSize: 18
                        font.bold: true
                        color: "#3987F6"
                    }
                }
            }
        }
    }
}
