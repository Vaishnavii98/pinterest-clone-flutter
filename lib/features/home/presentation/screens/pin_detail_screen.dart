import 'package:flutter/material.dart';
import 'package:pinterest_clone/features/home/data/models/photo_model.dart';
import 'package:pinterest_clone/features/home/presentation/provider/saved_provider.dart';
import 'package:provider/provider.dart';

class PinDetailScreen extends StatefulWidget {
  final PhotoModel photo;

  const PinDetailScreen({super.key, required this.photo});

  @override
  State<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends State<PinDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final savedProvider = context.watch<SavedProvider>();
final isSaved = savedProvider.isSaved(widget.photo);
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  Hero(
                    tag: widget.photo.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        widget.photo.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      widget.photo.photographer,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      "Some description about this pin. This can be replaced later with actual data.",
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 100),
                ],
              ),
            ),

            // Back Button
            Positioned(
              top: 10,
              left: 10,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

Positioned(
  bottom: 20,
  right: 20,
  child: ElevatedButton(
    style: ElevatedButton.styleFrom(
      backgroundColor: isSaved ? Colors.grey : Colors.red,
      padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30),
      ),
    ),
onPressed: () {
  savedProvider.toggleSave(widget.photo);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        isSaved ? "Removed from saved" : "Saved to profile",
      ),
      duration: const Duration(seconds: 1),
    ),
  );
},
    child: Text(
      isSaved ? "Saved" : "Save",
      style: const TextStyle(fontSize: 16),
    ),
  ),
),
          ],
        ),
      ),
    );
  }
}