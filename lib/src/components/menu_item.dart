import 'package:flutter/material.dart';

import '../core/models/context_menu_entry.dart';
import '../core/models/context_menu_item.dart';
import '../core/utils/extensions.dart';
import '../widgets/context_menu_state.dart';
import 'menu_divider.dart';
import 'menu_header.dart';

/// Represents a selectable item in a context menu.
///
/// This class is used to define individual items that can be displayed within
/// a context menu.
///
/// #### Parameters:
/// - [label] - The title of the context menu item
/// - [icon] - The icon of the context menu item.
/// - [constraints] - The height of the context menu item.
/// - [focusNode] - The focus node of the context menu item.
/// - [value] - The value associated with the context menu item.
/// - [items] - The list of subitems associated with the context menu item.
/// - [onSelected] - The callback that is triggered when the context menu item
///   is selected. If the item has subitems, it toggles the visibility of the
///   submenu. If not, it pops the current context menu and returns the
///   associated value.
/// - [constraints] - The constraints of the context menu item.
///
/// see:
/// - [ContextMenuEntry]
/// - [MenuHeader]
/// - [MenuDivider]
///
final class MenuItem<T> extends ContextMenuItem<T> {
  final String label;
  final Widget? icon;
  final BoxConstraints? constraints;
  final TextStyle? menuTextStyle;

  const MenuItem(
      {required this.label,
      this.icon,
      super.value,
      super.onSelected,
      this.constraints,
      this.menuTextStyle});

  const MenuItem.submenu(
      {required this.label,
      required List<ContextMenuEntry> items,
      this.icon,
      super.onSelected,
      this.constraints,
      this.menuTextStyle})
      : super.submenu(items: items);

  @override
  Widget builder(BuildContext context, ContextMenuState menuState,
      [FocusNode? focusNode]) {
    bool isFocused = menuState.focusedEntry == this;

    final background = context.colorScheme.surface;
    final normalTextColor = Color.alphaBlend(
      context.colorScheme.onSurface.withValues(alpha: 0.7),
      background,
    );
    final focusedTextColor = context.colorScheme.onSurface;
    final foregroundColor = isFocused ? focusedTextColor : normalTextColor;
    final textStyle = TextStyle(color: foregroundColor, height: 1.0);

    // ~~~~~~~~~~ //

    return ConstrainedBox(
      constraints: constraints ?? const BoxConstraints.expand(height: 32.0),
      child: Material(
        color: isFocused ? context.theme.focusColor.withAlpha(20) : background,
        borderRadius: BorderRadius.circular(4.0),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => handleItemSelection(context),
          canRequestFocus: false,
          child: DefaultTextStyle(
            style: textStyle,
            child: Row(
              children: [
                if (icon != null)
                  SizedBox.square(
                    dimension: 32.0,
                    child: icon,
                  ),
                const SizedBox(width: 4.0),
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    style: menuTextStyle,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(width: 8.0),
                SizedBox.square(
                  dimension: 32.0,
                  child: Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: Icon(
                      isSubmenuItem ? Icons.arrow_right : null,
                      size: 16.0,
                      color: foregroundColor,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
