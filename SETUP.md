# Student Hub v1 — setup guide

## Included files
- `index.html`: one-file responsive frontend with a shared-PIN demo gate, chat demo, mini-games, study tools, quick links, and a permitted-site iframe viewer.
- `schema.sql`: starter Supabase chat table and restrictive Row Level Security (RLS) policies.

## Important security truth
The requested shared PIN `2014` is embedded in the browser file, so anyone can inspect the source or share the PIN. It is **not secure student-only authentication**. The current chat is a local demo stored in the current browser session; it does not send messages to Supabase. This is deliberate: a public HTML file must not be allowed to read/write private chat merely because someone knows a shared PIN.

To make actual student-only shared chat, use Supabase Auth and provision accounts by invitation (or another school-approved process), then wire Auth sessions into the frontend. The SQL below restricts chat access to authenticated Supabase users and validates message ownership/length. Do not weaken it to `anon` access to make the shared PIN work.

## Run the prototype
1. Save `index.html` and open it in a browser.
2. Enter PIN `2014`.
3. Chat demo messages are only visible in the same browser session. Notes are stored locally on that device.
4. The web viewer only displays websites that permit iframe embedding. Many major sites block it; use the external link instead.

## Apply the Supabase schema
1. Open your Supabase project dashboard.
2. Go to **SQL Editor** and create a new query.
3. Paste the contents of `schema.sql` and run it.
4. In **Database → Replication** (or the Realtime settings available in your dashboard), enable Realtime for `public.chat_messages` if you want to use subscriptions.
5. Keep RLS enabled. Never put the `service_role` key or a secret API key in `index.html`.

## Before connecting live chat
The frontend needs a real Supabase Auth session. The shared PIN alone cannot create a trustworthy identity. Use invitation-only accounts or verified school accounts. Then add the project URL and publishable/anon key to the client, use `supabase.auth` to sign in, and implement select/insert/delete operations against `chat_messages`. Keep the policies in `schema.sql` and test with two accounts:
- Signed-out user: chat reads/writes should fail.
- Signed-in user A: can read recent messages and insert a message where `user_id` is their own Auth UID.
- User A cannot insert as user B.
- Messages older than five minutes should not appear in the chat query.
- Users cannot send messages longer than 300 characters.

## Google Sites embedding
Google Sites can embed a hosted webpage by URL, but it cannot reliably run a whole pasted application with all its scripts in every configuration. Recommended flow:
1. Host `index.html` on a static HTTPS host that permits your intended use.
2. In Google Sites choose **Insert → Embed → By URL** and paste the hosted page URL.
3. Test on both a school iPad and Chromebook. District filtering may block the host or features; don't try to evade school security controls.
4. If your school account blocks custom embeds, use an approved host or ask the district/teacher for permission.

## Limits and safety
- No backend proxy is included. An unrestricted proxy can expose student browsing data and can be abused to access internal services. This version includes only a browser iframe viewer for permitted websites.
- Do not collect real names, passwords, or personal details in public chat.
- Add moderation/reporting and a clear code of conduct before inviting other students.
