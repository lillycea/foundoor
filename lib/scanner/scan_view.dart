import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import '../controller/bluetooth_controller.dart';
import '../utils/color_constants.dart';
import 'package:toggle_switch/toggle_switch.dart';

class ScanView extends StatelessWidget {
  const ScanView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: BluetoothController(),
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () => controller.scanDevices(),
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: ColorConstants.appColor,
                      minimumSize: const Size(350, 55),
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(5))),
                    ),
                    child: Text("Run to scan"),
                  ),
                ),
                const SizedBox(height: 20),
                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.length,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          final data = snapshot.data![index];
                          final deviceName = data.device.name.isNotEmpty ? data.device.name : data.advertisementData.localName;
                          final title = 'Device ${index + 1}${deviceName.isNotEmpty ? ': $deviceName' : ''}';
                          final uuidList = data.advertisementData.serviceUuids;
                          return ExpansionTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                Icons.bluetooth_searching,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(title),
                            subtitle: Text("MAC: " + data.device.id.id),
                            trailing: Text(data.rssi.toString() + " dBm"),
                            children: <Widget>[
                             ListTile(
                                title: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text("UUID: " + (uuidList.isNotEmpty ? uuidList.first : "Not available") + "\ntxPower level: " + data.advertisementData.txPowerLevel.toString(),style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w300),),
                                      const Padding(padding: EdgeInsets.all(2)),
                                      Row(
                                        children: [
                                          const Spacer(),
                                          ToggleSwitch(
                                           minWidth: 100.0,
                                           cornerRadius: 20.0,
                                           activeBgColors: [[ColorConstants.appColor!], [ColorConstants.gray100!]],
                                           activeFgColor: Colors.white,
                                           inactiveBgColor: ColorConstants.gray200,
                                           inactiveFgColor: Colors.white,
                                           initialLabelIndex: 1,
                                           icons: [Icons.done, Icons.bluetooth_disabled_outlined],
                                           totalSwitches: 2,
                                           labels: ['Active', 'Inactive'],
                                           radiusStyle: true,
                                           onToggle: (int? index) {
                                              if (index != null) {
                                                controller.updateFlagList(flag: true, index: index);
                                                }
                                            },),
                                        ],
                                      ),
                                    ],),
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No devices found"));
                    }
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
