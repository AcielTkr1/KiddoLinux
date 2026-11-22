import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root

    width: 1366
    height: 850
    color: "#EAF4FF"

    property string currentPage: "Home"
    property string pendingPage: ""
    property string selectedSetting: ""

    // LANGUAGE SETTINGS
    property string language: "id"

    // TRANSLATION FUNCTION
    function tx(indonesian, english) {
        return root.language === "en"
                ? english
                : indonesian
    }

    // PAGE NAME TRANSLATION
    function pageLabel(page) {
        switch (page) {
        case "Home":
            return tx("Beranda", "Home")
        case "Learn":
            return tx("Belajar", "Learn")
        case "Games":
            return tx("Permainan", "Games")
        case "Create":
            return tx("Kreasi", "Create")
        case "Coding":
            return tx("Pemrograman", "Coding")
        case "Library":
            return tx("Perpustakaan", "Library")
        case "Achievements":
            return tx("Pencapaian", "Achievements")
        case "Settings":
            return tx("Pengaturan", "Settings")
        default:
            return page
        }
    }

    property string selectedMessage: "Pilih aktivitas untuk memulai!"
    property var profileData: ({})
    property var progressData: ({})

    function refreshProgress() {
        profileData = progressManager.getProfile()
        progressData = progressManager.getProgress()
    }
    property string searchText: ""
    property var displayedItems: []
    property int appRefreshCounter: 0
    property real pageOpacity: 1.0

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
        var games = [
            { name: "Puzzle", icon: "🧩", description: "Asah kemampuan berpikir" },
            { name: "Memory Game", icon: "🧠", description: "Latih daya ingat" },
            { name: "Math Challenge", icon: "➗", description: "Tantangan matematika" }
        ]

        var gameKeyword = root.searchText.toLowerCase()

        return games.filter(function(item) {
            return item.name.toLowerCase().includes(gameKeyword)
                || item.description.toLowerCase().includes(gameKeyword)
        })


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
            {
                name: "Language",
                icon: "🌐",
                description: root.tx("Bahasa Indonesia / English", "Indonesian / English")
            },
            {
                name: "Sound",
                icon: "🔊",
                description: root.tx("Pengaturan suara", "Sound settings")
            },
            {
                name: "Appearance",
                icon: "🎨",
                description: root.tx("Pengaturan tampilan", "Appearance settings")
            },
            {
                name: "About",
                icon: "ℹ️",
                description: root.tx("Tentang Kiddo Home", "About Kiddo Home")
            }
        ]
        default:
            return []
    }
    }

    function refreshCategoryItems() {
        root.displayedItems = root.itemsForPage()
    }
    
    function pageDescription() {
        switch (root.currentPage) {
        case "Home":
            return tx("Pilih petualangan belajar yang kamu sukai!",
                    "Choose a learning adventure you love!")

        case "Learn":
            return tx("Ayo belajar hal-hal baru!",
                    "Let's learn new things!")

        case "Games":
            return tx("Belajar sambil bermain!",
                    "Learn while playing!")

        case "Create":
            return tx("Saatnya membuat karya kreatif!",
                    "Time to create something amazing!")

        case "Coding":
            return tx("Mulai petualangan dunia pemrograman!",
                    "Start your coding adventure!")

        case "Library":
            return tx("Temukan berbagai pengetahuan baru!",
                    "Discover new knowledge!")

        case "Achievements":
            return tx("Lihat pencapaian hebatmu!",
                    "Look at your amazing achievements!")

        case "Settings":
            return tx("Atur pengalaman Kiddo Home-mu!",
                    "Customize your Kiddo Home experience!")

        default:
            return tx("KiddoBot siap menemanimu!",
                    "KiddoBot is ready to help you!")
        }
    }

    function changePage(newPage) {
    if (root.currentPage === newPage || pageFadeOut.running)
        return

    root.pendingPage = newPage
    pageFadeOut.start()
}

