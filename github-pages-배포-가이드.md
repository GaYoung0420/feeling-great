# 필링 그레이트 — GitHub Pages 배포 가이드

## 준비된 것
- `vite.config.ts` — base path 설정 완료 (`/feeling-great/`)
- `.github/workflows/deploy.yml` — 자동 배포 워크플로우 생성 완료

---

## 단계별 진행

### 1단계 · GitHub 레포 만들기

1. https://github.com/new 접속
2. Repository name: `feeling-great` (vite.config의 base 경로와 **일치해야** 함)
3. Public으로 설정 (GitHub Pages 무료 사용 조건)
4. **Create repository** 클릭

---

### 2단계 · 로컬에서 Git 초기화 & 푸시

터미널에서 프로젝트 폴더로 이동 후 아래 명령어를 순서대로 실행하세요:

```bash
cd feeling-great

git init
git add .
git commit -m "initial commit"

git branch -M main
git remote add origin https://github.com/[내_아이디]/feeling-great.git
git push -u origin main
```

> `[내_아이디]` 부분을 본인 GitHub 아이디로 바꾸세요.

---

### 3단계 · GitHub Pages 설정

1. 레포 페이지 → **Settings** 탭
2. 왼쪽 메뉴 → **Pages**
3. Source: **GitHub Actions** 선택
4. 저장

---

### 4단계 · 배포 확인

- main 브랜치에 push하면 **자동으로 빌드 & 배포**가 시작됩니다
- Actions 탭에서 진행 상황을 실시간으로 확인할 수 있어요
- 약 1~2분 후 아래 주소로 접속 가능:

```
https://[내_아이디].github.io/feeling-great/
```

---

## 레포 이름을 다르게 짓고 싶다면

예를 들어 레포 이름을 `my-app`으로 짓는다면,
`vite.config.ts`의 base도 같이 변경해야 합니다:

```ts
base: '/my-app/',
```

---

## 코드 수정 후 재배포

별도 작업 없이, `main` 브랜치에 push만 하면 자동으로 다시 빌드 & 배포됩니다:

```bash
git add .
git commit -m "update"
git push
```

---

## Supabase 연결

현재 `src/lib/supabase.ts`에 anon key가 직접 코드에 들어 있습니다.
anon key는 Supabase가 공개용으로 설계한 키라 코드에 있어도 무방합니다.
(RLS 비활성화 상태이므로 혼자만 쓰는 개인 앱으로 그대로 사용 가능)

> 나중에 여러 사람이 쓰는 앱으로 확장하려면 RLS를 켜고 인증을 추가하세요.
