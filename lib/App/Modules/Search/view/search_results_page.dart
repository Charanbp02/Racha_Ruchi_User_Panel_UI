// App/Modules/Search/view/search_results_page.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:racharuchi/App/Modules/Search/widgets/empty_search_state.dart';
import 'package:racharuchi/App/Modules/Search/widgets/filter_dialog.dart';
import 'package:racharuchi/App/Modules/Search/widgets/search_result_item.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    final String query = arguments?['query'] ?? '';
    final List<Map<String, dynamic>> results =
        (arguments?['results'] as List?)?.cast<Map<String, dynamic>>() ?? [];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(context, query, results.length),
      body:
          results.isEmpty
              ? const EmptySearchState()
              : ListView.builder(
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                itemCount: results.length,
                itemBuilder: (context, index) {
                  return SearchResultItem(item: results[index]);
                },
              ),
    );
  }

  PreferredSizeWidget _buildAppBar(
    BuildContext context,
    String query,
    int resultCount,
  ) {
    return AppBar(
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Search results',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          Text(
            '$resultCount results for "$query"',
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        IconButton(
          icon: const Icon(Iconsax.filter),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              builder: (BuildContext context) => const FilterDialog(),
            );
          },
        ),
      ],
    );
  }
}
