import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Utils.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/selectAndAddUserWidget.dart';
import 'package:naturascan/dummy-data/user.dart';
import 'package:naturascan/models/local/userModel.dart';

class OtherUserListWidget extends StatefulWidget {
  final List<UserModel>? selectedOtherUser;
  final bool canShow;
  const OtherUserListWidget(
      {super.key, this.selectedOtherUser, required this.canShow});

  @override
  State<OtherUserListWidget> createState() => _OtherUserListWidgetState();
}

class _OtherUserListWidgetState extends State<OtherUserListWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 22),
          child: CustomText(
            text: "Autres participants",
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomInputField(
          readOnly: true,
          label: "Ajouter un simple participant",
          suffix: const Icon(
            Icons.add_circle_outline_rounded,
            color: Constants.colorPrimary,
          ),
          onTap: () {
            Get.bottomSheet(SelectAndAddUserWidget(
              selectedUser: widget.selectedOtherUser,type: 1,
            )).then((value) => setState(() {}));
          },
        ),
        if (widget.selectedOtherUser!.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.selectedOtherUser!.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5,
                  mainAxisSpacing: 5,
                  childAspectRatio: 4,
                ),
                itemBuilder: ((context, index) => getItem(index))),
          )
      ],
    );
  }

  Widget getItem(int index) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Colors.grey.shade600, width: 0.5)),
          child: Center(
              child: Text(
                  "${widget.selectedOtherUser![index].name!} ${widget.selectedOtherUser![index].firstname!}")),
        ),
        Positioned(
            top: 1,
            right: 1,
            child: InkWell(
              onTap: () {
                widget.selectedOtherUser!.removeAt(index);
                setState(() {});
              },
              child: Icon(
                Icons.remove_circle_outline,
                color: Colors.grey.shade600,
                size: 19,
              ),
            ))
      ],
    );
  }
}
