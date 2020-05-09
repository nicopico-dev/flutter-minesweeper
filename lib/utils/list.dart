import 'dart:core';

extension ListPartition<T> on List<T> {
  List<List<T>> partition(int size) {
    List<List<T>> chunks = [];
    for (var i = 0; i < this.length; i += size) {
      chunks.add(this.sublist(i, i + size));
    }
    return chunks;
  }
}
