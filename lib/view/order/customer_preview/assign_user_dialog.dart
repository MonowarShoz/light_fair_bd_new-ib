import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../provider/auth_provider.dart';
import '../../../provider/mobil_feed_provider.dart';
import '../../../util/color_resources.dart';
import '../../../util/dimensions.dart';
import '../../../util/theme/custom_themes.dart';
import '../order_process/new_order_screen.dart';

class AssignUserDialog extends StatefulWidget {
  const AssignUserDialog({
    Key? key,
  }) : super(key: key);

  @override
  State<AssignUserDialog> createState() => _CustomerDialogState();
}

class _CustomerDialogState extends State<AssignUserDialog> {
  final searchController = TextEditingController();
  bool isMode = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      alignment: Alignment.center,
      title: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'User List',
              textAlign: TextAlign.center,
              style: poppinRegular.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      actions: [
        const Divider(
          thickness: 2,
        ),
        Center(
          child: CloseButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
      ],
      insetPadding: EdgeInsets.zero,
      contentPadding: EdgeInsets.zero,

      // contentPadding: EdgeInsets.all(45.0),
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(18.0))),
      content: Builder(
        builder: (context) {
          var height = MediaQuery.of(context).size.height;
          var width = MediaQuery.of(context).size.width;
          return SizedBox(
              height: height / 2,
              width: width,
              child: Consumer2<MobilFeedProvider, UserConfigurationProvider>(
                builder: (context, mobilP, ap, child) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: TextField(
                        controller: searchController,
                        style: poppinRegular.copyWith(
                            color: Colors.black87, fontSize: 16),
                        decoration: InputDecoration(
                          hintText: 'Search User',
                          focusColor: Colors.green,
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 18, horizontal: 22),
                          suffixIcon: ap.isCustomerSearch
                              ? IconButton(
                                  onPressed: () {
                                    searchController.text = '';
                                    ap.searchAssignedUser('');
                                  },
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                )
                              : const Icon(
                                  Icons.search,
                                  color: Colors.black,
                                ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                              width: 2.0,
                              color: Colors.green,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10.0),
                            borderSide: const BorderSide(
                              width: 2,
                              color: Color(0xFFFC6A57),
                            ),
                          ),
                        ),
                        onChanged: (query) {
                          ap.searchAssignedUser(query);
                        },
                      ),
                    ),
                    !ap.isLoading
                        ? ap.appUserList.isNotEmpty
                            ? Expanded(
                                child: Scrollbar(
                                  thumbVisibility: true,
                                  thickness: 10,
                                  radius: const Radius.circular(10),
                                  child: ListView.builder(
                                    itemCount: ap.appUserList.length,
                                    padding: const EdgeInsets.all(
                                      Dimensions.PADDING_SIZE_DEFAULT,
                                    ),
                                    physics: const BouncingScrollPhysics(),
                                    itemBuilder: (context, index) => InkWell(
                                      onTap: () {
                                        ap.selectUser(
                                          name:ap.appUserList[index].signinnam!,
                                          des: ap.appUserList[index].namedsg!,
                                          hcCode: ap.appUserList[index].hccode!,
                                        );
                                        Navigator.pop(context);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(4),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: ColorResources.getHomeBg(
                                                  context),
                                              border: Border.all(
                                                  color: Colors.grey),
                                              borderRadius:
                                                  BorderRadius.circular(4)),
                                          child: ListTile(
                                            title: Text(
                                              '${ap.appUserList[index].namedsg}',
                                              style: poppinRegular.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 12,
                                                  color:
                                                      ColorResources.getTextBg(
                                                          context)),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Center(
                                child: Container(
                                  margin: const EdgeInsets.only(top: 150),
                                  child: const Text(
                                    'No Data Found or Please Check Your Internet Connection',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              )
                        : Expanded(child: EmployeeShimmer())
                  ],
                ),
              ));
        },
      ),
    );
  }
}
