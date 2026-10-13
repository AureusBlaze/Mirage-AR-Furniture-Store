import 'package:flutter/material.dart';
import 'package:flutter_embed_unity/flutter_embed_unity.dart';

/// Simple full-screen AR preview that sends a model URL to Unity.
class ProductArScreen extends StatefulWidget {
  final String modelUrl;

  const ProductArScreen({super.key, required this.modelUrl});

  @override
  State<ProductArScreen> createState() => _ProductArScreenState();
}

class _ProductArScreenState extends State<ProductArScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(seconds: 5));
      sendToUnity('GLBManager', 'ReceiveGlbUrl', widget.modelUrl);
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR Preview')),
      body: SafeArea(
        child: Column(children: [Expanded(child: EmbedUnity())]),
      ),
    );
  }
}
