import 'package:flutter/material.dart';
import 'package:naturascan/Utils/PrefManager.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/main.dart';

class StopWatchTimerWidger extends StatefulWidget {
  const StopWatchTimerWidger({super.key});

  @override
  State<StopWatchTimerWidger> createState() => _StopWatchTimerWidgerState();
}

class _StopWatchTimerWidgerState extends State<StopWatchTimerWidger> {
  String hour = "", min = "", sec = "";
  int tim = 0;

@override
  void initState() {
    getData();
    super.initState();
  }

  void getData() async{
   tim = await PrefManager.getInt(Constants.timeO);
   formatSeconds2(tim);
   setState(() {
     
   });
          sortieController.stopWatchTimer.setPresetSecondTime(tim);
      print('timeee $tim');
  }
  
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
        stream: sortieController.stopWatchTimer.rawTime,
        initialData: tim,
        builder: (context, snap) {
          sortieController.stopWatchTimer.secondTime.listen((value) => formatSeconds2(value));
            sortieController.stopWatchTimer.secondTime
          .listen((value) async => await PrefManager.putInt(Constants.timeO, value));
          return Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    children: [
                      cont(hour),
                     const CustomText(text: "HEURES", fontSize: 14,)
                    ],
                  ),
                   const SizedBox(width: 10,),
                  Column(
                    children: [
                      cont(min),
                      const CustomText(text: "MINUTES", fontSize: 14,)
                    ],
                  ),
                 const SizedBox(width: 10,),
                  Column(
                    children: [
                      cont(sec),
                    const CustomText(text: "SECONDES", fontSize: 14,)
                    ],
                  )
               ],
              ),
                               
            ],
          );
        },
      );
  }

    Widget cont(String value){
    return Card(
      elevation: 2,
      child: Container(
        margin: const EdgeInsets.all(7),
        width: 50,
        height: 50,
              decoration: BoxDecoration(
                color: Constants.colorPrimary,
                borderRadius: BorderRadius.circular(5)
              ),
              child: Center(
                child: CustomText(text: value,
                color: Colors.white,
                fontSize: 16,
                ),
              ),
       ),
    );
  }

  void formatSeconds2(int seconds) {
  int hours = seconds ~/ 3600;
  int minutes = (seconds % 3600) ~/ 60;
  int remainingSeconds = seconds % 60;

  String formattedHours = hours.toString().padLeft(2, '0');
  String formattedMinutes = minutes.toString().padLeft(2, '0');
  String formattedSeconds = remainingSeconds.toString().padLeft(2, '0');

  hour = formattedHours;
  min = formattedMinutes;
  sec = formattedSeconds;
}


}