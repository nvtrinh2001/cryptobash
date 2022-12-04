/********************************************************************************
** Form generated from reading UI file 'QtGnuplotSettings.ui'
**
** Created by: Qt User Interface Compiler version 5.15.7
**
** WARNING! All changes made in this file will be lost when recompiling UI file!
********************************************************************************/

#ifndef UI_QTGNUPLOTSETTINGS_H
#define UI_QTGNUPLOTSETTINGS_H

#include <QtCore/QVariant>
#include <QtGui/QIcon>
#include <QtWidgets/QApplication>
#include <QtWidgets/QCheckBox>
#include <QtWidgets/QComboBox>
#include <QtWidgets/QDialog>
#include <QtWidgets/QDialogButtonBox>
#include <QtWidgets/QHBoxLayout>
#include <QtWidgets/QLabel>
#include <QtWidgets/QPushButton>
#include <QtWidgets/QSpacerItem>
#include <QtWidgets/QVBoxLayout>

QT_BEGIN_NAMESPACE

class Ui_settingsDialog
{
public:
    QVBoxLayout *verticalLayout_2;
    QVBoxLayout *verticalLayout;
    QHBoxLayout *horizontalLayout;
    QPushButton *backgroundButton;
    QSpacerItem *horizontalSpacer;
    QLabel *sampleColorLabel;
    QCheckBox *antialiasCheckBox;
    QCheckBox *replotOnResizeCheckBox;
    QCheckBox *roundedCheckBox;
    QCheckBox *ctrlQCheckBox;
    QHBoxLayout *horizontalLayout_2;
    QLabel *label;
    QComboBox *mouseLabelComboBox;
    QDialogButtonBox *buttonBox;

    void setupUi(QDialog *settingsDialog)
    {
        if (settingsDialog->objectName().isEmpty())
            settingsDialog->setObjectName(QString::fromUtf8("settingsDialog"));
        settingsDialog->resize(269, 186);
        QIcon icon;
        icon.addFile(QString::fromUtf8(":/images/settings"), QSize(), QIcon::Normal, QIcon::Off);
        settingsDialog->setWindowIcon(icon);
        verticalLayout_2 = new QVBoxLayout(settingsDialog);
        verticalLayout_2->setObjectName(QString::fromUtf8("verticalLayout_2"));
        verticalLayout = new QVBoxLayout();
        verticalLayout->setObjectName(QString::fromUtf8("verticalLayout"));
        horizontalLayout = new QHBoxLayout();
        horizontalLayout->setObjectName(QString::fromUtf8("horizontalLayout"));
        backgroundButton = new QPushButton(settingsDialog);
        backgroundButton->setObjectName(QString::fromUtf8("backgroundButton"));

        horizontalLayout->addWidget(backgroundButton);

        horizontalSpacer = new QSpacerItem(40, 20, QSizePolicy::Expanding, QSizePolicy::Minimum);

        horizontalLayout->addItem(horizontalSpacer);

        sampleColorLabel = new QLabel(settingsDialog);
        sampleColorLabel->setObjectName(QString::fromUtf8("sampleColorLabel"));

        horizontalLayout->addWidget(sampleColorLabel);


        verticalLayout->addLayout(horizontalLayout);

        antialiasCheckBox = new QCheckBox(settingsDialog);
        antialiasCheckBox->setObjectName(QString::fromUtf8("antialiasCheckBox"));

        verticalLayout->addWidget(antialiasCheckBox);

        replotOnResizeCheckBox = new QCheckBox(settingsDialog);
        replotOnResizeCheckBox->setObjectName(QString::fromUtf8("replotOnResizeCheckBox"));

        verticalLayout->addWidget(replotOnResizeCheckBox);

        roundedCheckBox = new QCheckBox(settingsDialog);
        roundedCheckBox->setObjectName(QString::fromUtf8("roundedCheckBox"));

        verticalLayout->addWidget(roundedCheckBox);

        ctrlQCheckBox = new QCheckBox(settingsDialog);
        ctrlQCheckBox->setObjectName(QString::fromUtf8("ctrlQCheckBox"));

        verticalLayout->addWidget(ctrlQCheckBox);

        horizontalLayout_2 = new QHBoxLayout();
        horizontalLayout_2->setObjectName(QString::fromUtf8("horizontalLayout_2"));
        label = new QLabel(settingsDialog);
        label->setObjectName(QString::fromUtf8("label"));
        label->setAlignment(Qt::AlignRight|Qt::AlignTrailing|Qt::AlignVCenter);

        horizontalLayout_2->addWidget(label);

        mouseLabelComboBox = new QComboBox(settingsDialog);
        mouseLabelComboBox->addItem(QString());
        mouseLabelComboBox->addItem(QString());
        mouseLabelComboBox->addItem(QString());
        mouseLabelComboBox->addItem(QString());
        mouseLabelComboBox->setObjectName(QString::fromUtf8("mouseLabelComboBox"));

        horizontalLayout_2->addWidget(mouseLabelComboBox);


        verticalLayout->addLayout(horizontalLayout_2);


        verticalLayout_2->addLayout(verticalLayout);

        buttonBox = new QDialogButtonBox(settingsDialog);
        buttonBox->setObjectName(QString::fromUtf8("buttonBox"));
        buttonBox->setOrientation(Qt::Horizontal);
        buttonBox->setStandardButtons(QDialogButtonBox::Cancel|QDialogButtonBox::Ok);

        verticalLayout_2->addWidget(buttonBox);


        retranslateUi(settingsDialog);
        QObject::connect(buttonBox, SIGNAL(accepted()), settingsDialog, SLOT(accept()));
        QObject::connect(buttonBox, SIGNAL(rejected()), settingsDialog, SLOT(reject()));

        QMetaObject::connectSlotsByName(settingsDialog);
    } // setupUi

    void retranslateUi(QDialog *settingsDialog)
    {
        settingsDialog->setWindowTitle(QCoreApplication::translate("settingsDialog", "Terminal configuration", nullptr));
        backgroundButton->setText(QCoreApplication::translate("settingsDialog", "Select background color", nullptr));
        sampleColorLabel->setText(QCoreApplication::translate("settingsDialog", "Sample", nullptr));
        antialiasCheckBox->setText(QCoreApplication::translate("settingsDialog", "Antialias", nullptr));
        replotOnResizeCheckBox->setText(QCoreApplication::translate("settingsDialog", "Replot on resize", nullptr));
        roundedCheckBox->setText(QCoreApplication::translate("settingsDialog", "Rounded line ends", nullptr));
        ctrlQCheckBox->setText(QCoreApplication::translate("settingsDialog", "ctrl-q closes plot window", nullptr));
        label->setText(QCoreApplication::translate("settingsDialog", "Mouse label", nullptr));
        mouseLabelComboBox->setItemText(0, QCoreApplication::translate("settingsDialog", "Status bar", nullptr));
        mouseLabelComboBox->setItemText(1, QCoreApplication::translate("settingsDialog", "Tool bar", nullptr));
        mouseLabelComboBox->setItemText(2, QCoreApplication::translate("settingsDialog", "Above plot", nullptr));
        mouseLabelComboBox->setItemText(3, QCoreApplication::translate("settingsDialog", "None", nullptr));

    } // retranslateUi

};

namespace Ui {
    class settingsDialog: public Ui_settingsDialog {};
} // namespace Ui

QT_END_NAMESPACE

#endif // UI_QTGNUPLOTSETTINGS_H
