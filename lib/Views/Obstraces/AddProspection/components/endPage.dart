import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/position.dart';
import 'package:naturascan/Utils/timebox.dart';
import 'package:naturascan/main.dart';

class EndPageObstrace extends StatefulWidget {
  final int level;
  final bool edit;
  const EndPageObstrace({super.key, required this.level, required this.edit});

  @override
  State<EndPageObstrace> createState() => _EndPageObstraceState();
}

class _EndPageObstraceState extends State<EndPageObstrace> {
bool loading = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, (){
      if(widget.edit){
        setState(() {
          loading = false;
        });
      }else{
         getPosition();
      }
      
    if(widget.level == 3){
    sortieController.heureFinController.text = DateTime.now().millisecondsSinceEpoch.toString();
    }
    } );
    super.initState();
  }

  void getPosition() async{
  try{
      await Geolocation().determinePosition().then((value) {
      setState(() {
        sortieController.endLongDegDecController.text =
            value.longitude.toString();
        sortieController.endLongDegMinSecController.text =
            Utils().convertToDms(value.longitude, false);
        sortieController.endLatDegDecController.text =
            value.latitude.toString();
        sortieController.endLatDeglMinSecController.text =
            Utils().convertToDms(value.latitude, true);
            loading = false;
      });
    });
  } catch(e){
   Utils.showToast("Nous n'avons pas pu récupérer votre position actuelle.");
      loading = false;
  }
}

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: sortieController,
        builder: (sortieControl) {
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 30,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border:
                          Border.all(color: Colors.grey.shade400, width: .5)),
                  child:  Column(
                    children: [
                     
                      Padding(
                        padding: const EdgeInsets.only(left: 20, top: 20),
                        child: Align(
                            alignment: Alignment.center,
                            child: CustomText(
                              textAlign: TextAlign.center,
                              text:
                              widget.level == 3  ?
                                  "Finalisation de la prospection":
                                  "Paramètre de fin de la prospection",
                              fontSize: 22,
                            )),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),     
                 Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                   timeBox(
                        context,
                        title: "Heure de fin",
                        controller: sortieController.heureFinController,
                        onTap: () {
                          showTimePicker(context: context, initialTime: TimeOfDay.now())
                              .then((value) {
                            if (value != null) {
                                  DateTime dt = DateTime.now();
                                    DateTime dateTime = DateTime(dt.year, dt.month, dt.day, value.hour, value.minute);
                                    sortieController.heureFinController.text =  "${dateTime.millisecondsSinceEpoch}";
                              setState(() {});
                            }
                          });
                        },
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                       Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const CustomText(
                            text: "Ma position actuelle",
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                          InkWell(
                            onTap: () {
                           setState(() {
                             loading = true;
                           });
                           getPosition();
                            },
                            child: Card(
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10)),
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 10, right: 10, top: 3, bottom: 3),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Constants.colorPrimary,
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10)),
                                child: const Row(
                                  children: [
                                    Icon(
                                      Icons.place,
                                      color: Constants.colorPrimary,
                                      size: 13,
                                    ),
                                    Text(
                                      " Actualiser",
                                      style: TextStyle(
                                          color: Constants.colorPrimary),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                     loading ?
                  const Padding(
                    padding: EdgeInsets.all(50.0),
                    child: Center(
                        child: SizedBox(width: 20, height: 20,
                        child: CircularProgressIndicator(strokeWidth: 1,),),
                      ),
                  ):
                  Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Lat (degré dec)",
                                ),
                              ),
                              CustomInputField(
                                controller: sortieController
                                    .endLatDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Lat (degré min sec)",
                                ),
                              ),
                              CustomInputField(
                                controller: sortieController
                                    .endLatDeglMinSecController,
                                hint: "Exp: 48° 51' 41\" N",
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Long (degré dec)",
                                ),
                              ),
                              CustomInputField(
                                controller: sortieController
                                    .endLongDegDecController,
                                hint: "Exp: 48.8566",
                              ),
                              const Padding(
                                padding: EdgeInsets.only(left: 22, top: 10),
                                child: CustomText(
                                  text: "Long (degré min sec)",
                                ),
                              ),
                              CustomInputField(
                                controller: sortieController
                                    .endLongDegMinSecController,
                                hint: "Exp: 48° 51' 41\" N",
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              
                 const SizedBox(
                      height: 50,
                    ),

                  ],
                ),
              ],
            ),
          );
        });
  }
}
