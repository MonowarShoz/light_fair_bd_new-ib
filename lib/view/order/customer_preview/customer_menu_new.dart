import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/util/dimensions.dart';
import 'package:light_fair_bd_new/util/show_custom_snakbar.dart';
import 'package:light_fair_bd_new/view/order/order_process/new_order_screen.dart';
import 'package:provider/provider.dart';
import '../../../util/color_resources.dart';
import '../../../util/images.dart';
import '../../../util/theme/custom_themes.dart';
import 'assign_user_dialog.dart';
import 'customer_add_preview.dart';

class CustNewMenuScreen extends StatefulWidget {
  const CustNewMenuScreen({Key? key}) : super(key: key);

  @override
  State<CustNewMenuScreen> createState() => _CustNewMenuScreenState();
}

class _CustNewMenuScreenState extends State<CustNewMenuScreen> {
  final _searchController = TextEditingController();
  final custNameController = TextEditingController();
  final custTypeController = TextEditingController();
  final custdescController = TextEditingController();
  final FocusNode _phoneFocus = FocusNode();
  final FocusNode _TypedesFocus = FocusNode();
  final _formKey = GlobalKey<FormState>();
  int? _index;
  String? mainHead;
  bool _isCatExpanded = false;
  bool _isdrpval = false;
  String? selectedItemCode;
  String? selectedMainHead;
  bool _isSelected = false;
  List toggled = [];
  bool isLoading = false;
  String? selectedItemName;

  @override
  void initState() {
    super.initState();
    getlist();
  }

  getlist() async {
    await Provider.of<UserConfigurationProvider>(context, listen: false)
        .customerProcess();
  }

  void _updateSelected(int index) => setState(() => _index = index);

  String sum(int item, String? selectedItemCode) {
    return (int.parse(selectedItemCode!) + item + 1).toString();
  }

