import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_crack/custom_widgets/meme_preview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../custom_widgets/testing.dart';

class MemeGeneratorScreen extends StatefulWidget {
  const MemeGeneratorScreen({Key? key}) : super(key: key);

  @override
  State<MemeGeneratorScreen> createState() => _MemeGeneratorScreenState();
}
class _MemeGeneratorScreenState extends State<MemeGeneratorScreen> {
  File? _imageFile;
  final TextEditingController _topTextController = TextEditingController();
  final TextEditingController _bottomTextController = TextEditingController();
  final ImagePicker _picker = ImagePicker();
  final GlobalKey _globalKey = GlobalKey();

  double _topTextSize = 32.0;
  double _bottomTextSize = 32.0;
  Color _textColor = Colors.white;
  bool _showBorder = true;

  @override
  void dispose() {
    _topTextController.dispose();
    _bottomTextController.dispose();
    super.dispose();
  }

  void refresher(Color cc) {
    setState((){
      _textColor = cc;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      _showSnackBar('Error picking image: \$e');
    }
  }

  Future<void> _shareMeme() async {
    try {
      // 1. Capture the widget as an image
      RenderRepaintBoundary boundary = _globalKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData? byteData = await image.toByteData(
          format: ui.ImageByteFormat.png);
      Uint8List pngBytes = byteData!.buffer.asUint8List();

      // 2. Get a temporary directory
      final tempDir = await getTemporaryDirectory();
      final file = await File('''\${tempDir.path}/meme.png''').writeAsBytes(
          pngBytes);

      // 3. Use share_plus to open the share sheet
      await Share.shareXFiles(
          [XFile(file.path)], text: 'Check out my new meme!');
    } catch (e) {
      _showSnackBar('Error sharing meme: \$e');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _showImageSourceDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Choose Image Source'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.gallery);
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage(ImageSource.camera);
                  },
                ),
              ],
            ),
          ),
    );
  }

  void _showSettingsDialog() {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Text Settings'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Top Text Size'),
                  Slider(
                    value: _topTextSize,
                    min: 16,
                    max: 64,
                    divisions: 24,
                    label: _topTextSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _topTextSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Bottom Text Size'),
                  Slider(
                    value: _bottomTextSize,
                    min: 16,
                    max: 64,
                    divisions: 24,
                    label: _bottomTextSize.round().toString(),
                    onChanged: (value) {
                      setState(() {
                        _bottomTextSize = value;
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  const Text('Text Color'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Testing(textColor: _textColor, color: Colors.white),
                      // Testing(textColor: _textColor, color: Colors.black),
                      // Testing(textColor: _textColor, color: Colors.red),
                      // Testing(textColor: _textColor, color: Colors.blue),
                      _colorButton(Colors.white),
                      _colorButton(Colors.red),
                      _colorButton(Colors.blue),
                      _colorButton(Colors.green),
                      _colorButton(Colors.deepOrangeAccent),
                    ],
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    title: const Text('Text Border'),
                    value: _showBorder,
                    onChanged: (value) {
                      setState(() {
                        _showBorder = value;
                      });
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Done'),
              ),
            ],
          ),
    );
  }



  Widget _colorButton(Color color) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _textColor = color;
        });
      },
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: _textColor == color ? Colors.purple : Colors.grey,
            width: _textColor == color ? 3 : 1,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meme Generator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showSettingsDialog,
            tooltip: 'Text Settings',
          ),
          if (_imageFile != null)
            IconButton(
              icon: const Icon(Icons.share),
              onPressed: _shareMeme,
              tooltip: 'Share Meme',
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Meme Preview
            MemePreview(
              globalKey: _globalKey,
              imageFile: _imageFile,
              topText: _topTextController.text,
              bottomText: _bottomTextController.text,
              topTextSize: _topTextSize,
              bottomTextSize: _bottomTextSize,
              textColor: _textColor,
              showBorder: _showBorder,
            ),
            const SizedBox(height: 16),

            // Text inputs
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    controller: _topTextController,
                    decoration: const InputDecoration(
                      labelText: 'Top Text',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _bottomTextController,
                    decoration: const InputDecoration(
                      labelText: 'Bottom Text',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.text_fields),
                    ),
                    onChanged: (value) => setState(() {}),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: _showImageSourceDialog,
                      icon: const Icon(Icons.add_photo_alternate),
                      label: Text(_imageFile == null
                          ? 'Select Image'
                          : 'Change Image'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
