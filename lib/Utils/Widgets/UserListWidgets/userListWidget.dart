import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/selectAndAddUserWidget.dart';
import 'package:naturascan/Views/addUserScreen.dart';
import 'package:naturascan/main.dart';
import 'package:naturascan/models/local/userModel.dart';

class UserListWidget extends StatefulWidget {
  final List<UserModel>? selectedUser;

  const UserListWidget({super.key, this.selectedUser});

  @override
  State<UserListWidget> createState() => _UserListWidgetState();
}

class _UserListWidgetState extends State<UserListWidget> {
  @override
  void initState() {
    getUserList();
    super.initState();
  }

  void getUserList() {
    userController.fetchUsers(1);
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
            text: "Observateurs",
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomInputField(
          readOnly: true,
          hint: "Ajouter un obervateur",
          suffix: IconButton(
              onPressed: () {
                Get.to(() => const AddUserScreen(type: 1));
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: Constants.colorPrimary,
              )),
          onTap: () {
            Get.bottomSheet(
                    SelectAndAddUserWidget(selectedUser: widget.selectedUser, type: 1,))
                .then((value) => setState(() {}));
          },
        ),
        if (widget.selectedUser!.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.selectedUser!.length,
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
                  "${widget.selectedUser![index].name!} ${widget.selectedUser![index].firstname!}")),
        ),
        Positioned(
            top: 1,
            right: 1,
            child: InkWell(
              onTap: () {
                widget.selectedUser!.removeAt(index);
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
