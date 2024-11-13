import 'package:babstrap_settings_screen/babstrap_settings_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nafith/raqi_app/app/global/styles/colors.dart';
import 'package:nafith/raqi_app/app/global/styles/styles.dart';
import 'package:nafith/raqi_app/app_cubit/app_cubit.dart';
import 'package:nafith/raqi_app/app_cubit/app_states.dart';
import 'package:nafith/raqi_app/modules/edit_profile/edit_profile_screen.dart';
import 'package:nafith/raqi_app/modules/my_reservation/my_reservation_screen.dart';
import 'package:nafith/raqi_app/modules/quran/quran_home.dart';
import 'package:nafith/raqi_app/modules/books/books_screen.dart';
import 'package:nafith/raqi_app/modules/terms_screen/terms_screen.dart';
import 'package:nafith/raqi_app/shared/components/applocale.dart';
import 'package:nafith/raqi_app/shared/components/components.dart';
import 'package:nafith/raqi_app/shared/components/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    RaqiCubit cubit = RaqiCubit.get(context);

    return BlocConsumer<RaqiCubit, RaqiStates>(
      listener: (context, state) {
        
      },
      builder: (context, state) {
        return Scaffold(
      appBar: AppBar(
        title: Text(
          "Settings",
          style: TextStyle(color: ColorNeutrals.black),
        ),
        backgroundColor: ColorNeutrals.white,
        elevation: 0,
      ),
      backgroundColor: ColorNeutrals.grey5,
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView(
          children: [
            // User card with profile picture and edit option
            BigUserCard(
              backgroundColor: ColorRaqi.purple100,
              userName: cubit.userModel!.name,
              userProfilePic: NetworkImage(cubit.userModel!.image),
              cardActionWidget: SettingsItem(
                icons: Icons.edit,
                iconStyle: IconStyle(
                  withBackground: true,
                  borderRadius: 50,
                  backgroundColor: Colors.yellow[600],
                ),
                title: "Modify",
                subtitle: "Tap to change your data",
                subtitleStyle:
                    AppStyles.style12Regular(FontFamily.Cairo, context),
                onTap: () => navigateTo(context, EditProfileScreen()),
              ),
            ),
            // Settings group for main options
            SettingsGroup(
              backgroundColor: ColorNeutrals.white,
              items: [
                SettingsItem(
                  onTap: () => navigateTo(context, EditProfileScreen()),
                  icons: CupertinoIcons.person,
                  iconStyle:
                      IconStyle(backgroundColor: ColorStatus.successDark),
                  title: "${getLang(context, "settings")}",
                ),
                SettingsItem(
                  onTap: () {
                    RaqiCubit.get(context).getMyReserved("students");
                    navigateTo(context, MyReservationScreen());
                  },
                  icons: CupertinoIcons.calendar,
                  iconStyle: IconStyle(backgroundColor: ColorStatus.errorDark),
                  title: "${getLang(context, "reservation")}",
                ),
              ],
            ),
            SettingsGroup(
              backgroundColor: ColorNeutrals.white,
              settingsGroupTitle: "Support",
              items: [
                SettingsItem(
                  onTap: () async {
                    var whatsappUrl = "whatsapp://send?phone=+966550650011";
                    await canLaunch(whatsappUrl)
                        ? launch(whatsappUrl)
                        : showToast(
                            text: "تعذر الوصول لتطبيق واتساب",
                            state: ToastStates.ERROR,
                          );
                  },
                  icons: Icons.support_agent,
                  iconStyle: IconStyle(),
                  title: "${getLang(context, "contactUs")}",
                ),
                SettingsItem(
                  onTap: () => navigateTo(context, TermsScreen()),
                  icons: Icons.checklist_outlined,
                  iconStyle: IconStyle(),
                  title: "${getLang(context, "privacy")}",
                ),
              ],
            ),
            SettingsGroup(
              backgroundColor: ColorNeutrals.white,
              settingsGroupTitle: "Services",
              items: [
                SettingsItem(
                  onTap: () => navigateTo(context, QuranScreen()),
                  icons: Icons.book_outlined,
                  iconStyle: IconStyle(backgroundColor: ColorRaqi.purple100),
                  title: "${getLang(context, "quran")}",
                ),
                SettingsItem(
                  onTap: () => navigateTo(context, BooksScreen()),
                  icons: CupertinoIcons.book,
                  iconStyle: IconStyle(backgroundColor: ColorRaqi.purple100),
                  title: "${getLang(context, "books")}",
                ),
              ],
            ),
            // Account settings group with logout option
            SettingsGroup(
              backgroundColor: ColorNeutrals.white,
              settingsGroupTitle: "Account",
              items: [
                SettingsItem(
                  onTap: () => signOut(context),
                  icons: Icons.exit_to_app_rounded,
                  title: "${getLang(context, "logout")}",
                  titleStyle: TextStyle(color: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  
      },
    );
  }
}
