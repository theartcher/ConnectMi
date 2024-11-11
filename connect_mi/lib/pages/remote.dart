import 'package:connect_mi/models/lamp_controls_params.dart';
import 'package:connect_mi/models/lamp_group.dart';
import 'package:connect_mi/models/lamp_state.dart';
import 'package:connect_mi/models/lamp_supported_modes.dart';
import 'package:connect_mi/models/lamp_type.dart';
import 'package:connect_mi/utils/api/lamp_service.dart';
import 'package:connect_mi/utils/lamp_type_util.dart';
import 'package:connect_mi/widgets/common/themed_header.dart';
import 'package:connect_mi/widgets/common/themed_text_field.dart';
import 'package:connect_mi/widgets/extensions/lamp_group_dropdown.dart';
import 'package:connect_mi/widgets/extensions/lamp_type_dropdown.dart';
import 'package:connect_mi/widgets/remotes/brightness_slider.dart';
import 'package:connect_mi/widgets/remotes/lamp_toggle.dart';
import 'package:connect_mi/widgets/remotes/saturation_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circle_color_picker/flutter_circle_color_picker.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:go_router/go_router.dart';

class RemotePage extends StatefulWidget {
  const RemotePage({super.key});

  @override
  State<RemotePage> createState() => _RemotePageState();
}

class _RemotePageState extends State<RemotePage> {
  late TextEditingController _idController;
  final _colorPickerController =
      CircleColorPickerController(initialColor: Colors.blue);

  RemoteType selectedRemote = RemoteType.none;
  int selectedGroup = 0;
  bool areControlsDisabled = true;
  Color _selectedColor = Color(0xFFCCCCFF);
  num _selectedBrightness = 50;
  num _selectedSaturation = 50;

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

  Future<void> resetStateToSavedOrDefault() async {
    LampState lampState =
        await LampService().getCurrentState(_getDeviceParams());

    var hsvColor = HSVColor.fromColor(lampState.color ?? Colors.purple);

    setState(() {
      _colorPickerController.color = lampState.color ?? Colors.purple;
      _selectedBrightness = lampState.brightness ?? 50;
      //We have to convert to use this, as it seems the API uses HSV for saturation for some reason-
      _selectedSaturation = hsvColor.saturation * 100;
    });
  }

  LampControlParams _getDeviceParams() {
    var idAsNumber = int.tryParse(_idController.text) ?? 0;
    return LampControlParams(
        deviceId: idAsNumber, type: selectedRemote, group: selectedGroup);
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
    final TextTheme textTheme = Theme.of(context).textTheme;
    LampSupportedModes lampMode = LampTypeUtils.getSupportType(selectedRemote);

    double width = MediaQuery.sizeOf(context).width;
    double height = MediaQuery.sizeOf(context).height;
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
        tabViews = [
          SingleChildScrollView(
              child: Column(children: [
            CircleColorPicker(
              size: Size((width - width / 10), (width - width / 10)),
              controller: _colorPickerController,
              onChanged: (color) {
                setState(() => _selectedColor = color);
              },
              onEnded: (color) {
                LampService().setColor(_getDeviceParams(), color);
              },
              //We can be sure this is defined, if not result to an ugly style instead.
              textStyle: textTheme.displayMedium ??
                  const TextStyle(color: Colors.pink),
            ),
            SaturationSlider(
                initialValue: _selectedSaturation.toInt(),
                setSaturation: (double saturation) {
                  var saturationRounded =
                      num.parse(saturation.toStringAsFixed(0));

                  setState(() {
                    _selectedSaturation = saturationRounded;
                  });

                  LampService()
                      .setSaturation(_getDeviceParams(), saturationRounded);
                },
                baseColor: _colorPickerController.color)
          ])),
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
                        Flexible(
                          child: ThemedTextField(
                            controller: _idController,
                            label: "ID",
                            onChanged: (value) => verifyControlsState(),
                            onEditingComplete: (value) async {
                              setState(() {
                                _idController.text = value;
                              });

                              await resetStateToSavedOrDefault();
                            },
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: LampTypeDropdown(
                            onChangeType: (RemoteType type) {
                              setState(() {
                                selectedRemote = type;
                              });
                              verifyControlsState();
                            },
                            selectedType: selectedRemote,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: LampGroupDropdown(
                            onChangeValue: (int group) {
                              setState(() {
                                selectedGroup = group;
                              });
                              verifyControlsState();
                            },
                            selectedGroup:
                                LampTypeUtils.getGroupSize(selectedRemote),
                            selectedValue: selectedGroup,
                            isDisabled: selectedRemote == RemoteType.none,
                          ),
                        ),
                      ],
                    ),
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
                    BrightnessSlider(
                      setBrightness: (brightness) {
                        var brightnessRounded =
                            num.parse(brightness.toStringAsFixed(0));

                        setState(() {
                          _selectedBrightness = brightnessRounded;
                        });

                        LampService().setBrightness(
                            _getDeviceParams(), brightnessRounded);
                      },
                      minValue: 0,
                      maxValue: 255,
                      initialValue: _selectedBrightness.toInt(),
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
