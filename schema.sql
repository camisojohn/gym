-- Run this once in Supabase: SQL Editor > New query > paste > Run

create table public.sets (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  performed_on date not null default current_date,
  day int not null,
  exercise text not null,
  set_no int not null,
  kg numeric(6,2) not null,
  reps int not null,
  unique (user_id, performed_on, exercise, set_no)
);

create table public.weights (
  id bigint generated always as identity primary key,
  user_id uuid not null default auth.uid() references auth.users(id) on delete cascade,
  logged_on date not null default current_date,
  kg numeric(5,2) not null,
  unique (user_id, logged_on)
);

alter table public.sets enable row level security;
alter table public.weights enable row level security;

-- Each person can only see and change their own rows
create policy "own sets" on public.sets for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
create policy "own weights" on public.weights for all
  using (user_id = auth.uid()) with check (user_id = auth.uid());
