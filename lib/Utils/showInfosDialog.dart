import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ShowInfosDialog{
     void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
            contentPadding: EdgeInsets.zero,
            backgroundColor: Colors.white,
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                //height:300,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(15),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Text(
                           message,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.nunito(
                                fontSize: 17, fontWeight: FontWeight.w700),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        children: [
                          Expanded(
                            child: InkWell(
                              onTap: () {
                                Get.back();
                              },
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade300,
                                    borderRadius: const BorderRadius.only(
                                      bottomLeft: Radius.circular(10),
                                      bottomRight: Radius.circular(10)
                                    )),
                                child: Center(
                                  child: Text(
                                    "OK Compris",
                                    style: GoogleFonts.nunito(
                                        color: Colors.black,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                          ),
                       ],
                      ),
                    )
                  ],
                ),
              );
            }));
      },
    );
  }

}