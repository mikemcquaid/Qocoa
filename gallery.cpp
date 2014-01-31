#include "gallery.h"

#include <QVBoxLayout>
#include <QDialog>
#include <QDialogButtonBox>
#include <QIcon>
#include <QTextEdit>
#include <QPushButton>
#include <QDebug>
#include <QListWidget>
#include <QGroupBox>
#include <QLineEdit>

#include "qsearchfield.h"
#include "qbutton.h"
#include "qprogressindicatorspinning.h"
#include "qtoolbartabdialog.h"
#include "qslidebutton.h"


Gallery::Gallery(QWidget *parent) : QWidget(parent), m_toolbarTabDialog(0)
{
    setWindowTitle("Qocoa Gallery");
    QVBoxLayout *layout = new QVBoxLayout(this);

    QSearchField *searchField = new QSearchField(this);
    layout->addWidget(searchField);

    QSearchField *searchFieldPlaceholder = new QSearchField(this);
    searchFieldPlaceholder->setPlaceholderText("Placeholder text");
    layout->addWidget(searchFieldPlaceholder);

    QButton *roundedButton = new QButton(this, QButton::Rounded);
    roundedButton->setText("Button");
    layout->addWidget(roundedButton);

    QButton *regularSquareButton = new QButton(this, QButton::RegularSquare);
    regularSquareButton->setText("Button");
    layout->addWidget(regularSquareButton);

    QButton *disclosureButton = new QButton(this, QButton::Disclosure);
    layout->addWidget(disclosureButton);

    QButton *shadowlessSquareButton = new QButton(this, QButton::ShadowlessSquare);
    shadowlessSquareButton->setText("Button");
    layout->addWidget(shadowlessSquareButton);

    QButton *circularButton = new QButton(this, QButton::Circular);
    layout->addWidget(circularButton);

    QButton *textureSquareButton = new QButton(this, QButton::TexturedSquare);
    textureSquareButton->setText("Textured Button");
    layout->addWidget(textureSquareButton);

    QButton *helpButton = new QButton(this, QButton::HelpButton);
    layout->addWidget(helpButton);

    QButton *smallSquareButton = new QButton(this, QButton::SmallSquare);
    smallSquareButton->setText("Gradient Button");
    layout->addWidget(smallSquareButton);

    QButton *texturedRoundedButton = new QButton(this, QButton::TexturedRounded);
    texturedRoundedButton->setText("Round Textured");
    layout->addWidget(texturedRoundedButton);

    QButton *roundedRectangleButton = new QButton(this, QButton::RoundRect);
    roundedRectangleButton->setText("Rounded Rect Button");
    layout->addWidget(roundedRectangleButton);

    QButton *recessedButton = new QButton(this, QButton::Recessed);
    recessedButton->setText("Recessed Button");
    layout->addWidget(recessedButton);

    QButton *roundedDisclosureButton = new QButton(this, QButton::RoundedDisclosure);
    layout->addWidget(roundedDisclosureButton);

#ifdef __MAC_10_7
    QButton *inlineButton = new QButton(this, QButton::Inline);
    inlineButton->setText("Inline Button");
    layout->addWidget(inlineButton);
#endif

    QProgressIndicatorSpinning *progressIndicatorSpinning = new QProgressIndicatorSpinning(this);
    progressIndicatorSpinning->animate();
    layout->addWidget(progressIndicatorSpinning);

    QSlideButton* slider = new QSlideButton(this);
    layout->addWidget(slider);

    QButton *openTabWidget = new QButton(this, QButton::Rounded);
    openTabWidget->setText("Toolbar Tab Widget");
    connect(openTabWidget, SIGNAL(clicked(bool)), this, SLOT(showTabToolbarWidget()));
    layout->addWidget(openTabWidget);
}

void Gallery::showTabToolbarWidget() {
    if (!m_toolbarTabDialog) {
        m_toolbarTabDialog = new QToolbarTabDialog;
        connect(m_toolbarTabDialog, SIGNAL(accepted()), this, SLOT(tabToolbarWidgetAccepted()));
        connect(m_toolbarTabDialog, SIGNAL(rejected()), this, SLOT(tabToolbarWidgetRejected()));

        QSearchField *searchField = new QSearchField(0);
        m_toolbarTabDialog->addTab(searchField, QPixmap( ":/user-home.png" ), "Home", "Go Home");

        QButton *b1 = new QButton(0, QButton::Recessed);
        b1->setText("You've reached the trash");
        m_toolbarTabDialog->addTab(b1, QPixmap( ":/user-trash.png" ), "Trash", "Trash it. Try me.");

        QPushButton *b2 = new QPushButton(0);
        b2->setText("Search is futile");
        m_toolbarTabDialog->addTab(b2, QPixmap( ":/bookmarks.png" ), "Bookmarks", "Look for some bookmarks");

        QTextEdit* textEdit = new QTextEdit;
        textEdit->setText("This is some text!");
        m_toolbarTabDialog->addTab(textEdit, QPixmap( ":/bookmarks.png" ), "Text", "Some text editing eh?");

        QGroupBox* groupBox = new QGroupBox;
        groupBox->setLayout(new QVBoxLayout);
        groupBox->layout()->addWidget(new QLineEdit());
        QListWidget* lw = new QListWidget;
        for (int i = 0; i < 30; ++i) {
            lw->addItem("1213123123 12 21 2 2 " + i);
        }
        groupBox->layout()->addWidget(lw);
        m_toolbarTabDialog->addTab(groupBox, QPixmap( ":/user-home.png" ), "List", "Some lists!" );

        QLineEdit* lineEdit = new QLineEdit;
        m_toolbarTabDialog->addTab(lineEdit, QPixmap(":/user-home.png"), "LineEdit", "eh?");

        QLineEdit* lineEdit2 = new QLineEdit;
        m_toolbarTabDialog->addTab(lineEdit2, QPixmap(":/user-home.png"), "LineEdit2", "eh?");

        QListWidget* lw2 = new QListWidget;
        for (int i = 0; i < 30; ++i) {
            lw2->addItem("1213123123 12 21 2 2 " + i);
        }
        m_toolbarTabDialog->addTab(lw2, QPixmap( ":/user-home.png" ), "Just a list", "Some lists hey oh!" );


        m_toolbarTabDialog->setCurrentIndex(0);
    }

    m_toolbarTabDialog->show();
}

void Gallery::tabToolbarWidgetAccepted() {
    m_toolbarTabDialog->deleteLater();
    m_toolbarTabDialog = 0;
}

void Gallery::tabToolbarWidgetRejected() {
//    delete m_toolbarTabDialog;
//    m_toolbarTabDialog = 0;
}
