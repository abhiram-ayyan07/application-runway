-- Application Runway — database schema
-- Run this once in your Supabase project's SQL Editor (Database → SQL Editor).
-- It creates the applications table and locks it down with row-level security
-- so each signed-in user can only ever see and edit their own rows.

create table public.applications (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  company text not null,
  role text not null,
  location text,
  link text,
  date_applied date not null,
  status text not null default 'applied' check (status in ('applied','interview','offer','rejected','withdrawn')),
  next_step text,
  follow_up_date date,
  notes text,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index applications_user_id_idx on public.applications (user_id);

alter table public.applications enable row level security;

-- Each user can only see their own applications.
create policy "select_own_applications" on public.applications
  for select using (auth.uid() = user_id);

-- Each user can only insert rows they own.
create policy "insert_own_applications" on public.applications
  for insert with check (auth.uid() = user_id);

-- Each user can only update their own rows.
create policy "update_own_applications" on public.applications
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Each user can only delete their own rows.
create policy "delete_own_applications" on public.applications
  for delete using (auth.uid() = user_id);

-- Keep updated_at current on every edit.
create or replace function public.set_updated_at()
returns trigger
language plpgsql
set search_path = ''
as $$
begin
  new.updated_at = now();
  return new;
end;
$$;

create trigger applications_set_updated_at
  before update on public.applications
  for each row execute function public.set_updated_at();
