class SelectionResult<T> {
  final List<T> items;
  final int totalCount;
  final bool hasMore;
  final int currentPage;
  
  SelectionResult({
    required this.items,
    required this.totalCount,
    required this.hasMore,
    required this.currentPage,
  });
}