import 'package:e_learning_management_system/models/CourseMaterial.dart';
import 'package:e_learning_management_system/screens/YoutubePlayerScreen%20.dart';
import 'package:e_learning_management_system/services/CourseMaterialService.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_iframe/youtube_player_iframe.dart';

class StudentCourseMaterialsPage extends StatelessWidget {
  final int courseId;
  const StudentCourseMaterialsPage({super.key, required this.courseId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Course Materials')),
      body: FutureBuilder<List<CourseMaterial>>(
        future: CourseMaterialService().fetchMaterialsByCourse(courseId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final materials = snapshot.data ?? [];
          final videoMaterials = materials
              .where((m) => m.type == 'VIDEO')
              .toList();

          if (videoMaterials.isEmpty) {
            return const Center(child: Text("No videos available"));
          }

          return Padding(
            padding: const EdgeInsets.all(12.0),
            child: SizedBox(
              height: 220, // Thumbnail + Title height
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: videoMaterials.length,
                itemBuilder: (context, index) {
                  final material = videoMaterials[index];
                  final videoId = YoutubePlayerController.convertUrlToId(
                    material.url,
                  );

                  if (videoId == null) {
                    return const SizedBox.shrink();
                  }

                  return Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(12),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                YoutubePlayerScreen(videoUrl: material.url),
                          ),
                        );
                      },
                      child: Container(
                        width: 320,
                        margin: const EdgeInsets.only(right: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.25),
                              blurRadius: 8,
                              spreadRadius: 2,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                // Thumbnail Image
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(
                                    top: Radius.circular(12),
                                  ),
                                  child: Image.network(
                                    'https://img.youtube.com/vi/$videoId/0.jpg',
                                    width: double.infinity,
                                    height: 180,
                                    fit: BoxFit.cover,
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null) {
                                            return child;
                                          }
                                          return Container(
                                            width: double.infinity,
                                            height: 180,
                                            color: Colors.grey[300],
                                            child: const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            ),
                                          );
                                        },
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        width: double.infinity,
                                        height: 180,
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.broken_image,
                                          size: 50,
                                          color: Colors.grey,
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                // Play Icon Overlay
                                Positioned.fill(
                                  child: Center(
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: Colors.black45,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Padding(
                                        padding: EdgeInsets.all(12.0),
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 48,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),

                            // Title padding & text
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                material.title,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
