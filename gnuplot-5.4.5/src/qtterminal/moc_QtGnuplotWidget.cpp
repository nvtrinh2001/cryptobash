/****************************************************************************
** Meta object code from reading C++ file 'QtGnuplotWidget.h'
**
** Created by: The Qt Meta Object Compiler version 67 (Qt 5.15.7)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include <memory>
#include "QtGnuplotWidget.h"
#include <QtCore/qbytearray.h>
#include <QtCore/qmetatype.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'QtGnuplotWidget.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 67
#error "This file was generated using the moc from 5.15.7. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

QT_BEGIN_MOC_NAMESPACE
QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
struct qt_meta_stringdata_QtGnuplotWidget_t {
    QByteArrayData data[20];
    char stringdata0[223];
};
#define QT_MOC_LITERAL(idx, ofs, len) \
    Q_STATIC_BYTE_ARRAY_DATA_HEADER_INITIALIZER_WITH_OFFSET(len, \
    qptrdiff(offsetof(qt_meta_stringdata_QtGnuplotWidget_t, stringdata0) + ofs \
        - idx * sizeof(QByteArrayData)) \
    )
static const qt_meta_stringdata_QtGnuplotWidget_t qt_meta_stringdata_QtGnuplotWidget = {
    {
QT_MOC_LITERAL(0, 0, 15), // "QtGnuplotWidget"
QT_MOC_LITERAL(1, 16, 8), // "plotDone"
QT_MOC_LITERAL(2, 25, 0), // ""
QT_MOC_LITERAL(3, 26, 17), // "statusTextChanged"
QT_MOC_LITERAL(4, 44, 6), // "status"
QT_MOC_LITERAL(5, 51, 15), // "copyToClipboard"
QT_MOC_LITERAL(6, 67, 5), // "print"
QT_MOC_LITERAL(7, 73, 9), // "QPrinter&"
QT_MOC_LITERAL(8, 83, 7), // "printer"
QT_MOC_LITERAL(9, 91, 11), // "exportToPdf"
QT_MOC_LITERAL(10, 103, 8), // "fileName"
QT_MOC_LITERAL(11, 112, 11), // "exportToEps"
QT_MOC_LITERAL(12, 124, 13), // "exportToImage"
QT_MOC_LITERAL(13, 138, 11), // "exportToSvg"
QT_MOC_LITERAL(14, 150, 9), // "antialias"
QT_MOC_LITERAL(15, 160, 7), // "rounded"
QT_MOC_LITERAL(16, 168, 5), // "ctrlQ"
QT_MOC_LITERAL(17, 174, 14), // "replotOnResize"
QT_MOC_LITERAL(18, 189, 15), // "backgroundColor"
QT_MOC_LITERAL(19, 205, 17) // "statusLabelActive"

    },
    "QtGnuplotWidget\0plotDone\0\0statusTextChanged\0"
    "status\0copyToClipboard\0print\0QPrinter&\0"
    "printer\0exportToPdf\0fileName\0exportToEps\0"
    "exportToImage\0exportToSvg\0antialias\0"
    "rounded\0ctrlQ\0replotOnResize\0"
    "backgroundColor\0statusLabelActive"
};
#undef QT_MOC_LITERAL

static const uint qt_meta_data_QtGnuplotWidget[] = {

 // content:
       8,       // revision
       0,       // classname
       0,    0, // classinfo
       8,   14, // methods
       6,   72, // properties
       0,    0, // enums/sets
       0,    0, // constructors
       0,       // flags
       2,       // signalCount

 // signals: name, argc, parameters, tag, flags
       1,    0,   54,    2, 0x06 /* Public */,
       3,    1,   55,    2, 0x06 /* Public */,

 // slots: name, argc, parameters, tag, flags
       5,    0,   58,    2, 0x0a /* Public */,
       6,    1,   59,    2, 0x0a /* Public */,
       9,    1,   62,    2, 0x0a /* Public */,
      11,    0,   65,    2, 0x0a /* Public */,
      12,    1,   66,    2, 0x0a /* Public */,
      13,    1,   69,    2, 0x0a /* Public */,

 // signals: parameters
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,    4,

 // slots: parameters
    QMetaType::Void,
    QMetaType::Void, 0x80000000 | 7,    8,
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void,
    QMetaType::Void, QMetaType::QString,   10,
    QMetaType::Void, QMetaType::QString,   10,

 // properties: name, type, flags
      14, QMetaType::Bool, 0x00095103,
      15, QMetaType::Bool, 0x00095103,
      16, QMetaType::Bool, 0x00095103,
      17, QMetaType::Bool, 0x00095103,
      18, QMetaType::QColor, 0x00095103,
      19, QMetaType::Bool, 0x00095103,

       0        // eod
};

