/*
 Copyright (C) 2012 by Leo Franchi <lfranchi@kde.org>

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 */
#ifndef QSLIDEBUTTON_H
#define QSLIDEBUTTON_H

#include <QWidget>
#include <QPointer>

/**
 * Slider button similar to what you get on iOS.
 *
 * By default on/off text is On/Off
 */

class QSlideButtonPrivate;
class QSlideButton : public QWidget
{
    Q_OBJECT
public:
    explicit QSlideButton(QWidget *parent);

public slots:
    void setOnText(const QString &text);
    void setOffText(const QString &text);

    void setChecked(bool checked);

    QSize sizeHint() const;
public:
    bool isChecked();

signals:
    void clicked(bool checked = false);

private:
    friend class QSlideButtonPrivate;
    QPointer<QSlideButtonPrivate> pimpl;
};
#endif // QSLIDEBUTTON_H
