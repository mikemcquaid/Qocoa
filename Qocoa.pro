SOURCES += main.cpp \
           gallery.cpp \

HEADERS += gallery.h \
           qocoa_mac.h \
           qsearchfield.h \
           qbutton.h \
           qprogressindicatorspinning.h \
           qtoolbartabdialog.h

RESOURCES += resources.qrc

mac {
    OBJECTIVE_SOURCES += qsearchfield_mac.mm qbutton_mac.mm qprogressindicatorspinning_mac.mm qtoolbartabdialog_mac.mm
    LIBS += -framework Foundation -framework Appkit
    QMAKE_CFLAGS += -mmacosx-version-min=10.6
} else {
    HEADERS += qtoolbartabdialog_nonmac.cpp
    SOURCES += qsearchfield_nonmac.cpp qbutton_nonmac.cpp qprogressindicatorspinning_nonmac.cpp qtoolbartabdialog_nonmac.cpp
    RESOURCES += qsearchfield_nonmac.qrc qprogressindicatorspinning_nonmac.qrc
}
