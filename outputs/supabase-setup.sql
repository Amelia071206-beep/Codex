-- Run this whole file once in Supabase: SQL Editor → New query → Run.
create table if not exists public.bullet_messages (
  id bigint generated always as identity primary key,
  content text not null check (char_length(content) between 1 and 42),
  created_at timestamptz not null default now()
);

alter table public.bullet_messages enable row level security;

create policy "Anyone can read the wall"
on public.bullet_messages for select
to anon
using (true);

create policy "Anyone can post a short message"
on public.bullet_messages for insert
to anon
with check (char_length(content) between 1 and 42);

-- Enable instant updates for every open page.
alter publication supabase_realtime add table public.bullet_messages;
