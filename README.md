# 필링 그레이트 (Feeling Great)

> 감정은 명령이 아니라 정보예요.
> 느끼고 · 읽고 · 수정하고 · 행동으로 연결해요.

CBT(인지행동치료) 기반의 개인 감정 기록 및 워크북 웹앱입니다.
감정을 6단계로 처리하고, 지난 기록과 인사이트를 확인할 수 있어요.

---

## 주요 기능

- **6단계 감정 처리 워크플로우**
  1. 감정 어휘 선택 — 지금 느끼는 감정을 정확한 단어로 고르기
  2. 강도 & 목표 설정 — 현재 감정 강도 측정, 목표 다이얼 조절
  3. 감정 읽기 — 이 감정이 보내는 트리거 · 메시지 · 욕구 파악
  4. 생각 수정(CBT) — 인지 왜곡 찾기 → 긍정적 생각으로 리프레임
  5. 행동 전환 — 욕구 → 지금 & 다음에 할 행동 연결
  6. 결과 & 패턴 — 감정 변화 확인, 반복 패턴 및 인사이트 기록

- **나의 기록** — 지난 세션 목록 조회, 수정, 삭제
- **인사이트** — 감정 분포 도넛 차트, 강도 변화 바 차트
- **인지 왜곡 사전** — 10가지 인지 왜곡 유형 설명
- **Supabase Auth** — 이메일/비밀번호 로그인 · 회원가입

---

## 기술 스택

| 영역 | 사용 기술 |
|------|-----------|
| UI | React 19, Tailwind CSS v4 |
| 렌더링 | ReactDOM (createRoot) |
| 백엔드 | Supabase (PostgreSQL + Auth) |
| 호스팅 | GitHub Pages |
| 빌드 | 없음 (단일 번들 정적 파일) |

---

## 파일 구조

```
feeling-great/
├── index.html          # HTML 진입점 — 메타, CSS/JS 로드
├── js/
│   └── bundle.js       # 전체 앱 번들
│                       #   SECTION 1: 외부 라이브러리 (React, Supabase)
│                       #   SECTION 2: 앱 코드 (컴포넌트, 라우터, DB)
├── css/
│   └── styles.css      # Tailwind CSS 전역 스타일
└── supabase_schema.sql # Supabase DB 테이블 정의
```

### bundle.js 내 컴포넌트 구조

```
AuthView     — 로그인 / 회원가입 화면
Li           — 홈 화면 (세션 시작 / 기록 보기)
Ji           — Step 1: 감정 어휘 선택
Yi           — Step 2: 강도 & 목표 설정
Zi           — Step 3: 감정 읽기
$i           — Step 4: 생각 수정 (CBT)
ta           — Step 5: 행동 전환
na           — Step 6: 결과 & 패턴
HistoryView  — 나의 기록 목록
Ri           — 인사이트 / 기록 상세 탭 뷰
aa           — 인지 왜곡 교육 페이지
sa (App)     — 루트 컴포넌트 (인증 상태 · 페이지 라우팅)
```

---

## DB 구조 (Supabase)

```
sessions      — 워크북 세션 (id, created_at, completed)
emotions      — 감정 기록 (name, category, intensity, target)
emotion_reads — 감정 읽기 (trigger, message, need)
thoughts      — CBT 생각 수정 (thought, distortions, reframe, belief)
actions       — 행동 전환 (value_need, action_now, action_next)
results       — 결과 (intensity_after, pattern, insight)
```

> 전체 스키마는 `supabase_schema.sql` 참고

---

## 로컬 실행

빌드 과정 없이 정적 파일 서버로 바로 실행할 수 있어요.

```bash
# Python
python3 -m http.server 3000

# Node.js (npx)
npx serve .
```

브라우저에서 `http://localhost:3000` 접속

---

## 배포

GitHub Pages (main 브랜치 루트 디렉토리 기준 자동 배포)

```
https://gayoung0420.github.io/feeling-great/
```

Settings → Pages → Source: `main` / `/ (root)` 로 설정
