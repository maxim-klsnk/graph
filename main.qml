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
		id: graphCanvas
		width: parent.width
		anchors.top: parent.top
		anchors.bottom: parent.verticalCenter

		Canvas
		{
			anchors.fill: parent
			onPaint:
			{
				// some painting
			}
		}

		Repeater
		{
			id: graphPoints
			anchors.fill: parent
			model: 5

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
				text: "First algorithm"
				height: parent.height / 4
			}

			Button
			{
				width: parent.width
				text: "Second algorithm"
				height: parent.height / 4
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
