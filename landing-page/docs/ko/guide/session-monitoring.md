---
layout: doc
---

# 세션 모니터링

Copilot Island의 핵심 기능은 GitHub Copilot CLI 세션의 실시간 모니터링입니다.

## 세션 감지 방법

Copilot Island는 macOS **FSEvents**를 사용하여 `~/.copilot/session-state/`를 감시합니다. 이는 Xcode와 Spotlight가 사용하는 것과 동일한 저지연 파일 시스템 알림 API입니다. Copilot CLI가 새 세션 디렉터리를 생성하면 Copilot Island는 밀리초 내에 감지합니다.

```
~/.copilot/session-state/
└── {UUID}/                    ← 새 디렉터리가 감지를 트리거
    ├── workspace.yaml         ← 세션 메타데이터
    └── events.jsonl           ← 이벤트 스트림（실시간으로 추가됨）
```

훅, 플러그인, CLI 수정이 전혀 필요 없습니다.

## 세션 카드

각 세션은 노치 패널에 카드로 표시되며 다음 정보를 확인할 수 있습니다:

| 필드 | 설명 |
|------|------|
| 🟢 상태 점 | 녹색 = 활성, 회색 = 종료 |
| 프로젝트 경로 | `workspace.yaml`의 `cwd` |
| Git 브랜치 | 현재 브랜치（Git 저장소 내인 경우） |
| 세션 요약 | Copilot CLI가 자동 생성한 요약 |
| 경과 시간 | 세션 시작 이후 경과된 시간 |

## 이벤트 스트림

각 세션 내에서 Copilot Island는 `events.jsonl`을 테일하며 다음 이벤트 유형을 처리합니다:

| 이벤트 유형 | 의미 |
|------------|------|
| `session.start` | 새 Copilot CLI 세션이 시작됨 |
| `user.message` | Copilot에 메시지를 전송함 |
| `assistant.turn_start` | Copilot이 생각/응답을 시작함 |
| `assistant.message` | Copilot이 응답을 생성함 |
| `tool.execution_start` | Copilot이 도구를 실행하려고 함 |
| `tool.execution_complete` | 도구가 완료됨（성공 또는 오류） |
| `assistant.turn_end` | Copilot이 응답 턴을 완료함 |
| `abort` | 사용자가 세션을 중단함 |
| `session.shutdown` | Copilot CLI 프로세스가 종료됨 |

## 다중 세션

Copilot Island는 **모든 동시 세션**을 추적합니다. 여러 터미널 창에서 `copilot`을 실행 중인 경우 각 세션이 별도의 카드로 표시됩니다. 세션은 가장 최근에 활성화된 순으로 정렬됩니다.

## 세션 유지

종료된 세션은 현재 앱 실행 중에는 계속 표시됩니다. 앱을 가볍게 유지하고 개인 정보를 보호하기 위해 앱 재시작 후에는 세션이 유지되지 않습니다.

## 개인 정보 보호

Copilot Island는 Mac에서 **로컬로** 세션 데이터를 읽습니다. 업로드하거나 공유하는 것은 없습니다. GitHub Models API 채팅 기능만이 네트워크 기능이며 완전히 옵트인입니다.
