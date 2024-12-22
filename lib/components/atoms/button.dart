import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:pilll/components/atoms/color.dart';
import 'package:pilll/components/atoms/font.dart';
import 'package:pilll/components/atoms/text_color.dart';
import 'package:flutter/material.dart';

class PrimaryButton extends HookWidget {
  final String text;
  final Future<void> Function()? onPressed;

  const PrimaryButton({
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((statuses) {
            if (statuses.contains(WidgetState.disabled)) {
              return AppColors.lightGray;
            }
            return AppColors.primary;
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
                    if (context.mounted) isProcessing.value = false;
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
                      color: AppColors.white,
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
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

    return Stack(
      alignment: Alignment.center,
      children: [
        ElevatedButton(
          style: ButtonStyle(backgroundColor: WidgetStateProperty.resolveWith((statuses) {
            if (statuses.contains(WidgetState.disabled)) {
              return AppColors.lightGray;
            }
            return AppColors.gray;
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
                    if (context.mounted) isProcessing.value = false;
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
                      color: AppColors.white,
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
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

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
                  if (context.mounted) isProcessing.value = false;
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
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

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
                  if (context.mounted) isProcessing.value = false;
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
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

    return OutlinedButton(
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        side: const BorderSide(color: AppColors.primary),
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
                if (context.mounted) isProcessing.value = false;
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
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

    return Stack(
      alignment: Alignment.center,
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            side: const BorderSide(color: AppColors.primary),
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
                    if (context.mounted) isProcessing.value = false;
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
    super.key,
    required this.onPressed,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    final isProcessing = useState(false);

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
                if (context.mounted) isProcessing.value = false;
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
