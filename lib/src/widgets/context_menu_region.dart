import 'package:flutter/material.dart';

import '../core/models/context_menu.dart';
import '../core/utils/helpers.dart';

enum MenuType { desktop, mobile, custom }

/// A widget that shows a context menu when the user long presses or right clicks on the widget.
class ContextMenuRegion extends StatelessWidget {
  final ContextMenu contextMenu;
  final Widget child;
  final void Function(dynamic value)? onItemSelected;
  final MenuType menuType;

  const ContextMenuRegion(
      {super.key,
      required this.contextMenu,
      required this.child,
      this.onItemSelected,
      this.menuType = MenuType.custom});

  @override
  Widget build(BuildContext context) {
    Offset mousePosition = Offset.zero;

    return Listener(
      onPointerDown: (event) {
        mousePosition = event.position;
      },
      child: GestureDetector(
        onTap: () => menuType == MenuType.custom
            ? _showMenu(context, mousePosition)
            : null,
        onLongPress: () => menuType == MenuType.mobile
            ? _showMenu(context, mousePosition)
            : null,
        onSecondaryTap: () => menuType == MenuType.desktop
            ? _showMenu(context, mousePosition)
            : null,
        child: child,
      ),
    );
  }

  void _showMenu(BuildContext context, Offset mousePosition) async {
    final menu =
        contextMenu.copyWith(position: contextMenu.position ?? mousePosition);
    final value = await showContextMenu(context, contextMenu: menu);
    onItemSelected?.call(value);
  }
}
