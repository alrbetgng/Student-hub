# Student Hub — connected Supabase build

## What's connected
- Supabase project: `https://ymkcluytkkhvisahikop.supabase.co`
- Browser-safe publishable key is configured in `index.html`.
- `public.chat_messages` has Row Level Security (RLS) policies requiring an authenticated user.
- Realtime is enabled for `public.chat_messages`.
- Chat queries show the most recent five minutes and enforce a 300-character message limit.

## Run / host the website
1. Host `index.html` on an HTTPS static host you are allowed to use. The Supabase JavaScript client loads from `esm.sh`, so that domain must be reachable from the browser.
2. Open the hosted page and create an account with an email address and a unique password (at least 8 characters).
3. If Supabase requires email confirmation, open the confirmation email, then return and sign in.
4. Open **Live Chat**. Sign in on another browser/account to test messages appearing live.

## Security notes
- The frontend contains only the project's **publishable** key. Publishable keys are designed to be public; the database RLS policies protect data access.
- Never add a Supabase secret or `service_role` key to this HTML file.
- Account creation does **not** verify that a person is a student. Before sharing the site widely, configure invitation-only access or school-approved account provisioning in Supabase Auth.
- Signed-in users can read recent shared-chat messages, insert messages as their own Auth UID, and delete only their own messages. The client never receives a privileged database key.
- The five-minute rule limits messages visible in the chat query; it does not physically delete old rows from the database.
- Local notes remain saved only on that device. Mini-games and the embedded site viewer remain browser-side features.

## Database
The chat table, constraints, RLS policies, grants, and Realtime publication membership have already been applied to the new project. `schema.sql` is retained as a reproducible reference.
