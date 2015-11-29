import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.ListItems 1.0 as ListItem
import QtQuick.LocalStorage 2.0

import "js/scripts.js" as Scripts

MainView {
    // objectName for functional testing purposes (autopilot-qt5)
    objectName: "mainView"

    // Note! applicationName needs to match the "name" field of the click manifest
    applicationName: "currencyconverter.turan-mahmudov-l"

    // Rotation
    automaticOrientation: true

    width: units.gu(50)
    height: units.gu(75)

    property var currencies : ["USD","EUR","AZN","BTC","TRY","GEL","GBP","INR","AUD","CAD","SGD"]

    PageStack {
        id: pagestack

        Component.onCompleted: {
            Scripts.allcurrencies();
            pagestack.push(main);

            Scripts.initializeUser();

            var from = Scripts.getKey("from");
            var to = Scripts.getKey("to");

            fromSelector.selectedIndex = from;
            toSelector.selectedIndex = to;
        }
    }

    Page {
        id: main
        title: i18n.tr("Currency Converter")

        Column {
            width: parent.width
            spacing: units.gu(1)

            Row {
                width: parent.width
                spacing: units.gu(1)

                ListModel {
                    id: currenciesModel

                    ListElement { name: "Dollar"; symbol: "USD"; }
                    ListElement { name: "Euro"; symbol: "EUR"; }
                    ListElement { name: "Azerbaijan Manat"; symbol: "AZN"; }
                    ListElement { name: "Bitcon"; symbol: "BTC"; }
                    ListElement { name: "Turkish Lira"; symbol: "TRY"; }
                    ListElement { name: "Georgian Lari"; symbol: "GEL"; }
                    ListElement { name: "British Pound"; symbol: "GBP"; }
                    ListElement { name: "Indian Rupee"; symbol: "INR"; }
                    ListElement { name: "Australian Dollar"; symbol: "AUD"; }
                    ListElement { name: "Canadian Dollar"; symbol: "CAD"; }
                    ListElement { name: "Singapore Dollar"; symbol: "SGD"; }
                }

                ListItem.ItemSelector {
                    id: fromSelector
                    expanded: false
                    width: parent.width/2 - units.gu(3)
                    containerHeight: units.gu(40)
                    model: currenciesModel
                    delegate: OptionSelectorDelegate { text: name + " - " + symbol; }
                }

                Icon {
                    name: "retweet"
                    width: units.gu(3)
                    height: width
                    y: units.gu(1)
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            var fr = fromSelector.selectedIndex;
                            var ds = toSelector.selectedIndex;

                            fromSelector.selectedIndex = ds;
                            toSelector.selectedIndex = fr;
                        }
                    }
                }

                ListItem.ItemSelector {
                    id: toSelector
                    expanded: false
                    width: parent.width/2 - units.gu(3)
                    containerHeight: units.gu(40)
                    model: currenciesModel
                    delegate: OptionSelectorDelegate { text: name + " - " + symbol; }
                }
            }

            Item {
                width: parent.width
                height: amount.height

                TextField {
                    id: amount
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: units.gu(30)
                    inputMethodHints: Qt.ImhFormattedNumbersOnly
                }
            }

            Button {
                id: convert
                anchors.horizontalCenter: parent.horizontalCenter
                width: units.gu(30)
                color: UbuntuColors.blue
                text: i18n.tr("Convert")
                onClicked: {
                    Scripts.convert(fromSelector.selectedIndex, toSelector.selectedIndex, amount.text);
                }
            }

            Item {
                width: parent.width
                height: camount.height

                Text {
                    id: camount
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.pointSize: units.gu(4)
                }
            }

        }
    }
}

