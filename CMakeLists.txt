cmake_minimum_required(VERSION 3.16)

project(course_217 VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Quick Svg)

qt_standard_project_setup(REQUIRES 6.8)

qt_add_executable(appcourse_217
    main.cpp
)

qt_add_qml_module(appcourse_217
    URI course_217
    QML_FILES
        Files/Main.qml
        Files/layout/MainPage.qml
        Files/components/Sidebar.qml
        Files/pages/DashboardPage.qml
        Files/pages/Login.qml
        Files/pages/Register.qml
        Files/pages/ReportsPage.qml
        Files/pages/RoomsPage.qml
        Files/pages/SchedulePage.qml
        Files/pages/SessionsPage.qml
        Files/pages/SettingsPage.qml
        Files/pages/TeachersPage.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appcourse_217 PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appcourse_217
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appcourse_217
    PRIVATE Qt6::Quick Qt6::Svg
)

include(GNUInstallDirs)
install(TARGETS appcourse_217
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
