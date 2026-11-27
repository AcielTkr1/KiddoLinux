import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Qt5Compat.GraphicalEffects

Rectangle {
    id: root
    
    property string language: savedLanguage

    width: 1366
    height: 850
    color: "#EAF4FF"

    property string currentPage: "Home"
    property string pendingPage: ""
    property string selectedSetting: ""
    property bool showActivityToast: false

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

    property string selectedMessage: ""
    property var profileData: ({})
    property var progressData: ({})
    property var activityHistory: []

    function refreshProgress() {
        profileData = progressManager.getProfile()
        progressData = progressManager.getProgress()
        activityHistory = progressManager.getActivityHistory()
    }

    function isActivityCompleted(name, category) {
        return progressManager.isActivityCompleted(name, category)
    }

    function completeActivity(name, category, xp) {
        return progressManager.completeActivity(name, category, xp)
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

            var description = root.language === "en"
                ? item.description_en
                : item.description_id

            return item.name.toLowerCase().includes(keyword)
                || description.toLowerCase().includes(keyword)
        }).map(function(item) {
            var description = root.language === "en"
                ? item.description_en
                : item.description_id

            return {
                name: item.name,
                icon: item.icon,
                description: description,
                available: item.available
            }
        })
    }

    switch (currentPage) {
    case "Games":
        var games = [
            {
                name: root.tx("Teka-teki", "Puzzle"),
                icon: "🧩",
                description: root.tx(
                    "Asah kemampuan berpikir",
                    "Sharpen your thinking skills"
                )
            },
            {
                name: root.tx("Permainan Ingatan", "Memory Game") ,
                icon: "🧠",
                description: root.tx(
                    "Latih daya ingat",
                    "Train your memory"
                )
            },
            {
                name: root.tx("Tantangan Matematika", "Math Challenge"),
                icon: "➗",
                description: root.tx(
                    "Tantangan matematika",
                    "Math challenge"
                )
            }
        ]

        var gameKeyword = root.searchText.toLowerCase()

        return games.filter(function(item) {
            return item.name.toLowerCase().includes(gameKeyword)
                || item.description.toLowerCase().includes(gameKeyword)
        })


    case "Library":
        return [
            {
                name: root.tx ("Sains", "Science"),
                icon: "🔬",
                description: root.tx(
                    "Materi ilmu pengetahuan",
                    "Science learning materials"
                )
            },
            {
                name: root.tx("Matematika", "Mathematics"),
                icon: "📐",
                description: root.tx(
                    "Materi matematika",
                    "Mathematics learning materials"
                )
            },
            {
                name: root.tx("Bahasa", "Languages"),
                icon: "🌍",
                description: root.tx(
                    "Belajar bahasa",
                    "Learn new languages"
                )
            },
            {
                name: root.tx("Teknologi", "Technology"),
                icon: "🚀",
                description: root.tx(
                    "Mengenal teknologi",
                    "Explore technology"
                )
            }
        ]

    case "Achievements":
        return [
            {
                name: root.tx("Penjelajah Pertama", "First Explorer"),
                icon: "🌟",
                description: root.tx(
                    "Memulai petualangan",
                    "Starting your adventure"
                )
            },
            {
                name: root.tx("Kreator Cilik", "Little Creator"),
                icon: "🎨",
                description: root.tx(
                    "Membuat karya pertama",
                    "Creating your first masterpiece"
                )
            },
            {
                name: 	root.tx("Pemula Coding", "Code Beginner"),
                icon: "💻",
                description: root.tx(
                    "Mengenal pemrograman",
                    "Discovering the world of coding"
                )
            }
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
            root.selectedMessage = ""
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

        function onMessageChanged(indonesian, english) {
            root.selectedMessage = root.tx(
                indonesian,
                english
            )
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

                            root.selectedMessage = root.tx(
                                "Pengaturan Kiddo Home",
                                "Kiddo Home Settings"
                            )
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
                                text: root.pageLabel(modelData.name)
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

                    visible: root.currentPage !== "Home"
                            && root.currentPage !== "Achievements"
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
                            z: 0

                            anchors.fill: parent
                            anchors.bottomMargin: modelData.available === true ? 75 : 0

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
                                    visible: root.currentPage === "Learn"
                                        || root.currentPage === "Create"
                                        || root.currentPage === "Coding"

                                    text: modelData.available
                                        ? root.tx("● Terpasang", "● Installed")
                                        : root.tx("● Belum terpasang", "● Not Installed")

                                    color: modelData.available
                                        ? "#35A879"
                                        : "#E58A45"

                                    font.pixelSize: 11
                                    font.bold: true
                                    anchors.horizontalCenter: parent.horizontalCenter
                                }

                                Button {
                                    z: 1

                                    text: {
                                        var completedCount = root.progressData.completedActivities

                                        return root.isActivityCompleted(
                                            modelData.name,
                                            root.currentPage
                                        )
                                        ? root.tx("✓ Selesai", "✓ Completed")
                                        : root.tx("Tandai Selesai", "Mark as Completed")
                                    }

                                    visible: modelData.available === true

                                    enabled: {
                                        var completedCount = root.progressData.completedActivities

                                        return !root.isActivityCompleted(
                                            modelData.name,
                                            root.currentPage
                                        )
                                    }

                                    anchors.horizontalCenter: parent.horizontalCenter

                                    onClicked: {
                                        var success = root.completeActivity(
                                            modelData.name,
                                            root.currentPage,
                                            20
                                        )

                                        if (success) {
                                            root.refreshProgress()

                                            root.selectedMessage = root.tx(
                                                modelData.name + " selesai! Kamu mendapatkan 20 XP!",
                                                modelData.name + " completed! You earned 20 XP!"
                                            )

                                            root.showActivityToast = true
                                            activityToastTimer.restart()
                                        }
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
                            && root.currentPage !== "Achievements"
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

                // ACTIVITY HISTORY
                Rectangle {
                    id: historyPanel

                    anchors.fill: parent

                    visible: root.currentPage === "Achievements"

                    color: "transparent"

                    ScrollView {
                        id: historyScroll

                        anchors.fill: parent
                        clip: true

                        contentWidth: availableWidth

                        onVisibleChanged: {
                            if (visible) {
                                Qt.callLater(function() {
                                    historyScroll.contentItem.contentY = 0
                                })
                            }
                        }
                        ColumnLayout {
                            width: historyScroll.availableWidth
                            spacing: 14

                            // HEADER
                            Text {
                                text: root.tx(
                                    "🏆 Perjalanan Hebatmu!",
                                    "🏆 Your Amazing Journey!"
                                )

                                font.pixelSize: 23
                                font.bold: true
                                color: "#24477E"

                                Layout.fillWidth: true
                            }

                            Text {
                                text: root.tx(
                                    "Lihat semua aktivitas yang sudah kamu selesaikan.",
                                    "See all the activities you have completed."
                                )

                                font.pixelSize: 13
                                color: "#71839B"

                                Layout.fillWidth: true
                            }

                            // ACHIEVEMENT HERO CARD
                            Rectangle {
                                Layout.fillWidth: true
                                Layout.preferredHeight: 155

                                radius: 24
                                border.color: "#B9D8FF"
                                border.width: 1

                                gradient: Gradient {
                                    GradientStop {
                                        position: 0.0
                                        color: "#3987F6"
                                    }

                                    GradientStop {
                                        position: 1.0
                                        color: "#7459D9"
                                    }
                                }

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 20
                                    spacing: 18

                                    // ROBOT MASCOT
                                    Rectangle {
                                        Layout.preferredWidth: 105
                                        Layout.preferredHeight: 105

                                        radius: 28
                                        color: "#FFFFFF"

                                        Text {
                                            anchors.centerIn: parent

                                            text: {
                                                var avatar = root.profileData.avatar || "robot_blue"

                                                if (avatar === "robot_pink")
                                                    return "👩‍🚀"
                                                else if (avatar === "robot_green")
                                                    return "👽"
                                                else if (avatar === "robot_yellow")
                                                    return "🧑‍🚀"
                                                else
                                                    return "🤖"
                                            }

                                            font.pixelSize: 65
                                        }
                                    }

                                    // PROFILE INFORMATION
                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 7

                                        Text {
                                            text: root.tx(
                                                "HEBAT SEKALI!",
                                                "YOU ARE AMAZING!"
                                            )

                                            font.pixelSize: 11
                                            font.bold: true
                                            color: "#DCEBFF"
                                        }

                                        Text {
                                            text: root.profileData.name
                                                || root.tx("Teman Hebat", "Super Friend")

                                            font.pixelSize: 23
                                            font.bold: true
                                            color: "white"

                                            Layout.fillWidth: true
                                            elide: Text.ElideRight
                                        }

                                        Text {
                                            text: "⭐ "
                                                + root.tx("Level ", "Level ")
                                                + (root.progressData.level || 1)

                                            font.pixelSize: 17
                                            font.bold: true
                                            color: "#FFE89A"
                                        }

                                        Text {
                                            text: root.tx(
                                                "Terus belajar dan kumpulkan bintang!",
                                                "Keep learning and collecting stars!"
                                            )

                                            font.pixelSize: 12
                                            color: "#EAF4FF"
                                        }
                                    }

                                    // TOTAL XP
                                    Rectangle {
                                        Layout.preferredWidth: 115
                                        Layout.preferredHeight: 85

                                        radius: 18
                                        color: "#FFFFFF"
                                        opacity: 0.95

                                        Column {
                                            anchors.centerIn: parent
                                            spacing: 5

                                            Text {
                                                text: "⚡"
                                                font.pixelSize: 22
                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }

                                            Text {
                                                text: (root.progressData.experience || 0)
                                                    + " XP"

                                                font.pixelSize: 20
                                                font.bold: true
                                                color: "#3987F6"

                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }

                                            Text {
                                                text: root.tx("Total XP", "Total XP")
                                                font.pixelSize: 11
                                                color: "#71839B"

                                                anchors.horizontalCenter: parent.horizontalCenter
                                            }
                                        }
                                    }
                                }
                            }

                            // COMPLETED ACTIVITIES STATISTIC
                            Rectangle {
                                visible: root.currentPage === "Achievements"

                                Layout.fillWidth: true
                                Layout.preferredHeight: 85

                                radius: 20
                                color: "white"
                                border.color: "#DCEBFF"
                                border.width: 1

                                RowLayout {
                                    anchors.fill: parent
                                    anchors.margins: 18
                                    spacing: 15

                                    Rectangle {
                                        Layout.preferredWidth: 50
                                        Layout.preferredHeight: 50

                                        radius: 15
                                        color: "#EAF4FF"

                                        Text {
                                            anchors.centerIn: parent
                                            text: "🏆"
                                            font.pixelSize: 27
                                        }
                                    }

                                    ColumnLayout {
                                        Layout.fillWidth: true
                                        spacing: 4
                                            font.bold: true
                                            color: "#24477E"
                                        }

                                        Text {
                                            text: root.tx(
                                                "Terus kumpulkan pencapaianmu!",
                                                "Keep collecting your achievements!"
                                            )

                                            font.pixelSize: 11
                                            color: "#71839B"
                                        }
                                    }

                                    Text {
                                        text: String(
                                            root.progressData.completedActivities || 0
                                        )

                                        font.pixelSize: 30
                                        font.bold: true
                                        color: "#3987F6"
                                    }
                                }
                            }

                            // EMPTY HISTORY
                            Rectangle {
                                visible: root.activityHistory.length === 0

                                Layout.fillWidth: true
                                Layout.preferredHeight: 190

                                radius: 20
                                color: "white"

                                Column {
                                    anchors.centerIn: parent
                                    spacing: 12

                                    Text {
                                        text: "🤖"
                                        font.pixelSize: 48
                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Text {
                                        text: root.tx(
                                            "Belum ada aktivitas!",
                                            "No activities yet!"
                                        )

                                        font.pixelSize: 18
                                        font.bold: true
                                        color: "#24477E"

                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }

                                    Text {
                                        text: root.tx(
                                            "Ayo selesaikan aktivitas pertamamu!",
                                            "Complete your first activity!"
                                        )

                                        font.pixelSize: 13
                                        color: "#71839B"

                                        anchors.horizontalCenter: parent.horizontalCenter
                                    }
                                }
                            }

                            // HISTORY LIST
                            Repeater {
                                model: root.activityHistory

                                delegate: Rectangle {
                                    required property var modelData

                                    Layout.fillWidth: true
                                    Layout.preferredHeight: 95

                                    radius: 18
                                    color: "white"

                                    border.color: "#DCEBFF"
                                    border.width: 1

                                    RowLayout {
                                        anchors.fill: parent
                                        anchors.margins: 16
                                        spacing: 14

                                        // ACTIVITY ICON
                                        Rectangle {
                                            Layout.preferredWidth: 58
                                            Layout.preferredHeight: 58

                                            radius: 16
                                            color: "#EAF4FF"

                                            Text {
                                                anchors.centerIn: parent

                                                text: modelData.category === "Coding"
                                                    ? "💻"
                                                    : modelData.category === "Create"
                                                        ? "🎨"
                                                        : "📚"

                                                font.pixelSize: 29
                                            }
                                        }

                                        // ACTIVITY INFORMATION
                                        ColumnLayout {
                                            Layout.fillWidth: true
                                            spacing: 5

                                            Text {
                                                text: modelData.name

                                                font.pixelSize: 16
                                                font.bold: true
                                                color: "#24477E"

                                                Layout.fillWidth: true
                                            }

                                            Text {
                                                text: {
                                                    var date = new Date(modelData.date)

                                                    var day = date.getDate()
                                                    var months = [
                                                        "Jan", "Feb", "Mar", "Apr",
                                                        "Mei", "Jun", "Jul", "Agu",
                                                        "Sep", "Okt", "Nov", "Des"
                                                    ]

                                                    var month = months[date.getMonth()]
                                                    var year = date.getFullYear()

                                                    return modelData.category
                                                        + " • "
                                                        + day + " " + month + " " + year
                                                }

                                                font.pixelSize: 11
                                                color: "#71839B"

                                                Layout.fillWidth: true
                                            }
                                        }

                                        // XP BADGE
                                        Rectangle {
                                            Layout.preferredWidth: 85
                                            Layout.preferredHeight: 38

                                            radius: 12
                                            color: "#FFF3D6"

                                            Text {
                                                anchors.centerIn: parent

                                                text: "+" + modelData.xp + " XP"

                                                font.pixelSize: 13
                                                font.bold: true
                                                color: "#D99A20"
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }


            // LEVEL PROGRESS
            Rectangle {
                visible: root.currentPage === "Achievements"

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
                    visible: root.currentPage === "Achievements"

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
                            text: root.selectedMessage.length === 0
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
                            text: "🌟 "
                            + root.tx("Level ", "Level ")
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

                                settingsManager.saveLanguage("id")

                                root.refreshCategoryItems()
                                root.selectedMessage = root.tx(
                                    "Bahasa berhasil diubah ke Indonesia!",
                                    "Language changed to Indonesian!"
                                )
                            }
                        }

                        Button {
                            text: "🇬🇧 English"
                            width: 200
                            height: 45

                            onClicked: {
                                root.language = "en"

                                settingsManager.saveLanguage("en")

                                root.refreshCategoryItems()
                                root.selectedMessage = root.tx(
                                    "Bahasa berhasil diubah ke Inggris!",
                                    "Language changed to English!"
                                )
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

        // ACTIVITY NOTIFICATION TIMER
        Timer {
            id: activityToastTimer
            interval: 3000

            onTriggered: {
                root.showActivityToast = false
            }
        }

        // ACTIVITY NOTIFICATION
        Rectangle {
            id: activityToast

            visible: root.showActivityToast

            width: 460
            height: 75

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 25

            radius: 18
            color: "#24477E"

            z: 9999

            Text {
                anchors.fill: parent
                anchors.margins: 15

                text: "🤖  " + root.selectedMessage

                color: "white"
                font.pixelSize: 15
                font.bold: true

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                wrapMode: Text.WordWrap
            }
        }
}
