import 'package:audiobookshelf/constants/app_constants.dart';
import 'package:audiobookshelf/repositories/media/media_repository.dart';
import 'package:audiobookshelf/domain/collections/collections_state.dart';
import 'package:audiobookshelf/providers.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

final collectionsStateProvider =
    StateNotifierProvider<CollectionsNotifier, CollectionsState>((ref) {
  return CollectionsNotifier(ref.watch(mediaRepositoryProvider));
});

class CollectionsNotifier extends StateNotifier<CollectionsState> {
  final MediaRepository? _repository;

  CollectionsNotifier(this._repository)
      : super(const CollectionsState.initial()) {
    getCollections();
  }

  Future<void> getCollections() async {
    try {
      state = const CollectionsState.loading();
      final collections = await _repository!.getChildren(
        MediaIds.COLLECTIONS_ID,
      );
      state = CollectionsState.loaded(collections: collections);
    } on Exception {
      state = const CollectionsState.error(
          "Couldn't fetch authors. Is the device online?");
    }
  }

  Future<void> refresh() async {
    try {
      final collections = await _repository!.getChildren(
        MediaIds.COLLECTIONS_ID,
      );
      state = CollectionsState.loaded(collections: collections);
    } on Exception {
      state = const CollectionsState.error(
          "Couldn't fetch authors. Is the device online?");
    }
  }
}
