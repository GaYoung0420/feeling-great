-- ================================
-- 필링 그레이트 · Supabase Schema
-- SQL Editor에 붙여넣고 실행하세요
-- ================================

-- 1. 세션 (한 번의 워크북 진행)
create table sessions (
  id          uuid primary key default gen_random_uuid(),
  user_id     uuid references auth.users(id) on delete cascade not null,
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
-- RLS 활성화 + 정책 (각 유저는 자신의 데이터만 접근)
-- ================================
alter table sessions      enable row level security;
alter table emotions      enable row level security;
alter table emotion_reads enable row level security;
alter table thoughts      enable row level security;
alter table actions       enable row level security;
alter table results       enable row level security;

-- sessions: 본인 데이터만
create policy "sessions_own" on sessions
  for all using (auth.uid() = user_id);

-- 나머지 테이블: session_id를 통해 본인 세션에 속한 데이터만
create policy "emotions_own" on emotions
  for all using (
    exists (select 1 from sessions where sessions.id = emotions.session_id and sessions.user_id = auth.uid())
  );

create policy "emotion_reads_own" on emotion_reads
  for all using (
    exists (select 1 from sessions where sessions.id = emotion_reads.session_id and sessions.user_id = auth.uid())
  );

create policy "thoughts_own" on thoughts
  for all using (
    exists (select 1 from sessions where sessions.id = thoughts.session_id and sessions.user_id = auth.uid())
  );

create policy "actions_own" on actions
  for all using (
    exists (select 1 from sessions where sessions.id = actions.session_id and sessions.user_id = auth.uid())
  );

create policy "results_own" on results
  for all using (
    exists (select 1 from sessions where sessions.id = results.session_id and sessions.user_id = auth.uid())
  );

-- ================================
-- 기존 DB에 user_id 컬럼 추가할 경우 (이미 테이블이 있다면)
-- ================================
-- alter table sessions add column user_id uuid references auth.users(id) on delete cascade;
-- update sessions set user_id = '여기에-본인-user-id' where user_id is null;
-- alter table sessions alter column user_id set not null;
