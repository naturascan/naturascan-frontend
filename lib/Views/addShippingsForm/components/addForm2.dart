import 'package:flutter/material.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/otherUserSelectWidget.dart';
import '../../../Utils/constants.dart';
import '../../../Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/photographListWidget.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/responsableList.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/skipperListWidget.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/userListWidget.dart';
import '../../../Utils/Widgets/customInputField.dart';
import '../../../models/local/userModel.dart';

class AddForm2 extends StatefulWidget {
  final TextEditingController nbController;
  final List<UserModel> selectedUser;
  final List<UserModel> responsable;
  final List<UserModel> skipper;
  final List<UserModel> photograph;
  final List<UserModel> otherUser;
  final bool edit;
  final String title;
  const AddForm2(
      {super.key,
      required this.nbController,
      required this.selectedUser,
      required this.responsable,
      required this.skipper,
      required this.photograph,
      required this.otherUser,
      required this.title,
      required this.edit});

  @override
  State<AddForm2> createState() => _AddForm2State();
}

class _AddForm2State extends State<AddForm2> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
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
                        Border.all(color: Constants.colorPrimary, width: .5)),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    if (!widget.edit)
                      const CustomText(
                        text: "2/3",
                      ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 10),
                      child: Align(
                          alignment: Alignment.center,
                          child: CustomText(
                            textAlign: TextAlign.center,
                            text: widget.title,
                            fontSize: 22,
                          )),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 50,
          ),
          FutureBuilder(
              future: refresh(),
              builder: (context, snap) {
                return Column(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(left: 22),
                          child: CustomText(
                            text: "Nombre de participants",
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        CustomInputField(
                          keyboardType: TextInputType.number,
                          controller: widget.nbController,
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    UserListWidget(selectedUser: widget.selectedUser),
                    const SizedBox(
                      height: 10,
                    ),
                    ResponsableListWidget(
                      selectedResponsable: widget.responsable,
                      canShow: widget.selectedUser.isNotEmpty,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SkipperListWidget(
                      selectedSkipper: widget.skipper,
                      canShow: widget.selectedUser.isNotEmpty,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    photographListWidget(
                      selectedPhotograph: widget.photograph,
                      canShow: widget.selectedUser.isNotEmpty,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    OtherUserListWidget(
                      selectedOtherUser: widget.otherUser,
                      canShow: widget.selectedUser.isNotEmpty,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                  ],
                );
              }),
        ],
      ),
    );
  }

  Future<void> refresh() async {
    setState(() {});
  }
}
