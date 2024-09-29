import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/base_view.dart';
import 'package:pliiz_web/constants/exports.dart';
import 'package:pliiz_web/helpers/routes.dart';
import 'package:pliiz_web/provider/navbar_screen_provider.dart';
import 'package:pliiz_web/screens/nav_bar/sub_page/menu_create.dart';
import 'package:pliiz_web/screens/nav_bar/sub_page/assigned_page.dart';
import 'package:pliiz_web/screens/nav_bar/sub_page/employee_dashboard_screen.dart';
import 'package:pliiz_web/screens/nav_bar/sub_page/main_screen.dart';
import 'package:pliiz_web/screens/nav_bar/sub_page/waiting_list.dart';

import '../../widgets/nav_bar_item.dart';

class NavBarScreen extends StatefulWidget {
  const NavBarScreen({Key? key}) : super(key: key);

  @override
  State<NavBarScreen> createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  bool first = true;
  bool second = false;
  int activePage = 0;
  List<Widget> screens = [
    const MainScreen(),
    const EmployeeDashboardScreen(),
    const WaitingList(),
    const AssignedPage(),
    const MenuCreatePage(),
  ];

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      var data = value.data() as Map<String, dynamic>;
      if (!data['isActive']) {
        Get.offAllNamed(keys.loginPage);
      }
      print(' this is data ${data['isActive']}');
    });
    return BaseView<NavBarScreenProvider>(
      builder: (context, provider, _) => Scaffold(
        backgroundColor: AppColors.backgroundColor,

        /// body
        body: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              flex: 1,
              child: Container(
                height: height(context),
                width: width(context),
                decoration: const BoxDecoration(
                  color: AppColors.whiteColor,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(height: height(context) * 0.016),
                    Center(
                      child: SvgPicture.asset(AppIcons.appIcon,
                          height: height(context) * 0.08),
                    ),
                    SizedBox(height: height(context) * 0.05),
                    NavBarItem(
                      isActive: activePage == 0,
                      activeIconPath: AppIcons.qrActiveIcon,
                      iconPath: AppIcons.qrUnActiveIcon,
                      activeIconColor: AppColors.whiteColor,
                      text: 'My QRs',
                      onTap: () {
                        setState(() {
                          activePage = 0;
                        });
                      },
                    ),
                    SizedBox(height: height(context) * 0.02),
                    NavBarItem(
                      isActive: activePage == 1,
                      activeIconPath: AppIcons.employeeIcon,
                      iconPath: AppIcons.employeeIcon,
                      activeIconColor: AppColors.whiteColor,
                      text: 'Employees',
                      onTap: () {
                        setState(() {
                          activePage = 1;
                        });
                      },
                    ),
                    SizedBox(height: height(context) * 0.02),
                    NavBarItem(
                      isActive: activePage == 2,
                      activeIconPath: AppIcons.waiting,
                      iconPath: AppIcons.waiting,
                      activeIconColor: AppColors.whiteColor,
                      text: 'Waiting List',
                      onTap: () {
                        setState(() {
                          activePage = 2;
                        });
                      },
                    ),
                    SizedBox(height: height(context) * 0.02),
                    NavBarItem(
                      isActive: activePage == 3,
                      activeIconPath: AppIcons.assigned,
                      iconPath: AppIcons.assigned,
                      activeIconColor: AppColors.whiteColor,
                      text: 'Assigned',
                      onTap: () {
                        setState(() {
                          activePage = 3;
                        });
                      },
                    ),
                    SizedBox(height: height(context) * 0.02),
                    NavBarItem(
                      isActive: activePage == 4,
                      activeIconPath: AppIcons.assigned,
                      iconPath: AppIcons.assigned,
                      activeIconColor: AppColors.whiteColor,
                      text: 'Create Choices',
                      onTap: () {
                        setState(() {
                          activePage = 4;
                        });
                      },
                    ),
                    const Expanded(child: SizedBox()),
                    Center(
                      child: TextButton(
                        onPressed: () async {
                          await FirebaseAuth.instance.signOut();
                          Get.offAllNamed(RoutKeys().loginPage);
                        },
                        child: Text(
                          'Logout',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.w700,
                            color: AppColors.secondaryColor,
                            fontSize: height(context) * 0.022,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: height(context) * 0.04),
                  ],
                ),
              ),
            ),
            Expanded(
              flex: 4,
              child: screens[activePage],
            ),
          ],
        ),
      ),
    );
  }
}
