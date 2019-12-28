import 'package:meta/meta.dart';
import 'package:artemis/schema/graphql_query.dart';
import 'package:json_annotation/json_annotation.dart';

enum FetchPolicy {
  /// Return result from cache. Only fetch from network if cached result is not available.
  ///
  /// Default
  CacheFirst,

  /// Return result from cache first (if it exists), then return network result once it's available.
  CacheAndNetwork,

  /// Return result from network, fail if network call doesn't succeed, save to cache
  NetworkOnly,

  /// Return result from cache if available, fail otherwise.
  CacheOnly,

  /// Return result from network, fail if network call doesn't succeed, don't save to cache
  NoCache,
}

@immutable
class QueryEvent<T, TVariables extends JsonSerializable> {
  /// The unique identifier of the originating `QueryRef`.
  final String refId;

  /// The GraphQL Query, Mutation, or Subscription to execute.
  final GraphQLQuery<T, TVariables> query;

  /// Optional function to update the result based on the previous result. Useful
  /// for pagination.
  final T Function(T previousResult, T result) updateResult;

  /// The optimistic result, generally used when running a mutation
  final Map<String, Object> optimisticResponse;

  /// The key that maps to a `UpdateCacheHandler`, defined on the client
  final dynamic updateCacheHandlerKey;

  /// Object that gets passed This object gets passed as a parameter to `UpdateFunctionHandler` and `UpdateResultHandler`.
  final Map<String, dynamic> updateHandlerContext;

  final FetchPolicy fetchPolicy;

  QueryEvent(
      {@required this.refId,
      @required this.query,
      this.updateResult,
      this.updateHandlerContext,
      this.optimisticResponse,
      this.updateCacheHandlerKey,
      this.fetchPolicy});
}