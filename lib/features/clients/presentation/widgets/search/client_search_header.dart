import 'package:flutter/material.dart';
import '../../bloc/clients_state.dart';
import 'client_search_bar.dart';
import 'client_filters_row.dart';
import 'client_segments_bar.dart';

class ClientSearchHeader extends StatelessWidget {
  final ValueChanged<String> onSearchChanged;
  final ClientSegment selectedSegment;
  final ValueChanged<ClientSegment> onSegmentChanged;

  const ClientSearchHeader({
    super.key,
    required this.onSearchChanged,
    required this.selectedSegment,
    required this.onSegmentChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClientSearchBar(onChanged: onSearchChanged),
        const ClientFiltersRow(),
        ClientSegmentsBar(
          selectedSegment: selectedSegment,
          onSegmentChanged: onSegmentChanged,
        ),
      ],
    );
  }
}
