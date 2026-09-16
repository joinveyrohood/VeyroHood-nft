-- New Supabase project → SQL Editor → Run

create table if not exists public.users (
  id uuid primary key default gen_random_uuid(),
  wallet_address text unique not null,
  x_username text,
  discord_username text,
  referrer_wallet text,
  verification_status text default 'pending',
  is_og boolean default false,
  payment_tx_hash text,
  og_assigned_at timestamptz,
  referral_count int default 0,
  referral_earnings numeric default 0,
  created_at timestamptz default now()
);

create table if not exists public.verifications (
  id uuid primary key default gen_random_uuid(),
  wallet_address text not null,
  x_follow boolean default false,
  discord_join boolean default false,
  quote_link text,
  reply_link text,
  is_verified boolean default false,
  verified_at timestamptz,
  tx_hash text,
  payment_amount_usd numeric,
  chain_id int
);

create table if not exists public.referrals (
  id uuid primary key default gen_random_uuid(),
  referrer_wallet text not null,
  referred_wallet text not null,
  payment_amount numeric,
  referrer_amount numeric,
  tx_hash text,
  status text default 'paid',
  created_at timestamptz default now()
);

create table if not exists public.withdraw_requests (
  id uuid primary key default gen_random_uuid(),
  wallet text not null,
  amount_usd numeric not null,
  status text default 'pending',
  created_at timestamptz default now()
);

alter table public.users enable row level security;
alter table public.verifications enable row level security;
alter table public.referrals enable row level security;
alter table public.withdraw_requests enable row level security;

create policy "users read" on public.users for select to anon using (true);
create policy "users insert" on public.users for insert to anon with check (true);
create policy "users update" on public.users for update to anon using (true);
create policy "verif read" on public.verifications for select to anon using (true);
create policy "verif insert" on public.verifications for insert to anon with check (true);
create policy "refs read" on public.referrals for select to anon using (true);
create policy "refs insert" on public.referrals for insert to anon with check (true);
create policy "wd read" on public.withdraw_requests for select to anon using (true);
create policy "wd insert" on public.withdraw_requests for insert to anon with check (true);
