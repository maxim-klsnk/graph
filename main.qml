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
		id: graph
		width: parent.width
		anchors.top: parent.top
		anchors.bottom: parent.verticalCenter

		property real tickSize: (width - 25) / 6

		function toVirtualSize (trueSize)
		{
			return trueSize / tickSize;
		}

		function toTrueSize (virtualSize)
		{
			return virtualSize * tickSize;
		}

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
				var beginX = graphFirstPoint.width / 2
				var endX = graphLastPoint.x + graphLastPoint.width / 2 + 1

				if (yellowLineVisible)
				{
					ctx.lineWidth = 10
					ctx.strokeStyle = "yellow"
					ctx.beginPath();
					for (var pointX = beginX; pointX < endX; ++pointX)
					{
						var virtualPointX = graph.toVirtualSize(pointX);
						var virtulaPointY = interpolator.polynom3xXtoY(virtualPointX);
						var pointY = graph.toTrueSize(virtulaPointY)
						if (pointX != beginX) ctx.lineTo(pointX, pointY);
						ctx.moveTo(pointX, pointY);
					}
					ctx.stroke();
				}

				if (redLineVisible)
				{
					ctx.lineWidth = 10
					ctx.strokeStyle = "red"
					ctx.beginPath();
					for (pointX = beginX; pointX < endX; ++pointX)
					{
						virtualPointX = graph.toVirtualSize(pointX);
						virtulaPointY = interpolator.lagrangeInterpolationXtoY(virtualPointX);
						pointY = graph.toTrueSize(virtulaPointY)
						if (pointX != beginX) ctx.lineTo(pointX, pointY);
						ctx.moveTo(pointX, pointY);
					}
					ctx.stroke();
				}

				ctx.restore();
			}
		}

		Repeater
		{
			id: graphPoints
			anchors.fill: parent
			model: 5

			// set points to interpolator object
			function setUpPoints ()
			{
				// touchible points
				for (var pointIndex = 1; pointIndex <= model; pointIndex++)
				{
					var item = itemAt(pointIndex - 1);
					interpolator.setPointAt(
						pointIndex,
						graph.toVirtualSize(item.x + item.width / 2),
						graph.toVirtualSize(item.y + item.height / 2));
				}

				// first and last point
				item = graphFirstPoint;
				interpolator.setPointAt(
					0,
					graph.toVirtualSize(item.x + item.width / 2),
					graph.toVirtualSize(item.y + item.height / 2));

				item = graphLastPoint;
				interpolator.setPointAt(
					6,
					graph.toVirtualSize(item.x + item.width / 2),
					graph.toVirtualSize(item.y + item.height / 2));
			}

			Rectangle
			{
				x: graph.toTrueSize(index + 1)
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
			width: 25
			height: 25
			x: graph.toTrueSize(0)
			anchors.verticalCenter: parent.verticalCenter
			color: "green"
		}

		Rectangle
		{
			id: graphLastPoint
			width: 25
			height: 25
			x: graph.toTrueSize(6)
			anchors.verticalCenter: parent.verticalCenter
			color: "green"
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
				text: "Polynom3x Approximation (yellow)"
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
				text: "Lagrange interpolation (red)"
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
