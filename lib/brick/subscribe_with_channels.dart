import 'dart:async';

import 'package:brick_offline_first/brick_offline_first.dart';
import 'package:brick_offline_first_with_supabase/brick_offline_first_with_supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

mixin SubscribeWithChannels on OfflineFirstWithSupabaseRepository {
  @override
  Stream<List<TModel>> subscribe<TModel extends OfflineFirstWithSupabaseModel>({
    OfflineFirstGetPolicy policy = OfflineFirstGetPolicy.localOnly,
    Query? query,
  }) {
    query ??= Query();
    if (subscriptions[TModel]?[query] != null) {
      return subscriptions[TModel]![query]!.stream as Stream<List<TModel>>;
    }

    final adapter = remoteProvider.modelDictionary.adapterFor[TModel]!;

    if (policy == OfflineFirstGetPolicy.localOnly) {
      return super.subscribe<TModel>(policy: policy, query: query);
    }

    final channel = remoteProvider.client
        .channel(adapter.supabaseTableName)
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: adapter.supabaseTableName,
          callback: (payload) async {
            final event = payload.eventType;
            final record = payload.newRecord;

            switch (event) {
              case PostgresChangeEvent.insert:
              case PostgresChangeEvent.update:
                final instance = await adapter.fromSupabase(record,
                    provider: remoteProvider);
                await upsert<TModel>(
                  instance as TModel,
                );
                break;
              case PostgresChangeEvent.delete:
                final instance = await adapter.fromSupabase(record,
                    provider: remoteProvider);
                await delete<TModel>(instance as TModel);
                break;
              default:
            }
          },
        )
        .subscribe();

    final controller = StreamController<List<TModel>>(
      onCancel: () async {
        await channel.unsubscribe();
        await subscriptions[TModel]?[query]?.close();
        subscriptions[TModel]?.remove(query);
        if (subscriptions[TModel]?.isEmpty ?? false) {
          subscriptions.remove(TModel);
        }
      },
    );

    subscriptions[TModel] ??= {};
    subscriptions[TModel]?[query] = controller;

    // Fetch initial data
    get<TModel>(query: query, policy: policy).then((results) {
      if (!controller.isClosed) controller.add(results);
    });

    return controller.stream;
  }
}
