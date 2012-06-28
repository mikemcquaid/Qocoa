#ifndef QSEARCHFIELD_H
#define QSEARCHFIELD_H

#include <QWidget>
#include <QPointer>

class QSearchFieldPrivate;
class QSearchField : public QWidget
{
    Q_OBJECT
public:
    explicit QSearchField(QWidget *parent);

    QString text() const;
    QString placeholderText() const;

public slots:
    void setText(const QString &text);
    void setPlaceholderText(const QString &text);
    void clear();
    void selectAll();

signals:
    void textChanged(const QString &text);
    void editingFinished();
    void returnPressed();

protected:
    void resizeEvent(QResizeEvent*);

private:
    friend class QSearchFieldPrivate;
    QPointer <QSearchFieldPrivate> pimpl;

    Q_PROPERTY(QString placeholderText READ placeholderText WRITE setPlaceholderText);
};

#endif // QSEARCHFIELD_H
