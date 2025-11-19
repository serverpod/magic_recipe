import 'package:serverpod/serverpod.dart';

/// Base class for admin endpoints that require authentication and admin scope.
abstract class AdminEndpointBase extends Endpoint {
  @override
  bool get requireLogin => true;

  @override
  Set<Scope> get requiredScopes => {Scope.admin};
}

