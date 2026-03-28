-- ================================
-- 필링 그레이트 · Supabase Schema
-- SQL Editor에 붙여넣고 실행하세요
-- ================================

-- 1. 세션 (한 번의 워크북 진행)
create table sessions (
  id          uuid primary key default gen_random_uuid(),
  created_at  timestamptz default now(),
  completed   boolean default false
);

-- 2. 감정 기록 (step 1~2)
create table emotions (
  id          uuid primary key default gen_random_uuid(),
  session_id  uuid references sessions(id) on delete cascade,
  name        text not null,
  category    text,
  intensity   int check (intensity between 0 and 100),
  target      int check (target between 0 and 100),
  reframe     text,
  created_at  timestamptz default now()
);

-- 3. 감정 읽기 (step 3)
create table emotion_reads (
  id          uuid primary key default gen_random_uuid(),
  session_id  uuid references sessions(id) on delete cascade,
  trigger     text,
  message     text,
  need        text,
  created_at  timestamptz default now()
);

-- 4. 부정적 생각 · CBT (step 4)
create table thoughts (
  id             uuid primary key default gen_random_uuid(),
  session_id     uuid references sessions(id) on delete cascade,
  thought        text not null,
  belief_before  int check (belief_before between 0 and 100),
  belief_after   int check (belief_after between 0 and 100),
  distortions    text[],
  reframe        text,
  positive_belief int check (positive_belief between 0 and 100),
  created_at     timestamptz default now()
);

-- 5. 행동 전환 (step 5)
create table actions (
  id          uuid primary key default gen_random_uuid(),
  session_id  uuid references sessions(id) on delete cascade,
  value_need  text,
  action_now  text,
  action_next text,
  created_at  timestamptz default now()
);

-- 6. 결과 (step 6)
create table results (
  id              uuid primary key default gen_random_uuid(),
  session_id      uuid references sessions(id) on delete cascade,
  emotion_id      uuid references emotions(id) on delete cascade,
  intensity_after int check (intensity_after between 0 and 100),
  pattern         text,
  insight         text,
  created_at      timestamptz default now()
);

-- ================================
-- RLS 비활성화 (혼자 쓰는 개인 프로젝트)
-- ================================
alter table sessions     disable row level security;
alter table emotions     disable row level security;
alter table emotion_reads disable row level security;
alter table thoughts     disable row level security;
alter table actions      disable row level security;
alter table results      disable row level security;
