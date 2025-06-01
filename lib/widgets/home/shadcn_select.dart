// shadcn_select.dart
import 'package:flutter/material.dart';

class ShadOption<T> extends StatelessWidget {
  final T value;
  final Widget child;

  const ShadOption({
    super.key,
    required this.value,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return child;
  }
}

class ShadSelect<T> extends StatefulWidget {
  final T? value;
  final Widget placeholder;
  final List<Widget> options;
  final Widget Function(BuildContext, T) selectedOptionBuilder;
  final ValueChanged<T>? onChanged;
  final double minWidth;

  const ShadSelect({
    super.key,
    required this.placeholder,
    required this.options,
    required this.selectedOptionBuilder,
    this.onChanged,
    this.value,
    this.minWidth = 180,
  });

  @override
  State<ShadSelect<T>> createState() => _ShadSelectState<T>();
}

class _ShadSelectState<T> extends State<ShadSelect<T>> {
  final GlobalKey _buttonKey = GlobalKey();

  void _showMenu() {
    final RenderBox renderBox =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final Size size = renderBox.size;
    final Offset offset = renderBox.localToGlobal(Offset.zero);

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 8,
        offset.dx + size.width,
        offset.dy,
      ),
      constraints: BoxConstraints(
        minWidth: size.width,
        maxHeight: 200,
      ),
      color: Colors.black, // Black background for dropdown menu
      shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade700), // Grey border
        borderRadius: BorderRadius.circular(6),
      ),
      items: widget.options.map((option) {
        if (option is ShadOption<T>) {
          return PopupMenuItem<T>(
            value: option.value,
            height: 36,
            child: Container(
              color: Colors.black, // Black background for menu items
              child: option.child,
            ),
          );
        }
        return PopupMenuItem<T>(
          enabled: false,
          height: 36,
          child: Container(
            color: Colors.black, // Black background for headers
            child: option,
          ),
        );
      }).toList(),
    ).then((value) {
      if (value != null && widget.onChanged != null) {
        widget.onChanged!(value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.minWidth,
      child: OutlinedButton(
        key: _buttonKey,
        onPressed: _showMenu,
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          backgroundColor: Colors.black, // Black background
          side: BorderSide(color: Colors.grey.shade700), // Grey border
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          alignment: Alignment.centerLeft,
        ),
        child: Row(
          children: [
            Expanded(
              child: DefaultTextStyle.merge(
                style: const TextStyle(color: Colors.white), // White text
                child: widget.value != null
                    ? widget.selectedOptionBuilder(context, widget.value as T)
                    : widget.placeholder,
              ),
            ),
            const Icon(Icons.expand_more, size: 16, color: Colors.white), // White icon
          ],
        ),
      ),
    );
  }
}