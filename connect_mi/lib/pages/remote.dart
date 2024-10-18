import 'package:connect_mi/models/lamp_controls_params.dart';
import 'package:connect_mi/models/lamp_supported_modes.dart';
import 'package:connect_mi/models/lamp_type.dart';
import 'package:connect_mi/utils/api/lamp_service.dart';
import 'package:connect_mi/utils/lamp_type_util.dart';
import 'package:connect_mi/widgets/common/themed_header.dart';
import 'package:connect_mi/widgets/common/themed_text_field.dart';
import 'package:connect_mi/widgets/extensions/lamp_group_dropdown.dart';
import 'package:connect_mi/widgets/extensions/lamp_type_dropdown.dart';
import 'package:connect_mi/widgets/remotes/lamp_brightness.dart';
import 'package:connect_mi/widgets/remotes/lamp_toggle.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class RemotePage extends StatefulWidget {
  const RemotePage({super.key});

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  late TextEditingController _idController;
  RemoteType selectedRemote = RemoteType.none;
  int selectedGroup = 0;
  bool areControlsDisabled = true;

  @override
  void initState() {
    super.initState();
    _idController = TextEditingController();
    _idController.text = "0";
  }

  @override
  void dispose() {
    _idController.dispose();
    super.dispose();
  }

  void selectRemote(RemoteType type) {
    setState(() {
      selectedRemote = type;
    });
    verifyControlsState();
  }

  void selectGroup(int group) {
    setState(() {
      selectedGroup = group;
    });
    verifyControlsState();
  }

  void verifyControlsState() {
    var isTypeSelected = selectedRemote != RemoteType.none;
    var idAsNumber = int.tryParse(_idController.text);
    var isIdCorrect =
        idAsNumber != null && idAsNumber >= 0 && idAsNumber <= 65535;

    if (isTypeSelected && isIdCorrect) {
      setState(() {
        areControlsDisabled = false;
      });
      return;
    }

    setState(() {
      areControlsDisabled = true;
    });

    return;
  }

  void toggleLamp(bool turnOn) {
    var idAsNumber = int.tryParse(_idController.text) ?? 0;

    LampService().toggleLamp(
        LampControlParams(
            deviceId: idAsNumber, type: selectedRemote, group: selectedGroup),
        turnOn);
  }

  void setBrightness(double brightness) {
    var idAsNumber = int.tryParse(_idController.text) ?? 0;
    var brightnessRounded = num.parse(brightness.toStringAsFixed(0));

    LampService().setBrightness(
        LampControlParams(
            deviceId: idAsNumber, type: selectedRemote, group: selectedGroup),
        brightnessRounded);
  }

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorTheme = Theme.of(context).colorScheme;
    LampSupportedModes lampMode = LampTypeUtils.getSupportType(
        selectedRemote); // Get mode (CCT, RGB, etc.)

    // Determine the number of tabs based on the supported modes
    List<Widget> tabs = [];
    List<Widget> tabViews = [];

    switch (lampMode) {
      case LampSupportedModes.cctOnly:
        tabs = const [Tab(text: 'White')];
        tabViews = const [Center(child: Text('White Tab Content'))];
        break;
      case LampSupportedModes.rgbOnly:
        tabs = const [Tab(text: 'Color')];
        tabViews = const [Center(child: Text('Color Tab Content'))];
        break;
      case LampSupportedModes.cctRgb:
        tabs = const [
          Tab(text: 'Color'),
          Tab(text: 'White'),
        ];
        tabViews = const [
          Center(child: Text('Color Tab Content')),
          Center(child: Text('White Tab Content')),
        ];
        break;
      default:
        break;
    }

    return DefaultTabController(
      length: tabs.length,
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              DefaultHeader(
                onPressAdd: () => context.push('/'),
                onPressMenu: () => context.push('/'),
                paddingHorizontal: 16,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: LampTypeDropdown(
                            onChangeType: selectRemote,
                            selectedType: selectedRemote,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LampGroupDropdown(
                            onChangeValue: selectGroup,
                            selectedGroup:
                                LampTypeUtils.getGroupSize(selectedRemote),
                            selectedValue: selectedGroup,
                            isDisabled: selectedRemote == RemoteType.none,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Flexible(
                          child: ThemedTextField(
                            controller: _idController,
                            label: "ID",
                            onChanged: (value) => verifyControlsState(),
                            isDisabled:
                                false, // Set to true if you want to disable the TextField
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              Divider(
                color: colorTheme.secondary,
              ),
              Expanded(
                child: TabBarView(
                  children: tabViews,
                ),
              ),
              Divider(
                color: colorTheme.secondary,
              ),
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    LampBrightnessSlider(
                      setBrightness: setBrightness,
                      initialValue: 0,
                      isDisabled: areControlsDisabled,
                    ),
                    const SizedBox(height: 8),
                    LampToggle(
                      toggleLamp: toggleLamp,
                      labelOn: 'ON',
                      labelOff: 'OFF',
                      isDisabled: areControlsDisabled,
                    ),
                  ],
                ),
              ),
            ],
          ),
          bottomNavigationBar: tabs.isNotEmpty
              ? TabBar(
                  tabs: tabs,
                  indicatorWeight: 1.0,
                  dividerColor: Colors.transparent,
                  indicatorColor: colorTheme.primary,
                  indicatorSize: TabBarIndicatorSize.tab,
                )
              : const SizedBox.shrink(),
        ),
      ),
    );
  }
}
