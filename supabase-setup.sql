create extension if not exists pgcrypto;

create table if not exists public.trip_plans (
  id uuid primary key default gen_random_uuid(),
  day_key text not null,
  plan text,
  food text,
  created_at timestamptz not null default now()
);

create index if not exists trip_plans_day_key_idx
  on public.trip_plans (day_key, created_at desc);

create table if not exists public.trip_phrases (
  day_key text primary key,
  nuria text,
  javi text,
  updated_at timestamptz not null default now()
);

create table if not exists public.trip_photos (
  day_key text primary key,
  photo_path text not null,
  updated_at timestamptz not null default now()
);

insert into storage.buckets (id, name, public)
values ('trip-photos', 'trip-photos', true)
on conflict (id) do update
set public = excluded.public;

alter table public.trip_plans enable row level security;
alter table public.trip_phrases enable row level security;
alter table public.trip_photos enable row level security;

drop policy if exists "public can read trip plans" on public.trip_plans;
create policy "public can read trip plans"
  on public.trip_plans
  for select
  to anon
  using (true);

drop policy if exists "public can insert trip plans" on public.trip_plans;
create policy "public can insert trip plans"
  on public.trip_plans
  for insert
  to anon
  with check (true);

drop policy if exists "public can update trip plans" on public.trip_plans;
create policy "public can update trip plans"
  on public.trip_plans
  for update
  to anon
  using (true)
  with check (true);

drop policy if exists "public can delete trip plans" on public.trip_plans;
create policy "public can delete trip plans"
  on public.trip_plans
  for delete
  to anon
  using (true);

drop policy if exists "public can read trip phrases" on public.trip_phrases;
create policy "public can read trip phrases"
  on public.trip_phrases
  for select
  to anon
  using (true);

drop policy if exists "public can insert trip phrases" on public.trip_phrases;
create policy "public can insert trip phrases"
  on public.trip_phrases
  for insert
  to anon
  with check (true);

drop policy if exists "public can update trip phrases" on public.trip_phrases;
create policy "public can update trip phrases"
  on public.trip_phrases
  for update
  to anon
  using (true)
  with check (true);

drop policy if exists "public can read trip photos" on public.trip_photos;
create policy "public can read trip photos"
  on public.trip_photos
  for select
  to anon
  using (true);

drop policy if exists "public can insert trip photos" on public.trip_photos;
create policy "public can insert trip photos"
  on public.trip_photos
  for insert
  to anon
  with check (true);

drop policy if exists "public can update trip photos" on public.trip_photos;
create policy "public can update trip photos"
  on public.trip_photos
  for update
  to anon
  using (true)
  with check (true);

drop policy if exists "public can read trip photo objects" on storage.objects;
create policy "public can read trip photo objects"
  on storage.objects
  for select
  to anon
  using (bucket_id = 'trip-photos');

drop policy if exists "public can upload trip photo objects" on storage.objects;
create policy "public can upload trip photo objects"
  on storage.objects
  for insert
  to anon
  with check (bucket_id = 'trip-photos');

drop policy if exists "public can update trip photo objects" on storage.objects;
create policy "public can update trip photo objects"
  on storage.objects
  for update
  to anon
  using (bucket_id = 'trip-photos')
  with check (bucket_id = 'trip-photos');

drop policy if exists "public can delete trip photo objects" on storage.objects;
create policy "public can delete trip photo objects"
  on storage.objects
  for delete
  to anon
  using (bucket_id = 'trip-photos');
