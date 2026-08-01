// App/Modules/Search/view/search_bar_view.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:racharuchi/App/Modules/Search/controller/search_controller.dart';
import 'package:racharuchi/App/Modules/Search/widgets/compact_search_bar.dart';
import 'package:racharuchi/App/Modules/Search/widgets/full_screen_search_bar.dart';

class SearchBarView extends StatefulWidget {
  final double height;
  final String hintText;
  final VoidCallback? onFilterTap;
  final bool fullScreen;

  const SearchBarView({
    super.key,
    this.height = 50,
    this.hintText = 'Search recipes videos...',
    this.onFilterTap,
    this.fullScreen = false,
  });

  @override
  State<SearchBarView> createState() => _SearchBarViewState();
}

class _SearchBarViewState extends State<SearchBarView> {
  late SearchBarController controller;
  late TextEditingController _textEditingController;
  Worker? _queryWorker;

  @override
  void initState() {
    super.initState();
    controller = Get.put(SearchBarController());
    _textEditingController = TextEditingController();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _queryWorker = ever(controller.query, (String? value) {
          if (mounted && _textEditingController.text != (value ?? '')) {
            _textEditingController.text = value ?? '';
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _queryWorker?.dispose();
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.fullScreen
        ? FullScreenSearchBar(
          controller: controller,
          textEditingController: _textEditingController,
          hintText: widget.hintText,
        )
        : CompactSearchBar(
          height: widget.height,
          hintText: widget.hintText,
          onFilterTap: widget.onFilterTap,
        );
  }
}
