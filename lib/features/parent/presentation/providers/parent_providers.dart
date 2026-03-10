import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../services/auth_service.dart';

/// Provider for the auth service used in onboarding screens.
final authServiceProvider = Provider<AuthService>((_) => AuthService());
