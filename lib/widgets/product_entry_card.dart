import 'package:flutter/material.dart';
import 'package:football_shop/models/product_entry.dart';
import 'package:intl/intl.dart';

class ProductEntryCard extends StatelessWidget {
  final ProductEntry product;
  final VoidCallback onTap;

  const ProductEntryCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fields = product.fields;
    final textStyle = Theme.of(context).textTheme;

    final String imageUrl =
        'http://localhost:8000/proxy-image/?url=${Uri.encodeComponent(fields.thumbnail)}';

    final idr = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
    final intPrice = product.fields.price; // or product.price
    final priceText = idr.format(intPrice);

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Theme.of(context).cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            side: BorderSide(color: Colors.grey.shade800),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Thumbnail
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Image.network(
                    imageUrl,
                    height: 150,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 150,
                      color: Colors.grey[800],
                      child: const Center(child: Icon(Icons.broken_image)),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Title (name)
                Text(
                  fields.name,
                  style: textStyle.titleMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 6),

                // Category
                Text(
                  'Category: ${fields.category}',
                  style: textStyle.bodySmall,
                ),
                const SizedBox(height: 6),

                // Content preview (description)
                Text(
                  fields.description.length > 100
                      ? '${fields.description.substring(0, 100)}...'
                      : fields.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textStyle.bodySmall?.copyWith(color: Colors.grey[400]),
                ),
                const SizedBox(height: 6),

                // Featured indicator
                if (fields.isFeatured)
                  const Text(
                    'Featured',
                    style: TextStyle(
                      color: Colors.amber,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                // Price & stock row
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Price: $priceText',
                      style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600),
                    ),
                    Text(
                      'Stock: ${product.fields.stock}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
