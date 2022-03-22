import 'package:flutter/material.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:pilll/entity/initial_setting_pill_category_type.dart';

class CardLayout extends StatelessWidget {
  final InitialSettingPillCategoryType pillCategoryType;
  final String caption;
  final Widget image;
  final String name;
  final List<String> pillNames;
  final Function(InitialSettingPillCategoryType) onTap;

  const CardLayout({
    Key? key,
    required this.pillCategoryType,
    required this.caption,
    required this.image,
    required this.name,
    required this.pillNames,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap(pillCategoryType);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          boxShadow: [
            BoxShadow(
              color: PilllColors.shadow,
              blurRadius: 8.0,
              spreadRadius: 2,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        padding: const EdgeInsets.only(top: 8, left: 12, right: 12, bottom: 16),
        child: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(20)),
                  color: PilllColors.mat,
                ),
                child: Text(
                  caption,
                  style: const TextStyle(
                    color: TextColor.main,
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  image,
                  const SizedBox(height: 12),
                  Column(
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: TextColor.main,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        pillNames.join("/"),
                        style: const TextStyle(
                          color: TextColor.main,
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
