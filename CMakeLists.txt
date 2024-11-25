cmake_minimum_required(VERSION 3.16)

project(mazaryn-desktop VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.5 REQUIRED COMPONENTS Quick)

qt_standard_project_setup(REQUIRES 6.5)

qt_add_executable(appmazaryn-desktop
    main.cpp
)

qt_add_qml_module(appmazaryn-desktop
    URI mazaryn-desktop
    VERSION 1.0
    QML_FILES
        Main.qml
        QML_FILES Signup.qml
        SOURCES signuphandler.h signuphandler.cpp
        RESOURCES
        SOURCES loginhandler.h loginhandler.cpp
        QML_FILES Login.qml
        QML_FILES ResetPass.qml
        SOURCES resetpasswordhandler.h resetpasswordhandler.cpp
        QML_FILES About.qml
        QML_FILES Contact.qml
        QML_FILES Careers.qml
        QML_FILES PrivacyPolicy.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appmazaryn-desktop PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appmazaryn-desktop
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appmazaryn-desktop
    PRIVATE Qt6::Quick
)

include(GNUInstallDirs)
install(TARGETS appmazaryn-desktop
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
