import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../controller/bluetooth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:iconly/iconly.dart';
import '../controller/bluetooth_controller.dart';
import '../utils/color_constants.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'dart:math';

class TrilaterationView extends StatelessWidget {
  const TrilaterationView({Key? key}) : super(key: key);

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
                StreamBuilder<List<ScanResult>>(
                  stream: controller.scanResults,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final selectedDevices = controller.selectedDeviceIdxList.map((index) => snapshot.data![index]).toList();
                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: selectedDevices.length,
                        itemBuilder: (context, index) {
                          final data = selectedDevices.elementAt(index);
                          final deviceName = data.device.name.isNotEmpty ? data.device.name : data.advertisementData.localName;
                          final title = 'Device ${index + 1}${deviceName.isNotEmpty ? ': $deviceName' : ''}';
                          double alpha = controller.selectedRSSI[index].toDouble();
                          String rssi = controller.selectedRSSI[index].toString();
                          num distance = logDistancePathLoss(rssi, alpha);
                          controller.selectedDistanceList[index] = distance;
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
                            trailing: Text('${distance.toStringAsPrecision(3)} m',
                                style: const TextStyle(color: Colors.black)),
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SpinBox(
                                        min: -100,
                                        max: -30,
                                        value: controller.selectedRSSI[index].toDouble(),
                                        decimals: 0,
                                        step: 1,
                                        onChanged: (value) => controller
                                            .selectedRSSI[index] = value.toInt(),
                                        decoration: const InputDecoration(labelText: 'RSSI at 1m'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SpinBox(
                                        min: 0.0,
                                        max: 20.0,
                                        value: controller.selectedCenterXList[index].toDouble(),
                                        decimals: 1,
                                        step: 0.1,
                                        onChanged: (value) =>
                                        controller.selectedCenterXList[index] = value,
                                        decoration: const InputDecoration(labelText: 'Center X [m]'),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: SpinBox(
                                        min: 0.0,
                                        max: 20.0,
                                        value: controller.selectedCenterYList[index].toDouble(),
                                        decimals: 1,
                                        step: 0.1,
                                        onChanged: (value) =>
                                        controller.selectedCenterYList[index] = value,
                                        decoration: const InputDecoration(labelText: 'Center Y [m]'),
                                      ),
                                    ),
                                  ],),
                              )
                            ],
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text("No devices selected"));
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
num logDistancePathLoss(String rssi, double alpha) =>
    pow(10.0, ((alpha - double.parse(rssi)) / (10 * 2)));