  @override
  Widget build(BuildContext context) {
    Provider.of<UserConfigurationProvider>(context, listen: false)
        .clearAssignedUser();
    return Consumer2<UserConfigurationProvider, MobilFeedProvider>(
        builder: (context, ap, mobilFeedProvider, child) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          titleSpacing: 0,
          title: Text(
            'ADD CUSTOMER DATA',
            style: robotoBold.copyWith(fontSize: 16, color: Colors.black),
          ),
          iconTheme: const IconThemeData(color: Colors.black),
          leading: CupertinoNavigationBarBackButton(
            onPressed: () => Navigator.pop(context),
            color: Colors.black,
          ),
          actions: [
            IconButton(
              onPressed: () async {
                await Provider.of<UserConfigurationProvider>(context,
                        listen: false)
                    .initializeCustomerList();
                // ignore: use_build_context_synchronously
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CustomerListScreen(),
                    ));
              },
              icon: const Icon(
                FontAwesomeIcons.users,
                size: 20,
              ),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const NewOrderScreen(),
                    ));
              },
              icon: Image.asset(Images.orderHistory),
            ),
          ],
        ),
        body: SafeArea(
          child: Container(
            height: Dimensions.fullHeight(context),
            color: Colors.white,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Column(
                    children: [
                      ap.custProcessLoading
                          ? const CircularProgressIndicator(
                              // backgroundColor: Colors.green,
                              // valueColor: AlwaysStoppedAnimation(Colors.green),
                              )
                          : Padding(
                              padding: const EdgeInsets.only(
                                  top: 8, left: 3, right: 3, bottom: 2),
                              child: Material(
                                //   color: Color.fromARGB(255, 195, 240, 212),
                                color: Colors.grey.shade300,
                                //borderRadius:BorderRadius.circular(4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  side: const BorderSide(
                                    color: Colors.black26,
                                  ),
                                ),
                                child: Container(
                                  height: 40,
                                  width: Dimensions.fullWidth(context),
                                  margin: const EdgeInsets.all(2),

                                  // decoration: BoxDecoration(
                                  //   color: Colors.grey.shade300,
                                  //   borderRadius: BorderRadius.circular(4),
                                  //   border: Border.all(color: Colors.black26),
                                  // ),
                                  // color: Colors.grey.shade300,
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton(
                                      // border: BorderSide(color: Colors.black12, width: 1),
                                      // padding: const EdgeInsets.all(2),
                                      // dropdownButtonColor: Colors.grey[300],

                                      disabledHint: const Padding(
                                        padding: EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                Icons.store,
                                                color: Colors.grey,
                                              ),
                                            ),
                                            Text(
                                              'CUSTOMER GENERAL TRADING',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.grey,
                                                  fontSize: 15),
                                            ),
                                          ],
                                        ),

                                        // textAlign: TextAlign.center,
                                      ),

                                      hint: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Row(
                                          children: [
                                            const Padding(
                                              padding:
                                                  EdgeInsets.only(right: 8.0),
                                              child: Icon(
                                                FontAwesomeIcons.peopleRoof,
                                                size: 15,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                'Customer General Trading'
                                                    .toUpperCase(),
                                                style: poppinRegular.copyWith(
                                                    fontWeight: FontWeight.w500,
                                                    color: Colors.black,
                                                    fontSize: 15),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // textAlign: TextAlign.center,
                                      ),

                                      borderRadius: BorderRadius.circular(8),
                                      // value: ap.sectionSelect,
                                      value: selectedMainHead,
                                      // isExpanded: false,
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Colors.black,
                                      ),
                                      //alignment: Alignment.centerLeft,
                                      iconSize: 30,
                                      items: ap.custMainCategoryList.map((e) {
                                        return DropdownMenuItem<String>(
                                          value: e.sircode,
                                          onTap: () {
                                            ap.custSubCategory(e.sircode!);
                                            // setState(() {
                                            //   storeName = e.sectname;
                                            // });
                                          },
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0),
                                            child: Row(
                                              children: [
                                                const Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 8.0),
                                                  child: Icon(
                                                      Icons.people_outline),
                                                ),
                                                Text(
                                                  '${e.sirdesc}',
                                                  style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      fontSize: 14),
                                                ),
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                      onChanged: (val) {
                                        setState(() {
                                          selectedMainHead = val;
                                          //  _isdrpval = !_isdrpval;
                                        });
                                        //  ap.custcatwise(selectedMainHead!);
                                        // ap.custSubCategory(selectedMainHead!);

                                        // ap.jwtTokenModel!.hccode!.substring(0, 9) == '950200103'
                                        //     ? null
                                        //     : setState(() {
                                        //         sectionSelect = val;
                                        //         debugPrint('office $sectionSelect');
                                        //       });
                                      },
                                      icon: const Icon(
                                        Icons.arrow_circle_up,
                                        size: 26,
                                      ),
                                      // onChanged: ap.jwtTokenModel!.hccode!.substring(0, 9) == '950200103'
                                      //     ? null
                                      //     : (String? val) {
                                      //         // ap.sectionsSelect(val);
                                      //         setState(() {
                                      //           sectionSelect = val;
                                      //           debugPrint('office $sectionSelect');
                                      //         });
                                      //       },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      //  selectedMainHead != null ? Text(selectedMainHead!) : SizedBox.shrink(),
                      SizedBox(
                        width: Dimensions.fullWidth(context),
                        height: 50,
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              _isdrpval = !_isdrpval;
                            });
                          },
                          child: Card(
                            elevation: 3,
                            color: Colors.grey.shade300,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                              side: const BorderSide(
                                color: Colors.black26,
                              ),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Icon(_isdrpval
                                          ? Icons.category
                                          : Icons.category_outlined),
                                    ),
                                    Text(
                                      selectedItemName != null &&
                                              (selectedItemCode!
                                                      .substring(0, 7) ==
                                                  selectedMainHead!
                                                      .substring(0, 7))
                                          ? selectedItemName!
                                          : 'SELECT SUB CATEGORY',
                                      style: poppinRegular.copyWith(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 15),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(right: 4.0),
                                  child: Icon(_isdrpval
                                      ? Icons.arrow_circle_down
                                      : Icons.arrow_circle_up),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                      _isdrpval
                          ? ap.custProcessLoading
                              ? const CircularProgressIndicator()
                              : ap.custTempSubCategoryList.isEmpty
                                  ? const Text('Please Select Data')
                                  : Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Card(
                                        elevation: 6,
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 236, 235, 235),
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                          ),
                                          height: 200,
                                          child: ListView.builder(
                                            itemCount: ap
                                                .custTempSubCategoryList.length,
                                            itemBuilder: (context, index) {
                                              return Row(
                                                children: [
                                                  const Padding(
                                                    padding:
                                                        EdgeInsets.all(8.0),
                                                    child: Icon(Icons
                                                        .play_arrow_outlined),
                                                  ),
                                                  TextButton(
                                                    onPressed: () {
                                                      ap.custcatwise(ap
                                                          .custTempSubCategoryList[
                                                              index]
                                                          .sircode!);
                                                      setState(() {
                                                        selectedItemCode = ap
                                                            .custTempSubCategoryList[
                                                                index]
                                                            .sircode;
                                                        selectedItemName = ap
                                                            .custTempSubCategoryList[
                                                                index]
                                                            .sirdesc;
                                                        _isdrpval = false;
                                                      });
                                                    },
                                                    style: TextButton.styleFrom(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8),
                                                        minimumSize:
                                                            Size(50, 30),
                                                        //shape: RoundedRectangleBorder(side: ),
                                                        tapTargetSize:
                                                            MaterialTapTargetSize
                                                                .shrinkWrap,
                                                        alignment: Alignment
                                                            .centerLeft),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              3.0),
                                                      child: Text(
                                                        ap
                                                            .custTempSubCategoryList[
                                                                index]
                                                            .sirdesc!,
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          color: Colors.black,
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ),
                                    )
                          : const SizedBox.shrink(),
                      const Divider(
                        thickness: 2,
                      ),

                      //    selectedItemCode != null ? Text(selectedItemCode!) : SizedBox.shrink(),

                      selectedItemCode != null
                          ? Padding(
                              padding: const EdgeInsets.only(
                                  left: 8.0, right: 8, bottom: 8),
                              child: Container(
                                height: 40,
                                decoration: BoxDecoration(
                                    color: Colors.green.shade50,
                                    borderRadius: BorderRadius.circular(4),
                                    border: Border.all(
                                        color: Colors.green, width: 1)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'CUSTOMER ID :',
                                        style: poppinRegular.copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 13),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        selectedItemName != null &&
                                                (selectedItemCode!
                                                        .substring(0, 7) ==
                                                    selectedMainHead!
                                                        .substring(0, 7))
                                            ? sum(ap.cateWiseCust!.length,
                                                selectedItemCode)
                                            : '',
                                        style: robotoSlab.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),

                      SizedBox(
                        height: 49,
                        //width: Dimensions.fullWidth(context),
                        child: InkWell(
                          splashColor: const Color.fromARGB(255, 239, 239, 239),
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });
                            await Provider.of<UserConfigurationProvider>(
                                    context,
                                    listen: false)
                                .appUserListProvider(context);
                            setState(() {
                              isLoading = false;
                            });
                            // ignore: use_build_context_synchronously
                            showDialog(
                              context: context,
                              builder: (context) => const AssignUserDialog(),
                            );

                            // buildCustomerListDialog();
                          },
                          child: Card(
                            elevation: 2,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.black26),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Icon(
                                          FontAwesomeIcons.chalkboardUser,
                                          size: 19,
                                          color: Colors.black,
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          'Assigned User',
                                          // getTranslated(
                                          //     "select_customer", context),
                                          //'Select Customer',
                                          style: poppinRegular.copyWith(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  isLoading
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: SizedBox(
                                            height: 20,
                                            width: 20,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      ColorResources.getPrimary(
                                                          context)),
                                            ),
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Icon(
                                            (ap.selectedUserID == null)
                                                // (customerName == null && customerID == null)
                                                ? FontAwesomeIcons.userGear
                                                : FontAwesomeIcons.userCheck,
                                            color: Colors.black,
                                            size: 17,
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      ap.assignedUserName != null
                          ? Dismissible(
                              key: UniqueKey(),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                ap.deletefromUser();
                              },
                              background: Container(
                                color: Theme.of(context).colorScheme.error,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 20),
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 15,
                                  vertical: 4,
                                ),
                                child: const Icon(
                                  Icons.delete,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: InkWell(
                                  child: Container(
                                    height:
                                        MediaQuery.of(context).size.height / 9,
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                        color: Colors.green.shade50,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                            color: Colors.green, width: 1)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 0, left: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                'USER : ',
                                                style: poppinRegular.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    '${ap.assignedUserName}',
                                                    style:
                                                        poppinRegular.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 2, left: 8),
                                          child: Row(
                                            children: [
                                              Text(
                                                'Description : ',
                                                style: poppinRegular.copyWith(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 13,
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Text(
                                                    '${ap.userDescription}',
                                                    maxLines: 2,
                                                    style:
                                                        poppinRegular.copyWith(
                                                      color: Colors.black,
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: TextFormField(
                            controller: custNameController,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_phoneFocus),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Name/Description',
                              hintStyle: poppinRegular.copyWith(),
                              prefixIcon: const Icon(Icons.person_add),
                              focusColor: Colors.green,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 22),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xFFFC6A57))),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Name/Description';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: custdescController,
                            focusNode: _phoneFocus,
                            onEditingComplete: () => FocusScope.of(context)
                                .requestFocus(_TypedesFocus),
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Type/Bar Code/Phone',
                              hintStyle: poppinRegular.copyWith(),
                              prefixIcon: const Icon(FontAwesomeIcons.phone),
                              focusColor: Colors.green,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 22),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xFFFC6A57))),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please Enter Phone Number';
                              }
                              return null;
                            },
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: custTypeController,
                            focusNode: _TypedesFocus,
                            decoration: InputDecoration(
                              border: const OutlineInputBorder(),
                              hintText: 'Type Description(if any)',
                              hintStyle: poppinRegular.copyWith(),
                              prefixIcon: const Icon(
                                  FontAwesomeIcons.personCircleQuestion),
                              focusColor: Colors.green,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 18, horizontal: 22),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                  width: 2.0,
                                  color: Colors.green,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(4),
                                  borderSide: const BorderSide(
                                      width: 2, color: Color(0xFFFC6A57))),
                            ),
                          ),
                        ),
                        Consumer<UserConfigurationProvider>(
                            builder: (context, ap, child) {
                          return ap.isProcessLoading
                              ? const CircularProgressIndicator()
                              : Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8, right: 8, top: 16),
                                  child: SizedBox(
                                    width: Dimensions.fullWidth(context) / .2,
                                    child: CupertinoButton(
                                      onPressed: () async {
                                        // ap.addcustomer(
                                        //   name: custNameController.text,
                                        //   desc: custdescController.text,
                                        //   type: custTypeController.text,
                                        // );
                                        if (_formKey.currentState!.validate()) {
                                          if (selectedItemCode == null &&
                                              selectedMainHead == null) {
                                            showCustomSnackBar(
                                                'Please Add Necessary Data',
                                                context,
                                                isError: true);
                                          } else {
                                            selectedItemCode!.substring(0, 7) !=
                                                    selectedMainHead!
                                                        .substring(0, 7)
                                                ? showCustomSnackBar(
                                                    'Operation Failed', context)
                                                : await ap
                                                    .addCustomerDataProcess(
                                                    custName:
                                                        custNameController.text,
                                                    custID: sum(
                                                        ap.cateWiseCust!.length,
                                                        selectedItemCode),
                                                    // hcCode: ap
                                                    //     .jwtTokenModel!.hccode,
                                                    hcCode: ap.selectedUserID,

                                                    sessionID: ap.jwtTokenModel!
                                                        .sessionid!,
                                                    deviceID: ap.deviceName,
                                                    typeDes:
                                                        custdescController.text,
                                                    custType:
                                                        custTypeController.text,
                                                    context: context,
                                                    //userName: ap.jwtTokenModel!.hcname,
                                                    //subHeadCode: a.toString(),
                                                  );
                                          }
                                        }

                                        // for (var i = 0; i < ap.addedCustomer!.length; i++) {
                                        //   print('ola new cust ${ap.addedCustomer![i].sirdesc}');
                                        // }
                                        //Navigator.pop(context);
                                      },
                                      color: Colors.green,
                                      child: const Text('SUBMIT'),
                                    ),
                                  ),
                                );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }

  List<Widget> customExpanded(UserConfigurationProvider ap) {
    return <Column>[
      Column(
        children: [
          InkWell(
            onTap: () {
              ap.getSubHead();
              // setState(() {
              //   isExpand = !isExpand;
              // });
            },
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.black26),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('CUSTOMER CORPORATE'),
                      Icon(
                        ap.isExpanded
                            ? Icons.arrow_circle_down_outlined
                            : Icons.arrow_circle_up_outlined,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ap.isExpanded
              ? Container(
                  height: 40,
                  width: double.infinity,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      return Card(
                        color: Colors.white,
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Niloy Motors Dealer DEPo $index',
                              style:
                                  TextStyle(color: Colors.black, fontSize: 13),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                )
              : SizedBox.shrink(),
        ],
      ),
    ];
  }
}
