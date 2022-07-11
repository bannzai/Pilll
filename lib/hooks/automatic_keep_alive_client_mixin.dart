import 'package:flutter/widgets.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

// Ref: https://github.com/rrousselGit/flutter_hooks/issues/101#issuecomment-762121053
// Re implement useAutomaticKeepAlive with NNDB
void useAutomaticKeepAlive({
  bool? wantKeepAlive,
}) =>
    use(_AutomaticKeepAliveHook(
      wantKeepAlive: wantKeepAlive ?? true,
    ));

class _AutomaticKeepAliveHook extends Hook<void> {
  final bool wantKeepAlive;

  const _AutomaticKeepAliveHook({required this.wantKeepAlive});

  @override
  HookState<void, _AutomaticKeepAliveHook> createState() =>
      _AutomaticKeepAliveHookState();
}

class _AutomaticKeepAliveHookState
    extends HookState<void, _AutomaticKeepAliveHook> {
  KeepAliveHandle? _keepAliveHandle;

  void _ensureKeepAlive() {
    assert(_keepAliveHandle == null);
    final keepAliveHandle = KeepAliveHandle();
    _keepAliveHandle = keepAliveHandle;
    KeepAliveNotification(keepAliveHandle).dispatch(context);
  }

  void _releaseKeepAlive() {
    _keepAliveHandle?.release();
    _keepAliveHandle = null;
  }

  void updateKeepAlive() {
    if (hook.wantKeepAlive) {
      if (_keepAliveHandle == null) _ensureKeepAlive();
    } else {
      if (_keepAliveHandle != null) _releaseKeepAlive();
    }
  }

  @override
  void initHook() {
    super.initHook();
    if (hook.wantKeepAlive) _ensureKeepAlive();
  }

  @override
  void build(BuildContext context) {
    if (hook.wantKeepAlive && _keepAliveHandle == null) _ensureKeepAlive();
    return;
  }

  @override
  void deactivate() {
    if (_keepAliveHandle != null) _releaseKeepAlive();
    super.deactivate();
  }

  @override
  Object get debugValue => _keepAliveHandle ?? "NULL";

  @override
  String get debugLabel => 'useAutomaticKeepAlive';
}
