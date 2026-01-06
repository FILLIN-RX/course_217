cmake_minimum_required(VERSION 3.16)
project(course_217 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

# 1. On ajoute Core5Compat pour le ColorOverlay (si tu l'utilises)
find_package(Qt6 REQUIRED COMPONENTS Quick QuickControls2 Svg Core5Compat)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appcourse_217 main.cpp)

qt_add_qml_module(appcourse_217
    URI course_217
    QML_FILES
        Files/Main.qml
        Files/layout/MainPage.qml
        Files/components/Sidebar.qml
        Files/components/TeacherCard.qml
        Files/pages/DashboardPage.qml
        Files/pages/Login.qml
        Files/pages/Register.qml
        Files/pages/ReportsPage.qml
        Files/pages/RoomsPage.qml
        Files/pages/SchedulePage.qml
        Files/pages/SessionsPage.qml
        Files/pages/SettingsPage.qml
        Files/pages/TeachersPage.qml
    RESOURCES # <-- C'EST ICI QUE TES SVG DOIVENT ÊTRE
        assets/icons/dashboard.svg
        assets/icons/calender.svg
        assets/icons/person.svg
        QML_FILES Files/components/StatCard.qml
        QML_FILES Files/components/DailySessionItem.qml
        QML_FILES Files/components/ScheduleCard.qml
        assets/MaterialIcons-Regular.ttf
        QML_FILES Files/components/LegendItem.qml
        QML_FILES Files/components/RoomCard.qml
)

# 2. On lie Core5Compat ici aussi
target_link_libraries(appcourse_217
    PRIVATE
        Qt6::Quick
        Qt6::QuickControls2
        Qt6::Svg
        Qt6::Core5Compat
)

include(GNUInstallDirs)
install(TARGETS appcourse_217
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
