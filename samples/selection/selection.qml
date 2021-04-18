/*
 Copyright (c) 2008-2021, Benoit AUTHEMAN All rights reserved.

 Redistribution and use in source and binary forms, with or without
 modification, are permitted provided that the following conditions are met:
    * Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in the
      documentation and/or other materials provided with the distribution.
    * Neither the name of the author or Destrat.io nor the
      names of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission.

 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL AUTHOR BE LIABLE FOR ANY
 DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
 (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
 LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
 ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
 (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
 SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

import QtQuick                   2.8
import QtQuick.Controls          2.1
import QtQuick.Controls.Material 2.1
import QtQuick.Layouts           1.3
import QtQuick.Shapes            1.0
import Qt.labs.platform          1.0    // ColorDialog

import QuickQanava          2.0 as Qan
import "qrc:/QuickQanava"   as Qan
import "."

ApplicationWindow {
    id: window
    visible: true
    width: 1280; height: 720
    title: "Selection sample"
    Pane { anchors.fill: parent }
    ToolTip { id: toolTip; timeout: 2000 }
    function notifyUser(message) { toolTip.text=message; toolTip.open() }

    Menu {
        id: menu
        title: "Main Menu"
        property var targetNode: undefined
        property var targetGroup: undefined
        property var targetEdge: undefined
        onClosed: {
            menu.targetNode = undefined
            menu.targetGroup = undefined
            menu.targetEdge = undefined
        }
        MenuItem {
            text: "Insert Node"
            onTriggered: {
                var n = topology.insertNode()
                centerItem(n.item)
                n.label = "Node #" + topology.getNodeCount()
            }
        }
        MenuItem {
            text: {
                if (topology.selectedNodes.length > 1)
                    return "Remove All"
                else if (menu.targetGroup !== undefined)
                    return "Remove Group"
                return "Remove node"
            }
            enabled: menu.targetNode !== undefined ||
                     menu.targetGroup !== undefined ||
                     topology.selectedNodes.length > 1
            onTriggered: {
                if (topology.selectedNodes.length > 1) {
                    let nodes = []  // Copy the original selection, since removing nodes also modify selection
                    var n = 0
                    for (n = 0; n < topology.selectedNodes.length; n++)
                        nodes.push(topology.selectedNodes.at(n))
                    for (n = 0; n < nodes.length; n++) {
                        let node = nodes[n]
                        console.error('node.isGroup=' + node.isGroup())
                        topology.removeNode(nodes[n])
                    }
                } else if (menu.targetNode !== undefined)
                    topology.removeNode(menu.targetNode)
                else if (menu.targetGroup !== undefined)
                    topology.removeGroup(menu.targetGroup)
                menu.targetNode = undefined
            }
        }
        MenuItem {
            text: "Remove edge"
            enabled: menu.targetEdge !== undefined
            onTriggered: {
                if (menu.targetEdge !== undefined)
                    topology.removeEdge(menu.targetEdge)
                menu.targetEdge = undefined
            }
        }
        MenuItem {
            text: "Insert Group"
            onTriggered: {
                var n = topology.insertGroup()
                centerItem(n.item)
                n.label = "Group #" + topology.getGroupCount()
            }
        }
    } // Menu: menu

    Qan.GraphView {
        id: graphView
        anchors.fill: parent
        navigable : true
        graph: Qan.Graph {
            id: topology
            connectorEnabled: true
            objectName: "graph"
            anchors.fill: parent
            Component.onCompleted: {
                var n1 = topology.insertNode()
                n1.label = "N1"
                var n2 = topology.insertNode()
                n2.label = "N2"
                var n3 = topology.insertNode()
                n3.label = "N3"

                var g1 = topology.insertGroup()
                g1.label = "GROUP"; g1.item.x = 250; g1.item.y = 45
            }
            onGroupDoubleClicked: function(group) { window.notifyUser( "Group <b>" + group.label + "</b> double clicked" ) }
            onGroupRightClicked: function(group) { window.notifyUser( "Group <b>" + group.label + "</b> right clicked" ) }
        } // Qan.Graph: graph

        RowLayout {
            anchors.top: parent.top; anchors.topMargin: 15
            anchors.horizontalCenter: parent.horizontalCenter
            Button {
                text: "+ Group"
                padding: 1
                onClicked: {
                    var gg = topology.insertGroup()
                    if ( gg )
                        gg.label = "Group"
                }
            }
            Button {
                text: "+ Node"
                padding: 1
                onClicked: {
                    var n = topology.insertNode( )
                    if ( n )
                        n.label = "Node"
                }
            }
        }

        ColorDialog {
            id: selectionColorDialog
            title: "Selection hilight color"
            onAccepted: { topology.selectionColor = color; }
        }

        Frame {
            id: selectionSettings
            anchors.bottom: parent.bottom;   anchors.bottomMargin: 10
            anchors.right: parent.right;    anchors.rightMargin: 10
            width: 250
            height: 430
            leftPadding: 0; rightPadding: 0
            topPadding: 0;  bottomPadding: 0
            Pane { anchors.fill: parent; anchors.margins: 1; opacity: 0.7 }
            ColumnLayout {
                anchors.fill: parent; anchors.margins: 10
                ComboBox {
                    model: ["Default", "Custom"]
                    Component {
                        id: customSelectionComponent
                        CustomSelectionItem { }
                    }
                    onActivated: {
                        if (currentIndex == 0)
                            topology.selectionDelegate = null  // Use undefined to set back the default delegate
                        else if (currentIndex == 1)
                            topology.selectionDelegate = customSelectionComponent
                    }
                }

                Label {
                    Layout.margins: 3; text: "Selection:"
                    font.bold: true; horizontalAlignment: Text.AlignLeft
                }
                ListView {
                    id: selectionListView
                    Layout.fillWidth: true; Layout.fillHeight: true
                    clip: true
                    model: topology.selectedNodes
                    spacing: 4; focus: true; flickableDirection : Flickable.VerticalFlick
                    highlightFollowsCurrentItem: false
                    highlight: Rectangle {
                        x: 0
                        y: selectionListView.currentItem !== null ? selectionListView.currentItem.y : 0
                        width: selectionListView.width
                        height: selectionListView.currentItem ? selectionListView.currentItem.height : 0
                        color: Material.accent; opacity: 0.7; radius: 3
                        Behavior on y { SpringAnimation { duration: 200; spring: 2; damping: 0.1 } }
                    }
                    delegate: Item {
                        id: selectedNodeDelegate
                        width: ListView.view.width; height: 30;
                        Label { text: "Label: " + itemData.label }
                        MouseArea {
                            anchors.fill: selectedNodeDelegate
                            onClicked: { selectedNodeDelegate.ListView.view.currentIndex = index }
                        }
                    }
                }
                RowLayout {
                    Layout.margins: 2
                    Label { text:"Policy:" }
                    Item { Layout.fillWidth: true }
                    ColumnLayout {
                        CheckBox {
                            Layout.preferredHeight: 25
                            height: 15
                            autoExclusive: true
                            text: "NoSelection"
                            checked: topology.selectionPolicy === Qan.Graph.NoSelection
                            onCheckedChanged: {
                                if (checked)
                                    topology.selectionPolicy = Qan.Graph.NoSelection
                            }
                        }
                        CheckBox {
                            Layout.preferredHeight: 25
                            height: 15
                            autoExclusive: true
                            text: "SelectOnClick"
                            checked: topology.selectionPolicy === Qan.Graph.SelectOnClick
                            onCheckedChanged: {
                                if (checked)
                                    topology.selectionPolicy = Qan.Graph.SelectOnClick
                            }
                        }
                        CheckBox {
                            Layout.preferredHeight: 25
                            height: 15
                            autoExclusive: true
                            text: "SelectOnCtrlClick"
                            checked: topology.selectionPolicy === Qan.Graph.SelectOnCtrlClick
                            onCheckedChanged: {
                                if (checked)
                                    topology.selectionPolicy = Qan.Graph.SelectOnCtrlClick
                            }
                        }
                    }
                }
                RowLayout {
                    Layout.margins: 2
                    Label { text:"Color:" }
                    Item { Layout.fillWidth: true }
                    Rectangle { Layout.preferredWidth: 25; Layout.preferredHeight: 25; color: topology.selectionColor; radius: 3; border.width: 1; border.color: Qt.lighter(topology.selectionColor) }
                    Button {
                        Layout.preferredHeight: 30; Layout.preferredWidth: 30
                        text: "..."
                        onClicked: {
                            selectionColorDialog.color = topology.selectionColor
                            selectionColorDialog.open();
                        }
                    }
                }
                RowLayout {
                    Layout.margins: 2
                    Label { text:"Weight:" }
                    Slider {
                        Layout.preferredHeight: 20
                        Layout.fillWidth: true
                        from: 1.0
                        to: 15.
                        stepSize: 0.1
                        value: topology.selectionWeight
                        onValueChanged: { topology.selectionWeight = value  }
                    }
                }
                RowLayout {
                    Layout.margins: 2
                    Label { text:"Margin:" }
                    Slider {
                        Layout.preferredHeight: 20
                        Layout.fillWidth: true
                        from: 1.0
                        to: 15.
                        stepSize: 0.1
                        value: topology.selectionMargin
                        onValueChanged: { topology.selectionMargin = value  }
                    }
                }
                CheckBox {
                    text: 'Enable visual selection rect'
                    checked: graphView.selectionRectEnabled
                    onClicked: graphView.selectionRectEnabled = checked
                }
            }
        } // selectionSettings
    } // Qan.GraphView
}

