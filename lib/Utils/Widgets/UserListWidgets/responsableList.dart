import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:naturascan/Utils/Widgets/customInputField.dart';
import 'package:naturascan/Utils/Widgets/customText.dart';
import 'package:naturascan/Utils/constants.dart';
import 'package:naturascan/Utils/Widgets/UserListWidgets/selectAndAddUserWidget.dart';
import 'package:naturascan/Views/addUserScreen.dart';
import 'package:naturascan/models/local/userModel.dart';


class ResponsableListWidget extends StatefulWidget {
  final List<UserModel>? selectedResponsable;
  final bool canShow;
  const ResponsableListWidget(
      {super.key, this.selectedResponsable, required this.canShow});

  @override
  State<ResponsableListWidget> createState() => _ResponsableListWidgetState();
}

class _ResponsableListWidgetState extends State<ResponsableListWidget> {
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
            text: "Responsables",
            fontSize: 22,
            fontWeight: FontWeight.w700,
          ),
        ),
        CustomInputField(
          readOnly: true,
          label: "Ajouter un responsable",
          suffix: IconButton(
              onPressed: () {
                 Get.to(() => const AddUserScreen(type: 1));
              },
              icon: const Icon(
                Icons.add_circle_outline_rounded,
                color: Constants.colorPrimary,
              )),
          onTap: () {
            Get.bottomSheet(SelectAndAddUserWidget(
              selectedUser: widget.selectedResponsable, type: 1,
            )).then((value) => setState(() {
                  widget.selectedResponsable!.toSet().toList();
                }));
          },
        ),
        if (widget.selectedResponsable!.isNotEmpty)
          Container(
            padding: const EdgeInsets.only(left: 12, right: 12),
            child: GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: widget.selectedResponsable!.length,
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
                  "${widget.selectedResponsable![index].name!} ${widget.selectedResponsable![index].firstname!}")),
        ),
        Positioned(
            top: 1,
            right: 1,
            child: InkWell(
              onTap: () {
                widget.selectedResponsable!.removeAt(index);
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
