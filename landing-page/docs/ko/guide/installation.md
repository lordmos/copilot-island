---
layout: doc
---

# 설치

## 시스템 요구사항

- **macOS 14.0 이상**（Sonoma 또는 그 이상）
- 노치가 있는 MacBook Pro 또는 MacBook Air（**2021년 이후 모델**）
- [GitHub Copilot CLI](https://docs.github.com/en/copilot/github-copilot-in-the-cli) 설치 및 인증 완료

## 옵션 1: 릴리스 다운로드（권장）

1. [Releases 페이지](https://github.com/lordmos/copilot-island/releases/latest)로 이동
2. `CopilotIsland.dmg` 다운로드
3. DMG를 열고 Copilot Island를 응용 프로그램 폴더로 드래그
4. 응용 프로그램（또는 Spotlight）에서 Copilot Island 실행
5. 앱이 MacBook 노치에 표시됩니다

## 옵션 2: 소스에서 빌드

```bash
# 저장소 클론
git clone https://github.com/lordmos/copilot-island.git
cd copilot-island

# 설정 실행（XcodeGen 설치, Xcode 프로젝트 생성）
chmod +x scripts/setup.sh && ./scripts/setup.sh

# Xcode에서 열기
open CopilotIsland.xcodeproj
```

**⌘R** 을 눌러 빌드하고 실행합니다.

## 첫 실행

첫 실행 시 Copilot Island는:
1. 홈 디렉터리 내 파일 접근 권한 요청
2. `~/.copilot/session-state/` 자동 감시 시작
3. MacBook 노치에 접힌 필（pill）표시

추가 설정은 필요 없습니다 — 터미널에서 `copilot`을 사용하기만 하면 됩니다!