void QtGnuplotWidget::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    if (_c == QMetaObject::InvokeMetaMethod) {
        auto *_t = static_cast<QtGnuplotWidget *>(_o);
        (void)_t;
        switch (_id) {
        case 0: _t->plotDone(); break;
        case 1: _t->statusTextChanged((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 2: _t->copyToClipboard(); break;
        case 3: _t->print((*reinterpret_cast< QPrinter(*)>(_a[1]))); break;
        case 4: _t->exportToPdf((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 5: _t->exportToEps(); break;
        case 6: _t->exportToImage((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        case 7: _t->exportToSvg((*reinterpret_cast< const QString(*)>(_a[1]))); break;
        default: ;
        }
    } else if (_c == QMetaObject::IndexOfMethod) {
        int *result = reinterpret_cast<int *>(_a[0]);
        {
            using _t = void (QtGnuplotWidget::*)();
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&QtGnuplotWidget::plotDone)) {
                *result = 0;
                return;
            }
        }
        {
            using _t = void (QtGnuplotWidget::*)(const QString & );
            if (*reinterpret_cast<_t *>(_a[1]) == static_cast<_t>(&QtGnuplotWidget::statusTextChanged)) {
                *result = 1;
                return;
            }
        }
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty) {
        auto *_t = static_cast<QtGnuplotWidget *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: *reinterpret_cast< bool*>(_v) = _t->antialias(); break;
        case 1: *reinterpret_cast< bool*>(_v) = _t->rounded(); break;
        case 2: *reinterpret_cast< bool*>(_v) = _t->ctrlQ(); break;
        case 3: *reinterpret_cast< bool*>(_v) = _t->replotOnResize(); break;
        case 4: *reinterpret_cast< QColor*>(_v) = _t->backgroundColor(); break;
        case 5: *reinterpret_cast< bool*>(_v) = _t->statusLabelActive(); break;
        default: break;
        }
    } else if (_c == QMetaObject::WriteProperty) {
        auto *_t = static_cast<QtGnuplotWidget *>(_o);
        (void)_t;
        void *_v = _a[0];
        switch (_id) {
        case 0: _t->setAntialias(*reinterpret_cast< bool*>(_v)); break;
        case 1: _t->setRounded(*reinterpret_cast< bool*>(_v)); break;
        case 2: _t->setCtrlQ(*reinterpret_cast< bool*>(_v)); break;
        case 3: _t->setReplotOnResize(*reinterpret_cast< bool*>(_v)); break;
        case 4: _t->setBackgroundColor(*reinterpret_cast< QColor*>(_v)); break;
        case 5: _t->setStatusLabelActive(*reinterpret_cast< bool*>(_v)); break;
        default: break;
        }
    } else if (_c == QMetaObject::ResetProperty) {
    }
#endif // QT_NO_PROPERTIES
}

QT_INIT_METAOBJECT const QMetaObject QtGnuplotWidget::staticMetaObject = { {
    QMetaObject::SuperData::link<QWidget::staticMetaObject>(),
    qt_meta_stringdata_QtGnuplotWidget.data,
    qt_meta_data_QtGnuplotWidget,
    qt_static_metacall,
    nullptr,
    nullptr
} };


const QMetaObject *QtGnuplotWidget::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *QtGnuplotWidget::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_meta_stringdata_QtGnuplotWidget.stringdata0))
        return static_cast<void*>(this);
    if (!strcmp(_clname, "QtGnuplotEventReceiver"))
        return static_cast< QtGnuplotEventReceiver*>(this);
    return QWidget::qt_metacast(_clname);
}

int QtGnuplotWidget::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QWidget::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 8)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 8;
    } else if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 8)
            *reinterpret_cast<int*>(_a[0]) = -1;
        _id -= 8;
    }
#ifndef QT_NO_PROPERTIES
    else if (_c == QMetaObject::ReadProperty || _c == QMetaObject::WriteProperty
            || _c == QMetaObject::ResetProperty || _c == QMetaObject::RegisterPropertyMetaType) {
        qt_static_metacall(this, _c, _id, _a);
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyDesignable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyScriptable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyStored) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyEditable) {
        _id -= 6;
    } else if (_c == QMetaObject::QueryPropertyUser) {
        _id -= 6;
    }
#endif // QT_NO_PROPERTIES
    return _id;
}

// SIGNAL 0
void QtGnuplotWidget::plotDone()
{
    QMetaObject::activate(this, &staticMetaObject, 0, nullptr);
}

// SIGNAL 1
void QtGnuplotWidget::statusTextChanged(const QString & _t1)
{
    void *_a[] = { nullptr, const_cast<void*>(reinterpret_cast<const void*>(std::addressof(_t1))) };
    QMetaObject::activate(this, &staticMetaObject, 1, _a);
}
QT_WARNING_POP
QT_END_MOC_NAMESPACE