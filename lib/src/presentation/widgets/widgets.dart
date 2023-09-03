import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

import 'widgets.dart';

export 'custom_button.dart';
export 'custom_text_field.dart';
export 'palette.dart';
export 'theme.dart';

const loadingIndicator = Center(
  child: CircularProgressIndicator.adaptive(),
);

const kMobileContentConstraints = BoxConstraints(
  maxWidth: 400,
  maxHeight: double.infinity,
);

const gap2 = Gap(2);
const gap4 = Gap(4);
const gap6 = Gap(6);
const gap8 = Gap(8);
const gap10 = Gap(10);
const gap12 = Gap(12);
const gap16 = Gap(16);
const gap18 = Gap(18);
const gap24 = Gap(24);
const gap30 = Gap(30);
const gap32 = Gap(32);
const gap36 = Gap(36);
const gap48 = Gap(48);
const gap64 = Gap(64);
const gap128 = Gap(128);

const divider = Divider();
const radius8 = Radius.circular(8);
/// Set of extension methods to easily display a snackbar
extension ShowSnackBar on BuildContext {
  /// Displays a basic snackbar
  void showSnackBar({
    required String message,
    Color backgroundColor = Colors.white,
  }) {
    ScaffoldMessenger.of(this).showSnackBar(SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
    ));
  }

  /// Displays a red snackbar indicating error
  void showErrorSnackBar({required String message}) {
    showSnackBar(message: message, backgroundColor: Colors.red);
  }

  static bool isPreloading = false;
  static BuildContext? dialogContext;

  Future<void> hidePreloader() async {
    if (_stopwatch == null) return;
    if (_stopwatch!.elapsedMilliseconds < 300) {
      await Future.delayed(
        Duration(
          milliseconds: 300 - _stopwatch!.elapsedMilliseconds,
        ),
      );
    }
    _stopwatch?.stop();
    _stopwatch?.reset();
    if (dialogContext != null) {
      bool canPop = false;
      try {
        canPop = Navigator.canPop(dialogContext!);
      } on Exception {
        return;
      } catch (e) {
        return;
      }

      if (canPop) Navigator.pop(dialogContext!);
    }
  }

  static Stopwatch? _stopwatch;

  void showPreloader() async {
    if (isPreloading) return;
    isPreloading = true;
    _stopwatch ??= Stopwatch();
    _stopwatch?.start();
    await showDialog(
      useSafeArea: false,
      context: this,
      builder: (ctx) {
        dialogContext = ctx;
        return Center(
          child: Container(
            decoration: BoxDecoration(
              color: Palette.primary.withOpacity(.7),
              borderRadius: const BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            child: const Center(child: CircularProgressIndicator.adaptive()),
          ),
        );
      },
      barrierDismissible: false,
    );
    isPreloading = false;
  }
}

Widget? noCounter(
  BuildContext context, {
  required int currentLength,
  required int? maxLength,
  required bool isFocused,
}) =>
    emptyWidget;

const emptyWidget = SizedBox.shrink();
const zero = EdgeInsets.zero;
const always = AlwaysScrollableScrollPhysics();

extension Context on BuildContext {
  TextTheme get text => Theme.of(this).textTheme;

  TextStyle? get h1 => text.displayLarge;
  TextStyle? get h2 => text.displayMedium;
  TextStyle? get h3 => text.displaySmall;
  TextStyle? get h4 => text.headlineMedium;
  TextStyle? get h5 => text.headlineSmall;
  TextStyle? get h6 => text.titleLarge;

  TextStyle? get h8 => text.titleLarge?.copyWith(
        color: Palette.gray2,
        fontSize: 14,
        fontWeight: FontWeight.w400,
      );
  TextStyle? get h9 => const TextStyle(
        color: Palette.gray2,
        fontWeight: FontWeight.w600,
      );
  TextStyle? get h7 => text.titleLarge?.copyWith(
        fontSize: 18.0,
        color: Palette.gray1,
        fontWeight: FontWeight.w500,
      );

  TextStyle? get s1 => text.titleMedium;
  TextStyle? get s2 => text.titleSmall;

  TextStyle? get s3 => text.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        color: Palette.gray2,
      );
  TextStyle? get d1 => text.titleMedium?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Palette.gray1,
      );
  TextStyle? get l1 => text.titleMedium?.copyWith(
        fontWeight: FontWeight.w400,
        fontSize: 14,
        color: Palette.gray2,
      );
  TextStyle? get v1 => text.titleMedium?.copyWith(
        fontWeight: FontWeight.w600,
        fontSize: 14,
        color: Palette.gray2,
      );

  TextStyle? get b => text.labelLarge;

  Size get size => MediaQuery.of(this).size;

  double get w => size.width;
  double get h => size.height;
}

extension WidgetPaddingX on Widget {
  Widget paddingAll(double padding) => Padding(
        padding: EdgeInsets.all(
          padding,
        ),
        child: this,
      );
  Widget toSliver() => SliverToBoxAdapter(
        child: this,
      );

  Widget paddingSymmetric({
    double horizontal = 0.0,
    double vertical = 0.0,
  }) =>
      Padding(
        padding: EdgeInsets.symmetric(
          horizontal: horizontal,
          vertical: vertical,
        ),
        child: this,
      );

  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) =>
      Padding(
          padding: EdgeInsets.only(
              top: top, left: left, right: right, bottom: bottom),
          child: this);

  Widget get paddingZero => Padding(padding: EdgeInsets.zero, child: this);
}
