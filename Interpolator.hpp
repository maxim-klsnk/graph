#ifndef INTERPOLATOR_HPP
#define INTERPOLATOR_HPP

#include <QList>
#include <QPoint>
#include <functional>

class Interpolator : public QObject
{
Q_OBJECT
public:
	Q_INVOKABLE int pointsCount () const;
	Q_INVOKABLE void setPointsCount (int count);

	Q_INVOKABLE QPoint pointAt (int pos) const;
	Q_INVOKABLE void setPointAt (int pos, QPoint value);

	// Q_INVOKABLE func lagrangeInterpolation () const;
	Q_INVOKABLE void polynom3xPrepare ();
	Q_INVOKABLE int polynom3xXtoY (int x) const;

private:
	QList<QPoint> _points;
	QList<int> _polynom3xCoef;
};

#endif // INTERPOLATOR_HPP
