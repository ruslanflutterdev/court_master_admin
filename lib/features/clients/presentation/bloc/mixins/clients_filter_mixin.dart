import '../../../data/models/client_model.dart';
import '../clients_state.dart';

mixin ClientsFilterMixin {
  List<ClientModel> applyFiltersAndSearch(
    List<ClientModel> all,
    String query,
    ClientSegment segment,
    String? level,
    String? tag,
    String sortBy,
  ) {
    final filtered = all.where((c) {
      bool segmentMatch = true;
      if (segment == ClientSegment.debtors) {
        segmentMatch = c.balance < 0;
      } else if (segment == ClientSegment.deposit) {
        segmentMatch = c.balance > 0;
      } else if (segment == ClientSegment.sub) {
        segmentMatch = (c.activeSubscriptionsCount ?? 0) > 0;
      } else if (segment == ClientSegment.rent) {
        segmentMatch =
            c.hasRent || c.tags.any((t) => t.toLowerCase() == 'аренда');
      }

      bool searchMatch = true;
      if (query.isNotEmpty) {
        final lowerQuery = query.toLowerCase();
        final fullName = '${c.firstName} ${c.lastName}'.toLowerCase();
        searchMatch =
            fullName.contains(lowerQuery) ||
            (c.phone ?? '').toLowerCase().contains(lowerQuery) ||
            (c.email ?? '').toLowerCase().contains(lowerQuery);
      }

      bool levelMatch = true;
      if (level != null && level != 'Все') {
        levelMatch = c.skillLevel == level;
      }

      bool tagMatch = true;
      if (tag != null && tag != 'Все') {
        tagMatch = c.tags.contains(tag);
      }

      return segmentMatch && searchMatch && levelMatch && tagMatch;
    }).toList();

    filtered.sort((a, b) {
      if (sortBy == 'debt') {
        return a.balance.compareTo(b.balance);
      } else if (sortBy == 'spent') {
        return b.totalSpent.compareTo(a.totalSpent);
      } else {
        int nameComp = a.firstName.compareTo(b.firstName);
        if (nameComp != 0) return nameComp;
        return (a.lastName).compareTo(b.lastName);
      }
    });

    return filtered;
  }
}
