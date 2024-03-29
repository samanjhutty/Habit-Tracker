import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../controller/db_controller.dart';
import '../../controller/local/db_constants.dart';

class MyBottomSheet extends StatefulWidget {
  const MyBottomSheet({super.key});

  @override
  State<MyBottomSheet> createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet>
    with TickerProviderStateMixin {
  Color? appThemeColor;
  @override
  void initState() {
    appThemeColor = Color(box.get(BoxConstants.appThemeColorValue) ??
        const Color(0xFFFB5B76).value);
    setState(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ColorScheme scheme = Theme.of(context).colorScheme;

    return BottomSheet(
      animationController: BottomSheet.createAnimationController(this),
      showDragHandle: true,
      onClosing: () {},
      builder: (context) => Column(
        children: [
          Flexible(
            child: ListView(
              children: [
                RadioListTile(
                  value: const Color(0xFFFB5B76),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Default'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFFB5B76),
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFFB2FF59),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Light Green'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.lightGreenAccent,
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFF40C4FF),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Light Blue'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Colors.lightBlueAccent,
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFFE040FB),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Purple'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFE040FB),
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFF64FFDA),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Teal'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF64FFDA),
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFF536DFE),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Indigo'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFF536DFE),
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFFFFD740),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Amber'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFFFD740),
                        ),
                      )
                    ],
                  ),
                ),
                RadioListTile(
                  value: const Color(0xFFFF6E40),
                  groupValue: appThemeColor,
                  onChanged: (value) {
                    setState(() {
                      appThemeColor = value!;
                    });
                  },
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Deep Orange'),
                      Container(
                        decoration: BoxDecoration(
                            color: scheme.secondary, shape: BoxShape.circle),
                        padding: const EdgeInsets.all(4),
                        child: const CircleAvatar(
                          radius: 16,
                          backgroundColor: Color(0xFFFF6E40),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Consumer<DbController>(builder: (context, db, child) {
                  return ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: scheme.primary,
                          foregroundColor: scheme.onPrimary),
                      onPressed: () async {
                        Navigator.pop(context);
                        db.changeTheme(appThemeColor!);
                        await Get.forceAppUpdate();
                      },
                      label: const Text('Save'),
                      icon: const Icon(Icons.check));
                })
              ],
            ),
          )
        ],
      ),
    );
  }
}
