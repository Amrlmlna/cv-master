import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../../../../domain/entities/banner_ad.dart';
import '../../../../data/datasources/remote_banner_datasource.dart';
import '../../../../data/repositories/banner_repository_impl.dart';

// Tracks whether the feedback CTA banner has been dismissed by the user.
// Resets to false on app restart (in-memory only, no persistence needed).
final feedbackBannerDismissedProvider = StateProvider<bool>((ref) => false);

final bannerRepositoryProvider = Provider<BannerRepositoryImpl>((ref) {
  return BannerRepositoryImpl(
    remoteDataSource: RemoteBannerDataSource(client: http.Client()),
  );
});

final bannerProvider = FutureProvider<List<BannerAd>>((ref) async {
  final repository = ref.watch(bannerRepositoryProvider);
  return repository.getActiveBanners();
});
