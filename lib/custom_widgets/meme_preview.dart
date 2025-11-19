import 'dart:io';
import 'package:flutter/material.dart';

class MemePreview extends StatelessWidget {
  final GlobalKey globalKey;
  final File? imageFile;
  final String topText;
  final String bottomText;
  final double topTextSize;
  final double bottomTextSize;
  final Color textColor;
  final bool showBorder;

  const MemePreview({
    Key? key,
    required this.globalKey,
    required this.imageFile,
    required this.topText,
    required this.bottomText,
    required this.topTextSize,
    required this.bottomTextSize,
    required this.textColor,
    required this.showBorder,
  }) : super(key: key);

  Widget _buildMemeText(String text, double fontSize) {
    return Text(
      text.toUpperCase(),
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        color: textColor,
        letterSpacing: 2,
        shadows: showBorder
            ? [
                Shadow(
                  offset: const Offset(-2, -2),
                  color: textColor == Colors.white ? Colors.black : Colors.white,
                  blurRadius: 0,
                ),
                Shadow(
                  offset: const Offset(2, -2),
                  color: textColor == Colors.white ? Colors.black : Colors.white,
                  blurRadius: 0,
                ),
                Shadow(
                  offset: const Offset(-2, 2),
                  color: textColor == Colors.white ? Colors.black : Colors.white,
                  blurRadius: 0,
                ),
                Shadow(
                  offset: const Offset(2, 2),
                  color: textColor == Colors.white ? Colors.black : Colors.white,
                  blurRadius: 0,
                ),
              ]
            : [],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: Container(
        width: double.infinity,
        height: 400,
        color: Colors.grey[300],
        child: imageFile == null
            ? const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.image, size: 80, color: Colors.grey),
                    SizedBox(height: 16),
                    Text(
                      'No image selected',
                      style: TextStyle(fontSize: 18, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : Stack(
                fit: StackFit.expand,
                children: [
                  Image.file(
                    imageFile!,
                    fit: BoxFit.contain,
                  ),
                  // Top text
                  if (topText.isNotEmpty)
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildMemeText(
                          topText,
                          topTextSize,
                        ),
                      ),
                    ),
                  // Bottom text
                  if (bottomText.isNotEmpty)
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: _buildMemeText(
                          bottomText,
                          bottomTextSize,
                        ),
                      ),
                    ),
                ],
              ),
      ),
    );
  }
}
