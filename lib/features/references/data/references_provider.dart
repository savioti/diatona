import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/music_reference.dart';
import 'references_repository.dart';

final musicReferencesProvider = FutureProvider<List<MusicReference>>(
  (_) => loadMusicReferences(),
);
