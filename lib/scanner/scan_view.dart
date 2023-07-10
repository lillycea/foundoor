import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import '../controller/bluetooth_controller.dart';
import '../controller/main_wrapper_controller.dart';
import '../utils/color_constants.dart';

class ScanView extends StatelessWidget {
  const ScanView({super.key});

  final initialLabelIndex = 1;

  @override
  Widget build(BuildContext context) {
    final MainWrapperController mainWrapperController = Get.find();
    return Scaffold(
      body: GetBuilder<BluetoothController>(
        init: mainWrapperController.bluetoothController,
        builder: (controller) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                    padding: const EdgeInsets.all(20),
                    child: Text("Explore",
                        style: Theme.of(context)
                            .textTheme
                            .headlineMedium!
                            .copyWith(
                                color: ColorConstants.appColor,
                                fontWeight: FontWeight.w900))),
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
                    child: const Text("Run to scan"),
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
                          final deviceName = data.device.name.isNotEmpty
                              ? data.device.name
                              : data.advertisementData.localName;
                          final title =
                              'Device ${index + 1}${deviceName.isNotEmpty ? ': $deviceName' : ''}';
                          final uuidList = data.advertisementData.serviceUuids;
                          if (deviceName == 'Holy-IOT') {
                            controller.updateActivate(result: data);
                          }
                          return ExpansionTile(
                            leading: const CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Icon(
                                size: 22,
                                Icons.bluetooth_audio_outlined,
                                color: Colors.blue,
                              ),
                            ),
                            title: Text(title),
                            subtitle: Text("MAC: ${data.device.id.id}"),
                            trailing: Text("${data.rssi} dBm"),
                            children: <Widget>[
                              ListTile(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "UUID: ${uuidList.isNotEmpty
                                              ? uuidList.first
                                              : "Not available"}\ntxPower level: ${data.advertisementData.txPowerLevel}",
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w300),
                                    ),
                                    const Padding(padding: EdgeInsets.all(2)),
                                    const Row(
                                      children: [
                                        Spacer(),
                                      ],
                                    ),
                                  ],
                                ),
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
