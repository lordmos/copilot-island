---
layout: doc
---

# 구성

Copilot Island는 최소한의 설정만 필요하며 즉시 사용할 수 있습니다.

## 설정 패널

펼쳐진 노치 패널에서 **⋯ 메뉴 아이콘**을 클릭한 후 **설정**을 선택합니다.

### 사운드 효과

완료 차임과 실패 사운드를 켜거나 끕니다:

- **완료 사운드** — 에이전트가 작업을 완료했을 때（`session.task_complete` → `assistant.turn_end`）재생
- **실패 사운드** — `abort`, `session.error`, 또는 예상치 못한 `session.shutdown` 시 재생

### About 및 업데이트

설정의 **About** 탭에는 현재 앱 버전이 표시되며 **업데이트 확인**（Sparkle 기반）을 할 수 있습니다. Copilot Island는 GitHub에 새 릴리스가 공개되면 알림을 보냅니다.

## 세션 감시

Copilot Island는 자동으로 `~/.copilot/session-state/`의 변경 사항을 감시합니다.  
설정 불필요 — 그냥 작동합니다.

시작 시, UI를 빠르게 유지하기 위해 **현재 작업**（마지막 `user.message` 이후의 이벤트）만 로드됩니다. 이전 기록은 재생되지 않습니다.

## macOS 권한

첫 실행 시 메시지가 표시되면 다음 권한을 허용하세요:

- **파일 및 폴더** → 홈 디렉터리의 Copilot CLI 세션 파일 읽기 접근 허용
