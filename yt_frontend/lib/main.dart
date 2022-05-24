import 'dart:io';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MaterialApp(
    home: MainPage(),
    debugShowCheckedModeBanner: false,
  ));
}

class MainPage extends StatefulWidget {
  MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  // var target_url;
  String status = "NONE";
  TextEditingController target_url = new TextEditingController();
  void convert_video(get_url) async {
    setState(() {
      status = "Please wait . . . ";
    });
    print(get_url);
    var result =
        await Dio().get('http://192.168.43.77:1111/video?url=' + get_url);
    var filename = (result.toString().split('/'));
    var response = await Dio().get(
      result.toString(),

      //Received data with List<int>
      options:
          Options(responseType: ResponseType.bytes, followRedirects: false),
    );
    File file = File('/storage/emulated/0/Music/' + filename.last);
    var raf = file.openSync(mode: FileMode.write);
    // response.data is List<int> type
    raf.writeFromSync(response.data);
    await raf.close();
    setState(() {
      status = "Done !";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: SizedBox(
                height: MediaQuery.of(context).size.height,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                        // top: 60,
                        child: TextField(
                      controller: target_url,
                      obscureText: false,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'YouTube link',
                      ),
                    )),
                    Positioned(
                        top: 140,
                        child: RaisedButton(
                          child: Text("Convert"),
                          onPressed: () {
                            setState(() {
                              try {
                                convert_video(target_url.text);
                              } catch (e) {}
                            });
                          },
                        )),
                    Positioned(top: 185, child: Text(status)),
                  ],
                ))));
  }
}
