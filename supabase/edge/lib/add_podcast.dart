import 'package:edge_http_client/edge_http_client.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_functions/supabase_functions.dart';

void main() {
  final supabase = SupabaseClient(
    Deno.env.get('SUPABASE_URL')!,
    // Use service role key to bypass RLS
    Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!,
    httpClient: EdgeHttpClient(),
  );

  SupabaseFunctions(fetch: (request) {
    return Response("Hello from Supabase Edge Functions!");
  });
}
