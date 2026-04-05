---
layout: home

hero:
  name: "Copilot Island"
  text: "MacBook 노치를 GitHub Copilot으로 활용하세요"
  tagline: Copilot CLI 세션을 실시간으로 모니터링하고 AI 대화를 노치에서 확인하세요.
  image:
    src: /hero.svg
    alt: Copilot Island
  actions:
    - theme: brand
      text: Mac 다운로드
      link: https://github.com/lordmos/copilot-island/releases/latest
    - theme: alt
      text: GitHub에서 보기
      link: https://github.com/lordmos/copilot-island
    - theme: alt
      text: 빠른 시작 →
      link: /guide/quick-start

features:
  - icon: 🔔
    title: 실시간 세션 모니터링
    details: MacBook 노치에서 직접 모든 Copilot CLI 세션을 실시간으로 확인하세요. AI가 무엇을 하는지 항상 파악할 수 있습니다.

  - icon: ⚡
    title: 도구 활동 피드
    details: Copilot이 실행 중인 도구(파일 쓰기, 셸 명령, 웹 검색)를 인수와 함께 노치에서 실시간으로 확인하세요.

  - icon: 💬
    title: 전체 대화 기록
    details: 아름다운 Markdown 렌더링으로 전체 대화를 스크롤하며 확인하세요. 코드 블록과 도구 결과도 포함됩니다.

  - icon: 🎨
    title: Copilot 영감 디자인
    details: GitHub 디자인 언어로 제작되었습니다. 세이지 그린 팔레트, 다크 테마, macOS에 네이티브한 부드러운 애니메이션.

  - icon: 🔓
    title: 완전 오픈 소스
    details: Apache 2.0 라이선스. 코드 검사, 기능 기여, 버그 보고 가능. 커뮤니티가 ❤️ 를 담아 만들었습니다.
---

## 작동 방식

```bash
# 1. Copilot Island 설치 (Releases에서 다운로드)
# 2. 평소대로 Copilot CLI 세션 시작
copilot "인증 모듈에 단위 테스트 추가해줘"

# 3. Copilot Island가 자동으로 세션을 감지하고
#    MacBook 노치에 표시합니다 — 설정 불필요!
```

> Copilot Island는 `~/.copilot/session-state/`를 감시하며 Copilot CLI 네이티브 JSONL 이벤트 로그에서 실시간으로 스트리밍합니다. 별도 설정 없이 바로 사용 가능합니다.

## 시스템 요구사항

- macOS 14.0 이상 (Sonoma 또는 그 이상)
- 노치가 있는 MacBook Pro 또는 MacBook Air (2021년 이후 모델)
- GitHub Copilot CLI 설치 및 인증 완료
