import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:get/get.dart';

import '../controller/bluetooth_controller.dart';
import '../controller/upload_controller.dart';
import '../controller/main_wrapper_controller.dart';
import '../utils/color_constants.dart';
import '../utils/grid/map_grid_view.dart';

class TrilaterationView extends StatefulWidget {
  const TrilaterationView({Key? key}) : super(key: key);

  @override
  State<TrilaterationView> createState() => TrilaterationViewState();
}

class TrilaterationViewState extends State<TrilaterationView> {
  num logDistancePathLoss(String rssi, double alpha) =>
      pow(10.0, ((alpha - double.parse(rssi)) / (10 * 2)));

  @override
  Widget build(BuildContext context) {
    final MainWrapperController mainWrapperController = Get.find();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: GetBuilder<BluetoothController>(
        init: mainWrapperController.bluetoothController,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text("Map",
                      style: Theme.of(context)
                          .textTheme
                          .headlineMedium!
                          .copyWith(
                          color: ColorConstants.appColor,
                          fontWeight: FontWeight.w900)),),
                StreamBuilder<List<SelectedDevice>>(
                  stream: controller.selectedDevicesStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      final selectedDevices = snapshot.data!;
                      double alpha = -50.0;
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          MapGridView(
                            centerXList: controller.selectedDevices
                                .map((device) => device.centerX)
                                .toList(),
                            centerYList: controller.selectedDevices
                                .map((device) => device.centerY)
                                .toList(),
                            radiusList: controller.selectedDevices
                                .map((device) => logDistancePathLoss(
                              device.rssi.toString(),
                              alpha,
                            ))
                                .toList(),
                          ),
                          ListView.separated(
                            shrinkWrap: true,
                            separatorBuilder: (_, __) => const Divider(),
                            physics: const ScrollPhysics(),
                            itemCount: selectedDevices.length,
                            itemBuilder: (context, index) {
                              final selectedDevice =
                              selectedDevices[index];
                              final data = selectedDevice.result;
                              final deviceName =
                              data.device.name.isNotEmpty
                                  ? data.device.name
                                  : data.advertisementData.localName;
                              final title =
                                  'Device ${index + 1}${deviceName.isNotEmpty ? ': $deviceName' : ''}';
                              //double alpha = selectedDevice.rssi.toDouble();
                              String rssi =
                              selectedDevice.rssi.toString();
                              num distance =
                              logDistancePathLoss(rssi, alpha);
                              selectedDevice.distance = distance;
                              return ExpansionTile(
                                leading: const CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  child: Icon(
                                    Icons.radar,
                                    color: Colors.blue,
                                  ),
                                ),
                                title: Text(title),
                                subtitle:
                                Text("MAC: ${data.device.id.id}"),
                                trailing: Text(
                                    '${distance.toStringAsPrecision(3)} m'),
                                children: <Widget>[
                                  ListTile(
                                    title: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: <Widget>[
                                        /*Padding(
                                          padding:
                                              const EdgeInsets.all(16),
                                          child: SpinBox(
                                            min: -100,
                                            max: -30,
                                            value: alpha,
                                            decimals: 0,
                                            step: 1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDevice.distance =
                                                    logDistancePathLoss(
                                                        selectedDevice
                                                            .rssi
                                                            .toString(),
                                                        value);
                                              });
                                            },
                                            decoration:
                                                const InputDecoration(
                                                    labelText:
                                                        'RSSI at 1m'),
                                          ),
                                        ),*/
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(16),
                                          child: SpinBox(
                                            min: 0.0,
                                            max: 20.0,
                                            value: selectedDevice.centerX,
                                            decimals: 1,
                                            step: 0.1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDevice.centerX =
                                                    value;
                                              });
                                            },
                                            decoration:
                                            const InputDecoration(
                                                labelText:
                                                'Center X [m]'),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                          const EdgeInsets.all(16),
                                          child: SpinBox(
                                            min: 0.0,
                                            max: 20.0,
                                            value: selectedDevice.centerY,
                                            decimals: 1,
                                            step: 0.1,
                                            onChanged: (value) {
                                              setState(() {
                                                selectedDevice.centerY =
                                                    value;
                                              });
                                            },
                                            decoration:
                                            const InputDecoration(
                                                labelText:
                                                'Center Y [m]'),
                                          ),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            },
                          ),
                        ],
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