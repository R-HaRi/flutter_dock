import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// [Widget] building the [MaterialApp].
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Dock(
            items: const [
              Icons.person,
              Icons.message,
              Icons.call,
              Icons.camera,
              Icons.photo,
            ],
            builder: (icon)=> DockItem(icon: icon)
          ),
        ),
      ),
    );
  }
}

/// [Widget] representing an individual icon in the [Dock].
/// This Widget is draggable and can be reordered in the [Dock].
class DockItem extends StatelessWidget {
  const DockItem({super.key, required this.icon});

  /// The [IconData] representing the icon to be displayed in the dock.
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Draggable<IconData>(
      data: icon,
      feedback: Material(
        color: Colors.transparent,
        child: Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.primaries[icon.hashCode % Colors.primaries.length],
          ),
          child: Icon(icon, color: Colors.white, size: 36),
        ),
      ),
      childWhenDragging: Container(color: Colors.transparent, width: 48, height: 48),
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.primaries[icon.hashCode % Colors.primaries.length],
        ),
        child: Center(
          child: Icon(icon, color: Colors.white, size: 24),
        ),
      ),
    );
  }
}

/// Dock of the reorderable [items].
class Dock extends StatefulWidget {
  const Dock({
    super.key,
    this.items = const [],
    required this.builder,
  });

  /// Initial [IconData] items to put in this [Dock].
  final List<IconData> items;

  /// Builder building the provided [IconData] item.
  final Widget Function(IconData) builder;

  @override
  State<Dock> createState() => _DockState();
}

/// State of the [Dock] used to manipulate the [_items].
class _DockState extends State<Dock> {
  /// [IconData] items being manipulated.
  late final List<IconData> _items = List<IconData>.from(widget.items);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.black12,
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(_items.length, (index) {
          return DragTarget<IconData>(
            /// Callback triggered when an item is dropped onto this target.
            /// It swaps the items' positions in the list.
            onAccept: (receivedItem) {
              setState(() {
                final oldIndex = _items.indexOf(receivedItem);
                if (oldIndex != index) {
                  // Swap the items in the list when dragged to a new slot
                  final temp = _items[index];
                  _items[index] = receivedItem;
                  _items[oldIndex] = temp;
                }
              });
            },
            /// Callback that checks whether the item being dragged can be accepted.
            /// Prevents dropping the same item on itself.
            onWillAccept: (receivedItem) => receivedItem != _items[index],
            builder: (context, candidateData, rejectedData) {
              // If item is being dragged over, it scales up slightly
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: candidateData.isNotEmpty ? 60 : 48,
                height: candidateData.isNotEmpty ? 60 : 48,
                margin: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.transparent,
                ),
                child: widget.builder(_items[index]),
              );
            },
          );
        }),
      ),
    );
  }
}