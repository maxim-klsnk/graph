import QtQuick 2.9
import QtQuick.Controls 2.0

ApplicationWindow
{
	visible: true
	width: 640
	height: 480
	title: qsTr("Main window")

	Item
	{
		width: parent.width
		anchors.top: parent.top
		anchors.bottom: parent.verticalCenter

		Canvas
		{
			id: graphCanvas
			anchors.fill: parent

			property bool redLineVisible: false
			property bool yellowLineVisible: false
			onPaint:
			{
				var ctx = getContext('2d');
				ctx.save();

				ctx.clearRect(0, 0, parent.width, parent.height);

				if (yellowLineVisible)
				{
					ctx.lineWidth = 1
					ctx.fillStyle = "yellow"
					ctx.strokeStyle = "yellow"
					for (var pointX = 0; pointX < parent.width; ++pointX)
					{
						var pointY = interpolator.polynom3xXtoY(pointX);
						ctx.beginPath();
						ctx.arc(pointX, pointY, 10, 0, Math.PI * 2, true);
						ctx.fill();
						ctx.stroke();
					}
				}

				if (redLineVisible)
				{
					ctx.lineWidth = 1
					ctx.fillStyle = "red"
					ctx.strokeStyle = "red"
					for (pointX = 0; pointX < parent.width; ++pointX)
					{
						pointY = interpolator.lagrangeInterpolationXtoY(pointX);
						ctx.beginPath();
						ctx.arc(pointX, pointY, 10, 0, Math.PI * 2, true);
						ctx.fill();
						ctx.stroke();
					}
				}

				ctx.restore();
			}
		}

		Repeater
		{
			id: graphPoints
			anchors.fill: parent
			model: 5

			function setUpPoints ()
			{
				for (var pointIndex = 0; pointIndex < model; pointIndex++)
				{
					var item = itemAt(pointIndex);
					var curPoint = Qt.point(
						item.x + item.width / 2,
						item.y + item.height / 2);

					interpolator.setPointAt(pointIndex, curPoint);
				}
			}

			Rectangle
			{
				x: 25 + (parent.width / 6) * (index + 1)
				y: parent.height / 2 - (width / 2)
				width: 25
				height: 25
				color: "blueviolet"

				MouseArea
				{
					anchors.centerIn: parent
					width: parent.width * 3
					height: parent.height * 3
					drag.target: parent
					drag.minimumX: graphCanvas.x
					drag.minimumY: graphCanvas.y
					drag.maximumX: graphCanvas.x + graphCanvas.width - parent.width
					drag.maximumY: graphCanvas.y + graphCanvas.height - parent.height
				}
			}
		}

		Rectangle
		{
			id: graphFirstPoint
			width: 13
			height: 25
			x: parent.x
			anchors.verticalCenter: parent.verticalCenter
			color: "blue"
		}

		Rectangle
		{
			id: graphLastPoint
			width: 13
			height: 25
			x: parent.x + parent.width - width
			anchors.verticalCenter: parent.verticalCenter
			color: "blue"
		}
	}

	Rectangle
	{
		width: parent.width
		anchors.top: parent.verticalCenter
		anchors.bottom: parent.bottom
		color: "gray"
		Column
		{
			spacing: 10
			anchors.fill: parent

			Button
			{
				width: parent.width
				text: "Polynom3x Approximation"
				height: parent.height / 4

				onClicked:
				{
					graphPoints.setUpPoints();
					interpolator.polynom3xPrepare();
					graphCanvas.yellowLineVisible = true;
					graphCanvas.requestPaint();
				}
			}

			Button
			{
				width: parent.width
				text: "Lagrange interpolation"
				height: parent.height / 4

				onClicked:
				{
					graphPoints.setUpPoints();
					graphCanvas.redLineVisible = true;
					graphCanvas.requestPaint();
				}
			}

			Button
			{
				width: parent.width
				text: "Exit"
				height: parent.height / 4
				onClicked:
				{
					Qt.exit(0)
				}
			}
		}
	}
}
