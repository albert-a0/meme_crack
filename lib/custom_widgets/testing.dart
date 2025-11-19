import 'dart:ui';

import 'package:flutter/material.dart';

class Testing extends StatefulWidget{
  Color textColor;
  Color color;
  Function refresher;
  Testing({super.key,required this.textColor,required this.color,required this.refresher});

  @override
  State<Testing> createState() => _TestingState();
}

class _TestingState extends State<Testing> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.refresher(widget.color);
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
          border: Border.all(
            color: widget.textColor == widget.color ? Colors.purple : Colors.grey,
            width: widget.textColor == widget.color ? 3 : 1,
          ),
        ),
      ),
    );
  }
}