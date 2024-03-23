import 'package:flutter_hooks/flutter_hooks.dart';
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

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    // Avoid [Once you have called dispose() on a ValueNotifier<bool>, it can no longer be use]
    final isMounted = useIsMounted();

    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((statuses) {
            if (statuses.contains(MaterialState.disabled)) {
              return PilllColors.lightGray;
            }
            return PilllColors.primary;
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
                    if (isMounted()) isProcessing.value = false;
                  }
                },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 44, minHeight: 44, minWidth: 180),
            child: Center(
                child: Text(text,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: PilllColors.white,
                    ))),
          ),
        ),
        if (isProcessing.value) _Loading(),
      ],
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

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final isMounted = useIsMounted();

    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: MaterialStateProperty.resolveWith((statuses) {
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
                    if (isMounted()) isProcessing.value = false;
                  }
                },
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 44, minHeight: 44, minWidth: 180, maxWidth: 180),
            child: Center(
                child: Text(text,
                    style: const TextStyle(
                      fontFamily: FontFamily.japanese,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      color: PilllColors.white,
                    ))),
          ),
        ),
        if (isProcessing.value) _Loading(),
      ],
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

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final isMounted = useIsMounted();

    return SizedBox(
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
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
                  if (isMounted()) isProcessing.value = false;
                }
              },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isProcessing.value ? TextColor.gray : TextColor.primary,
              ),
            ),
            if (isProcessing.value) _Loading(),
          ],
        ),
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

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final isMounted = useIsMounted();

    return SizedBox(
      width: 180,
      height: 44,
      child: TextButton(
        style: TextButton.styleFrom(backgroundColor: Colors.transparent),
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
                  if (isMounted()) isProcessing.value = false;
                }
              },
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(text, style: TextStyle(color: isProcessing.value ? TextColor.lightGray : TextColor.gray)),
            if (isProcessing.value) _Loading(),
          ],
        ),
      ),
    );
  }
}

class SmallAppOutlinedButton extends HookWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const SmallAppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final isMounted = useIsMounted();

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: PilllColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: PilllColors.primary),
      ),
      onPressed: onPressed == null
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
                if (isMounted()) isProcessing.value = false;
              }
            },
      child: Container(
        padding: const EdgeInsets.only(top: 8.5, bottom: 8.5),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Text(
              text,
              style: TextStyle(
                color: isProcessing.value ? TextColor.gray : TextColor.main,
                fontSize: 12,
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (isProcessing.value) _Loading(),
          ],
        ),
      ),
    );
  }
}

class AppOutlinedButton extends HookWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const AppOutlinedButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final isMounted = useIsMounted();

    return Stack(
      alignment: Alignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: PilllColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: const BorderSide(color: PilllColors.primary),
          ),
          onPressed: onPressed == null
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
                    if (isMounted()) isProcessing.value = false;
                  }
                },
          child: Container(
            padding: const EdgeInsets.only(top: 12, bottom: 12),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: isProcessing.value ? TextColor.gray : TextColor.main,
                  fontSize: 16,
                  fontFamily: FontFamily.japanese,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        if (isProcessing.value) _Loading(),
      ],
    );
  }
}

class AlertButton extends HookWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const AlertButton({
    Key? key,
    required this.onPressed,
    required this.text,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);
    final isMounted = useIsMounted();

    return TextButton(
      onPressed: onPressed == null
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
                if (isMounted()) isProcessing.value = false;
              }
            },
      child: Stack(
        alignment: Alignment.center,
        children: [
          Text(
            text,
            style: TextStyle(
                fontFamily: FontFamily.japanese,
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: (isProcessing.value || onPressed == null) ? TextColor.gray : TextColor.primary),
          ),
          if (isProcessing.value) _Loading(),
        ],
      ),
    );
  }
}

class _Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 20,
      height: 20,
      child: CircularProgressIndicator(
        strokeWidth: 1,
        valueColor: AlwaysStoppedAnimation(Colors.grey),
      ),
    );
  }
}
