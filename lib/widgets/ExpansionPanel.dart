// ignore: file_names
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// A single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].
///
/// This widget is typically used with [ListView] to create an
/// "expand / collapse" list entry. When used with scrolling widgets like
/// [ListView], a unique [PageStorageKey] must be specified to enable the
/// [ExpansionTile] to save and restore its expanded state when it is scrolled
/// in and out of view.
const Duration _kExpand = const Duration(milliseconds: 200);

/// Creates a single-line [ListTile] with a trailing button that expands or collapses
/// the tile to reveal or hide the [children].

class AppExpansionTile extends StatefulWidget {
  const AppExpansionTile({
    Key? key,
    this.leading,
    @required this.title,
    this.backgroundColor,
    this.onExpansionChanged,
    this.children: const <Widget>[],
    this.trailing,
    this.initiallyExpanded: false,
  })  : assert(initiallyExpanded != null),
        super(key: key);

  /// A widget to display before the title.
  final Widget? leading;
  final Widget? title;

  /// When the tile starts expanding, this function is called with the value
  /// `true`. When the tile starts collapsing, this function is called with
  /// the value false.
  final ValueChanged<bool>? onExpansionChanged;
  final List<Widget>? children;
  final Color? backgroundColor;
  final Widget? trailing;
  final bool? initiallyExpanded;

  @override
  AppExpansionTileState createState() => AppExpansionTileState();
}

class AppExpansionTileState extends State<AppExpansionTile>
    with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  late CurvedAnimation _easeOutAnimation;
  late CurvedAnimation _easeInAnimation;
  ColorTween? _borderColor;
  ColorTween? _headerColor;
  ColorTween? _iconColor;

  /// The color to display behind the sublist when expanded.
  ColorTween? _backgroundColor;
  Animation<double>? _iconTurns;

  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: _kExpand, vsync: this);
    _easeOutAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeOut);
    _easeInAnimation =
        CurvedAnimation(parent: _controller!, curve: Curves.easeIn);
    _borderColor = ColorTween();
    _headerColor = ColorTween();
    _iconColor = ColorTween();
    _iconTurns = Tween<double>(begin: 0.0, end: 0.5).animate(_easeInAnimation);
    _backgroundColor = ColorTween();

    _isExpanded =
        PageStorage.of(context)?.readState(context) ?? widget.initiallyExpanded;
    if (_isExpanded) _controller!.value = 1.0;
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  void expand() {
    _setExpanded(true);
  }

  void collapse() {
    _setExpanded(false);
  }

  void toggle() {
    _setExpanded(!_isExpanded);
  }

  void _setExpanded(bool isExpanded) {
    if (_isExpanded != isExpanded) {
      setState(() {
        _isExpanded = isExpanded;
        if (_isExpanded)
          _controller!.forward();
        else
          // Rebuild without widget.children.
          _controller!.reverse();
        PageStorage.of(context)?.writeState(context, _isExpanded);
      });
      if (widget.onExpansionChanged != null) {
        widget.onExpansionChanged!(_isExpanded);
      }
    }
  }

  Widget _buildChildren(BuildContext? context, Widget? child) {
    final Color borderSideColor = Colors.transparent;
    final Color? titleColor = _headerColor!.evaluate(_easeInAnimation);

    return Container(
      decoration: BoxDecoration(
          color: _backgroundColor!.evaluate(_easeOutAnimation) ??
              Colors.transparent,
          border: Border(
            top: BorderSide(color: borderSideColor),
            bottom: BorderSide(color: borderSideColor),
          )),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          IconTheme.merge(
            data: IconThemeData(color: _iconColor!.evaluate(_easeInAnimation)),
            child: ListTile(
              onTap: toggle,
              // leading: widget.leading,
              title: DefaultTextStyle(
                style: Theme.of(context!)
                    .textTheme
                    .headline1!
                    .copyWith(color: titleColor),
                child: widget.title!,
              ),
              trailing: widget.trailing ??
                  RotationTransition(
                    turns: _iconTurns!,
                    child: const Icon(Icons.expand_more),
                  ),
            ),
          ),
          ClipRect(
            child: Align(
              heightFactor: _easeInAnimation.value,
              child: child,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    _borderColor!.end = theme.dividerColor;
    _headerColor!
      ..begin = theme.textTheme.subtitle1!.color
      ..end = theme.accentColor;
    _iconColor!
      ..begin = theme.unselectedWidgetColor
      ..end = theme.accentColor;
    _backgroundColor!.end = widget.backgroundColor;

    final bool closed = !_isExpanded && _controller!.isDismissed;
    return AnimatedBuilder(
      animation: _controller!.view,
      builder: _buildChildren,
      child: closed ? null : Column(children: widget.children!),
    );
  }
}
