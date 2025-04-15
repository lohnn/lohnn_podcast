import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class LongPressSwipeMenu<T> extends StatefulWidget {
  final IconData initialIcon;
  final VoidCallback onPressed;
  final String tooltip;
  final List<SwipeOption<T>> options;
  final ValueChanged<T> onOptionPressed;

  const LongPressSwipeMenu({
    super.key,
    required this.initialIcon,
    required this.tooltip,
    required this.onPressed,
    required this.options,
    required this.onOptionPressed,
  });

  @override
  _LongPressSwipeMenuState<T> createState() => _LongPressSwipeMenuState<T>();
}

class SwipeOption<T> {
  final IconData icon;
  final T value;
  final String tooltip;

  // Use keys for hit testing
  final Key key;

  SwipeOption({required this.icon, required this.value, required this.tooltip})
    : key = GlobalKey();
}

class _LongPressSwipeMenuState<T> extends State<LongPressSwipeMenu<T>>
    with SingleTickerProviderStateMixin {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  int? _hoveredOptionIndex;

  // Animation related fields
  late AnimationController _animationController;
  List<Animation<double>> _fadeAnimations = [];
  List<Animation<Offset>> _slideAnimations = [];

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 150),
    );
    // Initialize animations based on current options
    _setupAnimations();
  }

  @override
  void didUpdateWidget(covariant LongPressSwipeMenu<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    // If the number of options changes, re-initialize the animations
    if (widget.options.length != oldWidget.options.length) {
      _setupAnimations();
    }
  }

  // Helper to create staggered animations
  void _setupAnimations() {
    _fadeAnimations = [];
    _slideAnimations = [];
    final count = widget.options.length;
    if (count == 0) return;

    // Calculate interval duration and step based on count and overlap
    const overlap = 0.2;
    // Effective count of intervals to fit within the duration
    final effectiveCount = 1.0 + (count - 1) * (1.0 - overlap);
    final singleDuration =
        (count > 1 && effectiveCount > 0) ? (1.0 / effectiveCount) : 1.0;

    for (var i = 0; i < count; i++) {
      final start = (i * singleDuration * (1.0 - overlap)).clamp(0.0, 1.0);
      final end = (start + singleDuration).clamp(0.0, 1.0);

      _fadeAnimations.add(
        Tween<double>(begin: 0.0, end: 1.0).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
      _slideAnimations.add(
        // Start slightly below (adjust Y offset as needed)
        Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _animationController,
            curve: Interval(start, end, curve: Curves.easeOut),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    _removeOverlay();
    super.dispose();
  }

  void _showOverlay(BuildContext context, Offset longPressPosition) {
    // Ensure previous overlay is removed and controller reset if gesture restarts quickly
    _removeOverlay();
    _animationController.reset();

    final overlay = Overlay.of(context);
    final theme = Theme.of(context);

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final optionsColumn = Column(
          verticalDirection: VerticalDirection.up,
          spacing: 8,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(widget.options.length, (index) {
            final option = widget.options[index];
            final isHovered = _hoveredOptionIndex == index;
            return SlideTransition(
              position: _slideAnimations[index],
              child: FadeTransition(
                opacity: _fadeAnimations[index],
                child: Container(
                  // Use the key for hit testing
                  key: option.key,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color:
                        isHovered ? theme.highlightColor : Colors.transparent,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                  child: Icon(option.icon, color: theme.colorScheme.primary),
                ),
              ),
            );
          }),
        );

        return AnimatedBuilder(
          animation: _animationController,
          builder: (context, _) {
            return Positioned(
              // Full width to contain follower
              width: MediaQuery.of(context).size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                // Offset above the target widget (adjust Y as needed)
                offset: const Offset(0, -8),
                // Anchor point on the target (IconButton)
                targetAnchor: Alignment.topCenter,
                // Anchor point on the follower (Overlay)
                followerAnchor: Alignment.bottomCenter,
                child: Center(
                  child: Material(
                    elevation: 4.0,
                    color: Theme.of(context).canvasColor,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: optionsColumn,
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    overlay.insert(_overlayEntry!);
    setState(() {
      _hoveredOptionIndex = null; // Initially nothing hovered
    });
    _animationController.forward(); // Start the animation sequence
  }

  void _removeOverlay() {
    _animationController.stop();
    _overlayEntry?.remove();
    _overlayEntry = null;
    // Don't reset hover index here, keep it for _selectOption if needed
    // We only need to reset visually / on next show
  }

  void _updateHover(Offset globalPosition) {
    if (_overlayEntry == null) {
      return;
    }

    int? currentlyHovered;
    for (var i = 0; i < widget.options.length; i++) {
      final key = widget.options[i].key as GlobalKey;
      final box = key.currentContext?.findRenderObject() as RenderBox?;
      if (box != null) {
        final position = box.localToGlobal(Offset.zero);
        final size = box.size;
        final rect = Rect.fromLTWH(
          position.dx,
          position.dy,
          size.width,
          size.height,
        );
        if (rect.contains(globalPosition)) {
          currentlyHovered = i;
          break;
        }
      }
    }

    if (currentlyHovered != _hoveredOptionIndex) {
      setState(() {
        _hoveredOptionIndex = currentlyHovered;
      });
      // Vibrate slightly on hover change if desired
      // HapticFeedback.lightImpact();
      _overlayEntry?.markNeedsBuild(); // Rebuild overlay to show hover effect
    }
  }

  void _selectOption() {
    final indexToSelect =
        _hoveredOptionIndex; // Capture index before removing overlay
    _removeOverlay(); // Hide the overlay first
    if (indexToSelect != null) {
      widget.onOptionPressed(widget.options[indexToSelect].value);
    }
    // Reset hover index after selection/removal is complete
    setState(() {
      _hoveredOptionIndex = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        // Pan gesture to show options
        onPanStart: (details) {
          _showOverlay(context, details.globalPosition);
          HapticFeedback.mediumImpact();
        },
        onPanUpdate: (details) {
          _updateHover(details.globalPosition);
        },
        onPanEnd: (details) {
          _updateHover(details.globalPosition); // Final check before selecting
          _selectOption();
        },
        onPanCancel: _removeOverlay,
        // Long press to show options
        onLongPressStart: (details) {
          _showOverlay(context, details.globalPosition);
          HapticFeedback.mediumImpact();
        },
        onLongPressMoveUpdate: (details) {
          _updateHover(details.globalPosition);
        },
        onLongPressEnd: (details) {
          _updateHover(details.globalPosition); // Final check before selecting
          _selectOption();
        },
        // User cancelled (e.g. moved finger too far away quickly, or context switch)
        onLongPressCancel: _removeOverlay,
        // Use a simple icon container instead of IconButton to avoid nested gesture detectors conflicts
        child: IconButton(
          tooltip: widget.tooltip,
          onPressed: widget.onPressed,
          icon: Icon(widget.initialIcon, color: theme.colorScheme.primary),
        ),
      ),
    );
  }
}
