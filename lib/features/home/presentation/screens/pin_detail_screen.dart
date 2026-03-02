import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pinterest_clone/features/home/presentation/provider/saved_provider.dart';
import 'package:pinterest_clone/features/home/presentation/widgets/pinterest_loader.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../data/models/photo_model.dart';
import '../../data/services/pexels_service.dart';

class PinDetailScreen extends StatefulWidget {
  final PhotoModel photo;

  const PinDetailScreen({super.key, required this.photo});

  @override
  State<PinDetailScreen> createState() => _PinDetailScreenState();
}

class _PinDetailScreenState extends State<PinDetailScreen> {
  final PexelsService _service = PexelsService();
  List<PhotoModel> related = [];
  bool isLoadingRelated = true;

  @override
  void initState() {
    super.initState();
    _loadRelated();
  }
Future<void> _loadRelated() async {
  try {
    List<PhotoModel> result = [];

    if (widget.photo.alt.isNotEmpty) {
      result = await _service.searchPhotos(
        widget.photo.alt.split(" ").first,
      );
    }

    if (result.isEmpty) {
      result = await _service.fetchCuratedPhotos(page: 2);
    }

    result.removeWhere((p) => p.id == widget.photo.id);

    setState(() {
      related = result.take(10).toList();
      isLoadingRelated = false;
    });
  } catch (e) {
    final fallback = await _service.fetchCuratedPhotos(page: 3);

    fallback.removeWhere((p) => p.id == widget.photo.id);

    setState(() {
      related = fallback.take(10).toList();
      isLoadingRelated = false;
    });
  }
}

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
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Hero(
                      tag: widget.photo.id,
                      child: CachedNetworkImage(
                        imageUrl: widget.photo.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.favorite_border_rounded),
                      const SizedBox(width: 16,),
                      const Icon(Icons.share_outlined),
                      const SizedBox(width: 16),
                      const Icon(Icons.comment_outlined),
                      const SizedBox(width: 16),
                      const Icon(Icons.more_horiz),
                      const Spacer(),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaved ? Colors.grey : Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        onPressed: () {
                          savedProvider.toggleSave(widget.photo);
                        },
                        child: Text(isSaved ? "Saved" : "Save",
                        style: TextStyle(color: isSaved? Color.fromRGBO(1, 1, 1, 1) : Color.fromRGBO(255, 255, 255, 1)),),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.photo.photographer,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    widget.photo.alt.isNotEmpty
                        ? widget.photo.alt
                        : "Inspiration curated from visual discovery.",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    "More like this",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  if (isLoadingRelated)
                    const Center(
                        child: SizedBox(
                      child: PinterestLoader(
                        size: 45,
                      ),
                    ))
                  else
                    MasonryGridView.count(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisCount: 2,
                      mainAxisSpacing: 12,
                      crossAxisSpacing: 12,
                      itemCount: related.length,
                      itemBuilder: (context, index) {
                        final photo = related[index];

                        return ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: CachedNetworkImage(
                            imageUrl: photo.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: CircleAvatar(
                backgroundColor: Colors.white.withOpacity(0.85),
                child: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
