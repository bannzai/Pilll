import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/button.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends HookWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const PrimaryButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    return ElevatedButton(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxHeight: 44, minHeight: 44, minWidth: 180, maxWidth: 180),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(text, style: ButtonTextStyle.main),
            if (isProcessing.value) _Loading(),
          ],
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((statuses) {
        if (statuses.contains(MaterialState.disabled)) {
          return PilllColors.lightGray;
        }
        return PilllColors.secondary;
      })),
      onPressed: isProcessing.value || onPressed == null
          ? null
          : () async {
              if (isProcessing.value) {
                return;
              }
              isProcessing.value = true;

              try {
                await onPressed?.call();
              } catch (error) {
                rethrow;
              } finally {
                isProcessing.value = false;
              }
            },
    );
  }
}

class UndoButton extends HookWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const UndoButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    return ElevatedButton(
      child: ConstrainedBox(
        constraints: const BoxConstraints(
            maxHeight: 44, minHeight: 44, minWidth: 180, maxWidth: 180),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(text, style: ButtonTextStyle.main),
            if (isProcessing.value) _Loading(),
          ],
        ),
      ),
      style: ButtonStyle(
          backgroundColor: MaterialStateProperty.resolveWith((statuses) {
        if (statuses.contains(MaterialState.disabled)) {
          return PilllColors.lightGray;
        }
        return PilllColors.gray;
      })),
      onPressed: isProcessing.value || onPressed == null
          ? null
          : () async {
              if (isProcessing.value) {
                return;
              }
              isProcessing.value = true;

              try {
                await onPressed?.call();
              } catch (error) {
                rethrow;
              } finally {
                isProcessing.value = false;
              }
            },
    );
  }
}

class RedTextButton extends HookWidget {
  final String text;
  final Future<void> Function() onPressed;

  const RedTextButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    var isProcessing = useState(false);
    return SizedBox(
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(text,
                style: isProcessing.value
                    ? TextColorStyle.gray
                    : TextColorStyle.primary),
            if (isProcessing.value) _Loading(),
          ],
        ),
        onPressed: isProcessing.value
            ? null
            : () async {
                if (isProcessing.value) {
                  return;
                }
                isProcessing.value = true;

                try {
                  await onPressed.call();
                } catch (error) {
                  rethrow;
                } finally {
                  isProcessing.value = false;
                }
              },
      ),
    );
  }
}

class InconspicuousButton extends HookWidget {
  final String text;
  final Future<void> Function() onPressed;

  const InconspicuousButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    var isProcessing = useState(false);
    return SizedBox(
      width: 180,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(text,
                style: isProcessing.value
                    ? TextColorStyle.lightGray
                    : TextColorStyle.gray),
            if (isProcessing.value) _Loading(),
          ],
        ),
        onPressed: isProcessing.value
            ? null
            : () async {
                if (isProcessing.value) {
                  return;
                }
                isProcessing.value = true;

                try {
                  await onPressed.call();
                } catch (error) {
                  rethrow;
                } finally {
                  isProcessing.value = false;
                }
              },
      ),
    );
  }
}

class SmallAppOutlinedButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const SmallAppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    var isProcessing = false;
    return OutlinedButton(
      child: Container(
        padding: const EdgeInsets.only(top: 8.5, bottom: 8.5),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: TextColor.main,
              fontSize: 12,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: PilllColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: PilllColors.secondary),
      ),
      onPressed: onPressed == null
          ? null
          : () async {
              if (isProcessing) {
                return;
              }
              isProcessing = true;
              try {
                await onPressed?.call();
              } catch (error) {
                rethrow;
              } finally {
                isProcessing = false;
              }
            },
    );
  }
}

class AppOutlinedButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const AppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    var isProcessing = false;
    return OutlinedButton(
      child: Container(
        padding: const EdgeInsets.only(top: 12, bottom: 12),
        child: Center(
          child: Text(
            text,
            style: const TextStyle(
              color: TextColor.main,
              fontSize: 16,
              fontFamily: FontFamily.japanese,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      style: OutlinedButton.styleFrom(
        primary: PilllColors.secondary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: PilllColors.secondary),
      ),
      onPressed: onPressed == null
          ? null
          : () async {
              if (isProcessing) {
                return;
              }
              isProcessing = true;
              try {
                await onPressed?.call();
              } catch (error) {
                rethrow;
              } finally {
                isProcessing = false;
              }
            },
    );
  }
}

class AlertButton extends StatelessWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const AlertButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  Widget build(BuildContext context) {
    return TextButton(
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: FontFamily.japanese,
          fontWeight: FontWeight.w600,
          fontSize: FontSize.normal,
          color: PilllColors.primary,
        ),
      ),
      onPressed: onPressed,
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: const CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation(Colors.grey),
      ),
    );
  }
}
