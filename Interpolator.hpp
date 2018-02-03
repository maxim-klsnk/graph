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

	Q_INVOKABLE void setPointAt (int pos, float x, float y);

	Q_INVOKABLE float lagrangeInterpolationXtoY (float x) const;
	Q_INVOKABLE void polynom3xPrepare ();
	Q_INVOKABLE float polynom3xXtoY (float x) const;

private:
	struct Point { float x, y; };
	QList<Point> _points;
	QList<float> _polynom3xCoef;
};

#endif // INTERPOLATOR_HPP
