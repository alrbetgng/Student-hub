-- Student Hub: secure starter schema for Supabase
-- IMPORTANT:
-- The shared PIN "2014" is not authentication. Do not create public/anon read-write
-- policies for chat. This schema allows only signed-in Supabase Auth users to access chat.
-- Add invite-only account provisioning before you launch to actual students.

create table if not exists public.chat_messages (
  id bigint generated always as identity primary key,
  user_id uuid not null references auth.users(id) on delete cascade,
  display_name text not null check (char_length(display_name) between 1 and 24),
  body text not null check (char_length(body) between 1 and 300),
  created_at timestamptz not null default now()
);

create index if not exists chat_messages_created_at_idx
  on public.chat_messages (created_at desc);

alter table public.chat_messages enable row level security;

-- Remove any older permissive policies on this table before applying these.
drop policy if exists "Signed-in users can read recent chat" on public.chat_messages;
drop policy if exists "Signed-in users can send as themselves" on public.chat_messages;
drop policy if exists "Users can delete their own messages" on public.chat_messages;

create policy "Signed-in users can read recent chat"
on public.chat_messages
for select
to authenticated
using (created_at > now() - interval '5 minutes');

create policy "Signed-in users can send as themselves"
on public.chat_messages
for insert
to authenticated
with check (
  auth.uid() = user_id
  and char_length(display_name) between 1 and 24
  and char_length(body) between 1 and 300
  and created_at > now() - interval '1 minute'
);

create policy "Users can delete their own messages"
on public.chat_messages
for delete
to authenticated
using (auth.uid() = user_id);

-- Restrict direct access to the roles that should use the Data API.
revoke all on table public.chat_messages from anon;
grant select, insert, delete on table public.chat_messages to authenticated;
grant usage, select on sequence public.chat_messages_id_seq to authenticated;

-- Realtime: in Supabase Dashboard > Database > Replication, enable Realtime
-- for public.chat_messages if you choose to wire live subscriptions in the frontend.
--
-- Expiry note:
-- The SELECT policy hides messages older than 5 minutes, but does not physically
-- delete them. For actual deletion, configure a scheduled cleanup job (pg_cron) or
-- run a trusted server-side cleanup task. Never rely on a client timer for security.
