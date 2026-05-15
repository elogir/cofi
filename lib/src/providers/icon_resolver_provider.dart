import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../icon/icon_resolver.dart';

part 'icon_resolver_provider.g.dart';

@Riverpod(keepAlive: true)
Future<IconResolver> iconResolver(Ref ref) {
  return IconResolver.create();
}