SequentialAnimation {
    id: pageFadeOut

    // ANIMASI KELUAR
    ParallelAnimation {
        NumberAnimation {
            target: mainContent
            property: "opacity"
            to: 0
            duration: 140
            easing.type: Easing.InOutCubic
        }

        NumberAnimation {
            target: mainContentSlide
            property: "x"
            to: -12
            duration: 140
            easing.type: Easing.InOutCubic
        }
    }

    // GANTI HALAMAN SAAT KONTEN TIDAK TERLIHAT
    ScriptAction {
        script: {
            root.currentPage = root.pendingPage
            root.searchText = ""
            root.refreshCategoryItems()
            root.selectedMessage = "Pilih aktivitas untuk memulai!"
        }
    }

    // ANIMASI MASUK
    ParallelAnimation {
        NumberAnimation {
            target: mainContent
            property: "opacity"
            to: 1
            duration: 240
            easing.type: Easing.OutCubic
        }

        NumberAnimation {
            target: mainContentSlide
            property: "x"
            to: 0
            duration: 240
            easing.type: Easing.OutCubic
        }
    }
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
                        id: sidebarItem

                        required property var modelData

                        Layout.fillWidth: true
                        Layout.preferredHeight: 65
                        radius: 15

                        color: root.currentPage === modelData.name
                                ? "#DCEBFF"
                                : sidebarMouseArea.containsMouse
                                    ? "#EEF5FF"
                                    : "white"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 180
                                }
                            }

                        Column {
                            anchors.centerIn: parent
                            spacing: 2

                            Text {
                                text: modelData.icon
                                font.pixelSize: 24
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Text {
                                text: root.pageLabel(modelData.name)
                                font.pixelSize: 10
                                font.bold: true
                                color: "#24477E"
                                anchors.horizontalCenter: parent.horizontalCenter
                            }
                        }

                        MouseArea {
                            id: sidebarMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.changePage(modelData.name)
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
                            ? "#DCEBFF"
                            : settingsMouseArea.containsMouse
                                ? "#EEF5FF"
                                : "white"

                        Behavior on color {
                            ColorAnimation {
                                duration: 180
                            }
                        }

                    Column {
                        anchors.centerIn: parent
                        spacing: 2

                        Text {
                            text: "⚙️"
                            font.pixelSize: 24
                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        Text {
                            text: root.tx("Pengaturan", "Settings")
                            font.pixelSize: 10
                            font.bold: true
                            color: "#24477E"
                            anchors.horizontalCenter: parent.horizontalCenter
                        }
                    }

                    MouseArea {
                        id: settingsMouseArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor

                        onClicked: {
                            root.changePage("Settings")
                            root.selectedMessage = "Pengaturan Kiddo Home"
                        }
                    }
                }
            }
        }

        // MAIN CONTENT
        Item {
            id: mainContent

            Layout.fillWidth: true
            Layout.fillHeight: true

            opacity: 1.0

            transform: Translate {
                id: mainContentSlide
                x: 0
            }
            ColumnLayout {
                anchors.fill: parent
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
                        text: root.pageLabel(root.currentPage)
                        font.pixelSize: 23
                        font.bold: true
                        color: "#24477E"
                    }

                    Item {
                        Layout.fillWidth: true
                    }

                    RowLayout {
                        spacing: 10

                        Rectangle {
                            width: 42
                            height: 42
                            radius: 21
                            color: "#D9EDFF"

                            Image {
                                anchors.centerIn: parent

                                width: 36
                                height: 36

                                source: "../assets/avatars/"
                                        + (root.profileData.avatar || "robot_blue")
                                        + ".png"

                                fillMode: Image.PreserveAspectFit
                                smooth: true
                                mipmap: true
                            }
                        }

                        Text {
                            text: root.tx("🌟 Selamat datang, ", "🌟 Welcome, ")
                                + (root.profileData.name || root.tx("Teman Hebat", "Super Friend"))
                                + "!"

                            font.pixelSize: 15
                            color: "#536987"
                        }

                        // TOMBOL EDIT PROFIL
                        Button {
                            id: profileButton

                            text: root.tx("✏️ Edit Profil", "✏️ Edit Profile")
                            hoverEnabled: true

                            font.pixelSize: 13
                            font.bold: true

                            padding: 12

                            background: Rectangle {
                                radius: 12

                                color: profileButton.down
                                    ? "#C7DFFF"
                                    : profileButton.hovered
                                        ? "#DCEBFF"
                                        : "#EEF5FF"

                                border.color: "#C5DCFF"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: profileButton.text

                                font: profileButton.font
                                color: "#24569B"

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                nameDialog.open()
                            }
                        }

                        // TOMBOL EDIT AVATAR
                        Button {
                            id: avatarButton

                            text: root.tx("🎨 Edit Avatar", "🎨 Edit Avatar")
                            hoverEnabled: true

                            font.pixelSize: 13
                            font.bold: true

                            padding: 12

                            background: Rectangle {
                                radius: 12

                                color: avatarButton.down
                                    ? "#C7DFFF"
                                    : avatarButton.hovered
                                        ? "#DCEBFF"
                                        : "#EEF5FF"

                                border.color: "#C5DCFF"
                                border.width: 1
                            }

                            contentItem: Text {
                                text: avatarButton.text

                                font: avatarButton.font
                                color: "#24569B"

                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
                            }

                            onClicked: {
                                avatarDialog.open()
                            }
                        }
                    }

                    Text {
                        text: "🤖"
                        font.pixelSize: 30
                    }
                }
            }

            // WELCOME BANNER
            Rectangle {
                id: pageContent
                Layout.fillWidth: true
                Layout.preferredHeight: 170
                radius: 26
                color: "#3987F6"
                clip: true
                opacity: 1.0

                Behavior on opacity {
                    NumberAnimation {
                        duration: 250
                        easing.type: Easing.InOutCubic
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 24

                    ColumnLayout {
                        Layout.fillWidth: true
                        spacing: 10

                        Text {
                            text: currentPage === "Home"
                                ? root.tx("Halo, Teman Hebat! 👋", "Hello, Super Friend! 👋")
                                : root.tx("Ayo, Jelajahi ", "Let's Explore ")
                                    + root.pageLabel(currentPage) + "!"

                            font.pixelSize: 29
                            font.bold: true
                            color: "white"
                        }

                        Text {
                            text: root.tx(
                                "KiddoBot siap menemanimu!",
                                "KiddoBot is ready to help you!"
                            )
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
                        || root.currentPage === "Games"

                Layout.fillWidth: true
                Layout.preferredHeight: 48
                spacing: 12

                TextField {
                    id: appSearchField
                    hoverEnabled: true

                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    placeholderText: root.currentPage === "Games"
                        ? root.tx("🔍 Cari permainan...", "🔍 Search games...")
                        : root.tx("🔍 Cari aplikasi...", "🔍 Search apps...")

                    text: root.searchText

                    onTextChanged: {
                        root.searchText = text
                        root.refreshCategoryItems()
                        console.log("========== DEBUG EMPTY STATE ==========")
                        console.log("Halaman:", root.currentPage)
                        console.log("Jumlah item:", root.displayedItems.length)
                        console.log("Empty State visible:", emptySearchState.visible)
                        console.log("Container width:", categoryContent.width)
                        console.log("Container height:", categoryContent.height)
                        console.log("========================================")

                        console.log("Kata pencarian:", root.searchText)
                        console.log("Jumlah hasil:", root.displayedItems.length)
                        console.log("Halaman:", root.currentPage)
                    }

                    background: Rectangle {
                        radius: 14
                        color: "white"

                        border.color: appSearchField.activeFocus
                                    ? "#3987F6"
                                    : appSearchField.hovered
                                        ? "#A9CCFA"
                                        : "#DCEBFF"

                        border.width: appSearchField.activeFocus ? 2 : 1

                        Behavior on border.color {
                            ColorAnimation {
                                duration: 180
                            }
                        }
                    }
                }

                // TOMBOL REFRESH
                Button {
                    id: refreshButton

                    text: root.tx("⟳ Perbarui", "⟳ Refresh")
                    hoverEnabled: true

                    Layout.preferredWidth: 120
                    Layout.fillHeight: true

                    font.pixelSize: 13
                    font.bold: true

                    padding: 12

                    background: Rectangle {
                        radius: 12

                        color: refreshButton.down
                            ? "#C7DFFF"
                            : refreshButton.hovered
                                ? "#DCEBFF"
                                : "#EEF5FF"

                        border.color: "#C5DCFF"
                        border.width: 1
                    }

                    contentItem: Text {
                        text: refreshButton.text

                        font: refreshButton.font
                        color: "#24569B"

                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    onClicked: {
                        root.appRefreshCounter++
                        root.selectedMessage = root.tx(
                            "Status aplikasi berhasil diperbarui!",
                            "Application status successfully refreshed!"
                        )
                    }
                }
            }

            // HOME CATEGORY GRID
            Text {
                visible: root.currentPage === "Home"
                text: root.tx(
                    "⭐ Ayo Mulai Petualanganmu!",
                    "⭐ Start Your Adventure!"
                )
                font.pixelSize: 22
                font.bold: true
                color: "#24477E"
            }

            GridLayout {
                id: homeCategoryGrid

                visible: root.currentPage === "Home"

                onVisibleChanged: {
                    if (visible) {
                        opacity = 0
                        categoryFadeIn.start()

                    }
                }

                NumberAnimation {
                    id: categoryFadeIn
                    target: homeCategoryGrid
                    property: "opacity"
                    from: 0
                    to: 1
                    duration: 300
                    easing.type: Easing.InOutCubic
                }
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
                        id: categoryCard
                        required property var modelData

                        scale: categoryMouseArea.containsMouse ? 1.05 : 1.0

                        Behavior on scale {
                            NumberAnimation {
                                duration: 180
                                easing.type: Easing.OutCubic
                            }
                        }

                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.minimumHeight: 110
                        radius: 22
                        layer.enabled: true 
                        layer.effect: DropShadow {
                            horizontalOffset: 0
                            verticalOffset: categoryMouseArea.containsMouse ? 8 : 3
                            radius: categoryMouseArea.containsMouse ? 18 : 10
                            samples: 25
                            color: "#40000000"
                        }
                        color: categoryMouseArea.containsMouse
                            ? Qt.lighter(modelData.color, 1.15)
                            : modelData.color

                        Behavior on color {
                            ColorAnimation {
                                duration:  180
                                easing.type: Easing.OutCubic
                            }
                        }

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
                            id: categoryMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                root.changePage(modelData.name)
                            }
                        }
                    }
                }
            }

            // CATEGORY CONTENT CONTAINER
            Item {
                id: categoryContent

                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.minimumHeight: 180
                
                // CATEGORY GRID
                GridLayout {
                    id: appCategoryGrid
                    
                    anchors.fill : parent

                    visible:    root.currentPage !== "Home"
                                && root.displayedItems.length > 0
                                
                    onVisibleChanged: {
                        if (visible) {
                            opacity = 0
                            appFadeIn.start()
                        }
                    }

                    NumberAnimation {
                        id: appFadeIn
                        target: appCategoryGrid
                        property: "opacity"
                        from: 0
                        to : 1
                        duration: 300
                        easing.type: Easing.InOutCubic
                    }
                    
                    
                    columns: 3
                    rowSpacing: 14
                    columnSpacing: 14

                    Repeater {
                        model: root.displayedItems
                        
                        delegate: Rectangle {
                        id: appCard

                        required property var modelData
                        required property int index

                        opacity: 0

                        transform: Translate {
                            id: appCardSlide
                            y: 15
                        }

                        SequentialAnimation {
                            id: cardEntrance

                            running: true

                            PauseAnimation {
                                duration: appCard.index * 100
                            }

                            ParallelAnimation {
                                NumberAnimation {
                                    target: appCard
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: 300
                                    easing.type: Easing.OutCubic
                                }

                                NumberAnimation {
                                    target: appCardSlide
                                    property: "y"
                                    from: 15
                                    to: 0
                                    duration: 300
                                    easing.type: Easing.OutCubic
                                }
                            }
                        }

                        scale: appCardMouseArea.containsMouse ? 1.04 : 1.0

                        Behavior on scale {
                            NumberAnimation {
                                duration: 180
                                easing.type: Easing.OutCubic
                            }
                        }

                        Layout.fillWidth: true
                            Layout.preferredHeight: 205
                            radius: 22

                            color: appCardMouseArea.containsMouse
                                ? "#F0F7FF"
                                : "white"

                            border.color: appCardMouseArea.containsMouse
                                        ? "#8DBBFA"
                                        : "#DCEBFF"

                            border.width: appCardMouseArea.containsMouse ? 2 : 1

                            Behavior on color {
                                ColorAnimation {
                                    duration: 180
                                }
                            }

                            Behavior on border.color {
                                ColorAnimation {
                                    duration: 180
                                }
                            }

                        MouseArea {
                            id: appCardMouseArea

                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                if (root.currentPage === "Settings") {
                                    root.selectedSetting = modelData.name
                                    settingsDialog.open()
                                } else {
                                    appLauncher.launch(modelData.name)
                                }
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

                                     visible: modelData.available === true

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

                // EMPTY SEARCH STATE
                Rectangle {
                    id: emptySearchState

                    anchors.fill: parent

                    visible: root.currentPage !== "Home"
                            && root.displayedItems.length === 0

                    radius: 24
                    color: "#FFFFFF"
                    border.color: "#DCEBFF"
                    border.width: 1

                    opacity: visible ? 1 : 0

                    Behavior on opacity {
                        NumberAnimation {
                            duration: 250
                            easing.type: Easing.OutCubic
                        }
                    }

                    Column {
                        anchors.centerIn: parent
                        spacing: 14

                        // ILUSTRASI ROBOT
                        Rectangle {
                            width: 100
                            height: 100
                            radius: 32
                            color: "#EAF4FF"

                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                anchors.centerIn: parent
                                text: "🤖"
                                font.pixelSize: 58
                            }
                        }

                        // JUDUL
                        Text {
                            text: root.searchText.length > 0
                                ? root.tx("Yah, belum ketemu!", "Oops, nothing found!")
                                : root.tx("Belum ada aktivitas di sini", "No activities here yet")

                            font.pixelSize: 20
                            font.bold: true
                            color: "#24477E"

                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // DESKRIPSI
                        Text {
                            text: root.searchText.length > 0
                                ? root.tx("Coba kata kunci lainnya, yuk!", "Try another keyword!")
                                : root.tx(
                                    "Tenang! Aktivitas baru akan segera hadir.",
                                    "Don't worry! New activities are coming soon."
                                )

                            font.pixelSize: 13
                            color: "#71839B"

                            anchors.horizontalCenter: parent.horizontalCenter
                        }

                        // TOMBOL RESET PENCARIAN
                        Button {
                            text: root.tx("✕ Hapus Pencarian", "✕ Clear Search")

                            visible: root.searchText.length > 0

                            anchors.horizontalCenter: parent.horizontalCenter

                            onClicked: {
                                root.searchText = ""
                                root.refreshCategoryItems()
                            }

                            background: Rectangle {
                                radius: 12
                                color: parent.hovered ? "#286FD6" : "#3987F6"

                                Behavior on color {
                                    ColorAnimation {
                                        duration: 160
                                    }
                                }
                            }

                            contentItem: Text {
                                text: parent.text
                                color: "white"
                                font.pixelSize: 13
                                font.bold: true
                                horizontalAlignment: Text.AlignHCenter
                                verticalAlignment: Text.AlignVCenter
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
                            text: root.tx(
                                "🚀 Perjalanan Level Berikutnya",
                                "🚀 Next Level Journey"
                            )
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
                            text: root.selectedMessage === "Pilih aktivitas untuk memulai!"
                                ? root.tx(
                                    "Pilih aktivitas untuk memulai!",
                                    "Choose an activity to get started!"
                                )
                                : root.selectedMessage

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
     // EDIT PROFILE DIALOG
        Dialog {
            id: nameDialog

            title: root.tx("Edit Profil", "Edit Profile")
            modal: true
            anchors.centerIn: parent

            standardButtons: Dialog.Save | Dialog.Cancel

            onOpened: {
                nameInput.text = root.profileData.name || ""
            }

            onAccepted: {
                if (progressManager.updateProfileName(nameInput.text)) {
                    root.refreshProgress()
                    root.selectedMessage = root.tx(
                        "Nama profil berhasil diperbarui!",
                        "Profile name successfully updated!"
                    )
                } else {
                    root.selectedMessage = root.tx(
                        "Nama tidak boleh kosong!",
                        "Name cannot be empty!"
                    )
                }
            }

            contentItem: TextField {
                id: nameInput

                placeholderText: root.tx(
                    "Masukkan nama baru...",
                    "Enter a new name..."
                )
                selectByMouse: true
            }
        }
        // AVATAR SELECTION DIALOG
        Dialog {
            id: avatarDialog

            title: root.tx("Pilih Avatar Kamu", "Choose Your Avatar")
            modal: true
            anchors.centerIn: parent

            width: 320
            implicitWidth: 320
            
            standardButtons: Dialog.Cancel

            contentItem: ColumnLayout {
                spacing: 15
                implicitWidth: 280

                Text {
                    text: root.tx(
                        "Pilih karakter favoritmu!",
                        "Choose your favorite character!"
                    )
                    font.pixelSize: 16
                    color: "#536987"
                }

                GridLayout {
                    columns: 2
                    rowSpacing: 15
                    columnSpacing: 15

                    Repeater {
                        model: [
                            { name: root.tx("Robot Biru", "Blue Robot"), id: "robot_blue", emoji: "🤖" },
                            { name: root.tx("Robot Pink", "Pink Robot"), id: "robot_pink", emoji: "👩‍🚀" },
                            { name: root.tx("Alien Hijau", "Green Alien"), id: "robot_green", emoji: "👽" },
                            { name: root.tx("Robot Kuning", "Yellow Robot"), id: "robot_yellow", emoji: "🧑‍🚀" }
                        ]

                            delegate: Rectangle {
                                id: avatarCard

                                scale: avatarMouseArea.containsMouse ? 1.06 : 1.0

                                Behavior on scale {
                                    NumberAnimation {
                                        duration: 180
                                        easing.type: Easing.OutCubic
                                    }
                                }

                                width: 115
                                height: 110
                                radius: 18
                                property bool isSelected: root.profileData.avatar === modelData.id
                                color: isSelected ? "#D9EDFF" : "#F1F6FC"

                                border.width: isSelected ? 3 : 1

                                border.color: isSelected ? "#3987E8" : "#E1EAF5"

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 8

                                    Image {
                                        anchors.horizontalCenter: parent.horizontalCenter

                                        width: 75
                                        height: 75

                                        source: "../assets/avatars/"
                                                + modelData.id + ".png"

                                        fillMode: Image.PreserveAspectFit
                                        smooth: true
                                        mipmap: true
                                    }   

                                    Text {
                                        anchors.horizontalCenter: parent.horizontalCenter
                                        text: modelData.name
                                        font.pixelSize: 12
                                        color: "#536987"
                                    }
                                }

                                
                                Rectangle {
                                    visible: parent.isSelected

                                    width: 23
                                    height: 23
                                    radius: 12

                                    color: "#3987E8"

                                    anchors.top: parent.top
                                    anchors.right: parent.right
                                    anchors.topMargin: 6
                                    anchors.rightMargin: 6

                                    Text {
                                        anchors.centerIn: parent
                                        text: "✓"
                                        color: "white"
                                        font.pixelSize: 15
                                        font.bold: true
                                    }
                                }
                                

                                MouseArea {
                                    id: avatarMouseArea
                                    anchors.fill: parent
                                    hoverEnabled: true

                                    onClicked: {
                                        if (progressManager.updateProfileAvatar(modelData.id)) {
                                            root.refreshProgress()
                                            avatarDialog.close()
                                            root.selectedMessage = root.tx(
                                                "Avatar berhasil diganti!",
                                                "Avatar successfully changed!"
                                            )
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        }

            // SETTINGS DIALOG
            Dialog {
                id: settingsDialog

                modal: true
                anchors.centerIn: Overlay.overlay

                width: 520
                height: 420

                padding: 0

                closePolicy: Popup.CloseOnEscape
                            | Popup.CloseOnPressOutside

                background: Rectangle {
                    radius: 28
                    color: "#FFFFFF"
                    border.color: "#DCEBFF"
                    border.width: 1
                }

                contentItem: Column {
                    anchors.fill: parent
                    anchors.margins: 28
                    spacing: 18

                    // HEADER
                    Row {
                        width: parent.width
                        spacing: 12

                        Text {
                            text: "⚙️"
                            font.pixelSize: 30
                        }

                        Text {
                            text: root.tx("Pengaturan", "Settings")
                            font.pixelSize: 23
                            font.bold: true
                            color: "#24477E"
                            anchors.verticalCenter: parent.verticalCenter
                        }
                    }

                    Rectangle {
                        width: parent.width
                        height: 1
                        color: "#E5EEF9"
                    }

                    // JUDUL PENGATURAN
                    Text {
                    text: {
                        switch (root.selectedSetting) {
                        case "Language":
                            return root.tx("🌐 Bahasa", "🌐 Language")
                        case "Sound":
                            return root.tx("🔊 Suara", "🔊 Sound")
                        case "Appearance":
                            return root.tx("🎨 Tampilan", "🎨 Appearance")
                        case "About":
                            return root.tx("ℹ️ Tentang Kiddo Home", "ℹ️ About Kiddo Home")
                        default:
                            return root.tx("Pengaturan", "Settings")
                        }
                    }

                        font.pixelSize: 20
                        font.bold: true
                        color: "#24477E"
                    }

                    // DESKRIPSI
                    Text {
                        width: parent.width
                        wrapMode: Text.WordWrap

                        text: {
                            switch (root.selectedSetting) {
                            case "Language":
                                return root.tx(
                                    "Pilih bahasa yang ingin digunakan.",
                                    "Choose your preferred language."
                                )

                            case "Sound":
                                return root.tx(
                                    "Atur efek suara dalam aplikasi.",
                                    "Configure sound effects in the application."
                                )

                            case "Appearance":
                                return root.tx(
                                    "Pilih tampilan Kiddo Home.",
                                    "Customize the appearance of Kiddo Home."
                                )

                            case "About":
                                return root.tx(
                                    "Kiddo Home adalah pusat aktivitas belajar dalam KiddoLinux.",
                                    "Kiddo Home is the learning activity hub of KiddoLinux."
                                )

                            default:
                                return ""
                            }
                        }

                        font.pixelSize: 14
                        color: "#71839B"
                    }

                    // LANGUAGE SELECTION
                    Row {
                        visible: root.selectedSetting === "Language"
                        width: parent.width
                        spacing: 12

                        Button {
                            text: "🇮🇩 Bahasa Indonesia"
                            width: 200
                            height: 45

                            onClicked: {
                                root.language = "id"
                                root.selectedMessage = "Bahasa berhasil diubah ke Indonesia!"
                            }
                        }

                        Button {
                            text: "🇬🇧 English"
                            width: 200
                            height: 45

                            onClicked: {
                                root.language = "en"
                                root.selectedMessage = "Language changed to English!"
                            }
                        }
                    }

                    Item {
                        Layout.fillHeight: true
                        height: 35
                    }

                    // TOMBOL TUTUP
                    Button {
                        text: root.tx("Tutup", "Close")
                        width: parent.width
                        height: 45

                        onClicked: settingsDialog.close()

                        background: Rectangle {
                            radius: 14
                            color: parent.hovered ? "#286FD6" : "#3987F6"

                            Behavior on color {
                                ColorAnimation {
                                    duration: 160
                                }
                            }
                        }

                        contentItem: Text {
                            text: parent.text
                            color: "white"
                            font.pixelSize: 15
                            font.bold: true
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }
                    }
                }

                enter: Transition {
                    NumberAnimation {
                        property: "opacity"
                        from: 0
                        to: 1
                        duration: 200
                    }

                    NumberAnimation {
                        property: "scale"
                        from: 0.94
                        to: 1
                        duration: 220
                        easing.type: Easing.OutCubic
                    }
                }
            }
}
