import 'package:flutter/material.dart';

import '../models/interface/has_title_and_image.dart';

class CoverAppbar extends StatelessWidget{
  final HasTitleAndImage item;
  const CoverAppbar({super.key, required this.item});
  @override
  Widget build(BuildContext context) {
    final title = item.displayTitle;
    final imageUrl = item.displayImageUrl;

    return SliverAppBar(
      expandedHeight: 300,
      pinned: true,
      flexibleSpace: LayoutBuilder(
        builder: (context, constraints) {
          var top = constraints.biggest.height;
          return FlexibleSpaceBar(
            title: top <= kToolbarHeight + 50
                ? Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            )
                : null,
            background: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(24),
                  ),
                  child: Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.image,
                        size: 120,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ),
                if (top > kToolbarHeight + 50)
                  Positioned(
                    left: 16,
                    bottom: 16,
                    child: Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            blurRadius: 8,
                            color: Colors.black54,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
