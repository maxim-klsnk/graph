#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "Interpolator.hpp"

int main(int argc, char *argv[])
{
#if defined(Q_OS_WIN)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

	QGuiApplication app(argc, argv);
	QQmlApplicationEngine engine;
	Interpolator interpolator;

	interpolator.setPointsCount(5);
	engine.rootContext()->setContextProperty("interpolator", &interpolator);
	engine.load(QUrl(QStringLiteral("qrc:/main.qml")));
	if (engine.rootObjects().isEmpty())
		return -1;

	return app.exec();
}
