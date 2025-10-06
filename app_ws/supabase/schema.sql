-- Enable extensions required for UUID generation
create extension if not exists "pgcrypto";

-- Patient information captured from the patient info form
create table if not exists public.patient_info (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text not null,
  age smallint not null check (age >= 0),
  chief_complaint text not null,
  updated_at timestamptz not null default timezone('utc', now())
);

alter table public.patient_info enable row level security;

create policy "patient_info_select" on public.patient_info
  for select using (auth.uid() = user_id);

create policy "patient_info_upsert" on public.patient_info
  for insert with check (auth.uid() = user_id);

create policy "patient_info_update" on public.patient_info
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);

-- Vitals history recorded during the encounter
create table if not exists public.vitals (
  id uuid primary key default gen_random_uuid(),
  user_id uuid not null references auth.users(id) on delete cascade,
  heart_rate smallint not null,
  blood_pressure text not null,
  respiratory_rate smallint not null,
  temperature numeric(5,2) not null,
  recorded_at timestamptz not null default timezone('utc', now())
);

create index if not exists vitals_user_id_recorded_at_idx
  on public.vitals (user_id, recorded_at desc);

alter table public.vitals enable row level security;

create policy "vitals_select" on public.vitals
  for select using (auth.uid() = user_id);

create policy "vitals_insert" on public.vitals
  for insert with check (auth.uid() = user_id);

-- Narrative notes captured from the report page
create table if not exists public.reports (
  user_id uuid primary key references auth.users(id) on delete cascade,
  notes text,
  observations text,
  updated_at timestamptz not null default timezone('utc', now())
);

alter table public.reports enable row level security;

create policy "reports_select" on public.reports
  for select using (auth.uid() = user_id);

create policy "reports_upsert" on public.reports
  for insert with check (auth.uid() = user_id);

create policy "reports_update" on public.reports
  for update using (auth.uid() = user_id) with check (auth.uid() = user_id);
