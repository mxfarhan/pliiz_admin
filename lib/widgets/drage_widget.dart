import 'package:flutter/material.dart';

class DraggableWidget extends StatefulWidget {
  final Widget child;
  final int index;
  final Function(int oldIndex, int newIndex) onReorder;
  const DraggableWidget({super.key, required this.child, required this.index, required this.onReorder});
  @override
   createState() => _DraggableWidgetState();
}

class _DraggableWidgetState extends State<DraggableWidget> {
  @override
  Widget build(BuildContext context) {
    return Draggable<int>(
      data: widget.index,
      feedback: Material(
        child: widget.child,
      ),
      childWhenDragging: Container(),
      child: widget.child,
    );
  }
}