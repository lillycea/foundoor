import 'package:flutter/material.dart';
class SideMenu extends StatefulWidget{
  const SideMenu({super.key});

  @override
  State<SideMenu> createState()=> _SideMenuState();
}

class _SideMenuState extends State<SideMenu>{
  @override
  Widget build(BuildContext){
    return Scaffold(
      body: Container(
        width: 288,
        height: double.infinity,
        color: const Color(0XFF17203A),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 32, bottom: 16),
              child:
              Text("Browse".toUpperCase(), style: Theme.of(context).textTheme.titleMedium!.copyWith(color: Colors.white70),),),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Divider(
                  color: Colors.white24,
                  height: 1
                ),
              ),
              ListTile(
                onTap: () {},
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(Icons.bluetooth_outlined),
                ),
                title: Text("Explore", style: TextStyle(color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Divider(
                    color: Colors.white24,
                    height: 1
                ),
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(Icons.cloud_done_outlined),
                ),
                title: Text("Upload planimetry", style: TextStyle(color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Divider(
                    color: Colors.white24,
                    height: 1
                ),
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: Icon(Icons.map_outlined),
                ),
                title: Text("Map", style: TextStyle(color: Colors.white),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 24),
                child: Divider(
                    color: Colors.white24,
                    height: 1
                ),
              ),
              ListTile(
                leading: SizedBox(
                  height: 34,
                  width: 34,
                  child: ImageIcon(AssetImage('assets/icon/chat.png')),
                ),
                title: Text("Help", style: TextStyle(color: Colors.white),),
              ),
            ],
          ),
        ),
      ),
    );
  }
}