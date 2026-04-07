import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Copilot Island',
  description: 'Bring GitHub Copilot CLI to your MacBook Notch',
  base: '/copilot-island/',

  head: [
    ['link', { rel: 'icon', href: '/copilot-island/hero.svg' }],
    ['meta', { name: 'theme-color', content: '#6CBB98' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'Copilot Island' }],
    ['meta', { property: 'og:description', content: 'Bring GitHub Copilot CLI to your MacBook Notch' }],
  ],

  locales: {
    root: {
      label: 'English',
      lang: 'en-US',
    },
    'zh-hans': {
      label: '简体中文',
      lang: 'zh-Hans',
      title: 'Copilot Island',
      description: '将 GitHub Copilot CLI 带到您的 MacBook 刘海屏',
      themeConfig: {
        nav: [
          { text: '首页', link: '/zh-hans/' },
          { text: '指南', link: '/zh-hans/guide/' },
          { text: '更新日志', link: '/zh-hans/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/zh-hans/guide/': [
            {
              text: '快速上手',
              items: [
                { text: '安装', link: '/zh-hans/guide/installation' },
                { text: '快速开始', link: '/zh-hans/guide/quick-start' },
                { text: '配置', link: '/zh-hans/guide/configuration' },
              ]
            },
            {
              text: '功能介绍',
              items: [
                { text: '会话监控', link: '/zh-hans/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: '采用 Apache 2.0 许可证发布。', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    'zh-hant': {
      label: '繁體中文',
      lang: 'zh-Hant',
      title: 'Copilot Island',
      description: '將 GitHub Copilot CLI 帶到您的 MacBook 瀏海螢幕',
      themeConfig: {
        nav: [
          { text: '首頁', link: '/zh-hant/' },
          { text: '指南', link: '/zh-hant/guide/' },
          { text: '更新日誌', link: '/zh-hant/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/zh-hant/guide/': [
            {
              text: '快速上手',
              items: [
                { text: '安裝', link: '/zh-hant/guide/installation' },
                { text: '快速開始', link: '/zh-hant/guide/quick-start' },
                { text: '配置', link: '/zh-hant/guide/configuration' },
              ]
            },
            {
              text: '功能介紹',
              items: [
                { text: '工作階段監控', link: '/zh-hant/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: '採用 Apache 2.0 授權發布。', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    ja: {
      label: '日本語',
      lang: 'ja',
      title: 'Copilot Island',
      description: 'GitHub Copilot CLI を MacBook のノッチに',
      themeConfig: {
        nav: [
          { text: 'ホーム', link: '/ja/' },
          { text: 'ガイド', link: '/ja/guide/' },
          { text: '変更履歴', link: '/ja/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/ja/guide/': [
            {
              text: 'はじめに',
              items: [
                { text: 'インストール', link: '/ja/guide/installation' },
                { text: 'クイックスタート', link: '/ja/guide/quick-start' },
                { text: '設定', link: '/ja/guide/configuration' },
              ]
            },
            {
              text: '機能',
              items: [
                { text: 'セッション監視', link: '/ja/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: 'Apache 2.0 ライセンスのもとで公開。', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    ko: {
      label: '한국어',
      lang: 'ko',
      title: 'Copilot Island',
      description: 'GitHub Copilot CLI를 MacBook 노치에서 사용하세요',
      themeConfig: {
        nav: [
          { text: '홈', link: '/ko/' },
          { text: '가이드', link: '/ko/guide/' },
          { text: '변경 로그', link: '/ko/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/ko/guide/': [
            {
              text: '시작하기',
              items: [
                { text: '설치', link: '/ko/guide/installation' },
                { text: '빠른 시작', link: '/ko/guide/quick-start' },
                { text: '설정', link: '/ko/guide/configuration' },
              ]
            },
            {
              text: '기능',
              items: [
                { text: '세션 모니터링', link: '/ko/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: 'Apache 2.0 라이선스로 배포됩니다.', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    fr: {
      label: 'Français',
      lang: 'fr',
      title: 'Copilot Island',
      description: "Apportez GitHub Copilot CLI à l'encoche de votre MacBook",
      themeConfig: {
        nav: [
          { text: 'Accueil', link: '/fr/' },
          { text: 'Guide', link: '/fr/guide/' },
          { text: 'Journal des modifications', link: '/fr/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/fr/guide/': [
            {
              text: 'Démarrage',
              items: [
                { text: 'Installation', link: '/fr/guide/installation' },
                { text: 'Démarrage rapide', link: '/fr/guide/quick-start' },
                { text: 'Configuration', link: '/fr/guide/configuration' },
              ]
            },
            {
              text: 'Fonctionnalités',
              items: [
                { text: 'Surveillance des sessions', link: '/fr/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: 'Publié sous la licence Apache 2.0.', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    de: {
      label: 'Deutsch',
      lang: 'de',
      title: 'Copilot Island',
      description: 'Bringe GitHub Copilot CLI in deine MacBook-Notch',
      themeConfig: {
        nav: [
          { text: 'Startseite', link: '/de/' },
          { text: 'Anleitung', link: '/de/guide/' },
          { text: 'Änderungsprotokoll', link: '/de/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/de/guide/': [
            {
              text: 'Einstieg',
              items: [
                { text: 'Installation', link: '/de/guide/installation' },
                { text: 'Schnellstart', link: '/de/guide/quick-start' },
                { text: 'Konfiguration', link: '/de/guide/configuration' },
              ]
            },
            {
              text: 'Funktionen',
              items: [
                { text: 'Sitzungsüberwachung', link: '/de/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: 'Veröffentlicht unter der Apache 2.0 Lizenz.', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    pt: {
      label: 'Português',
      lang: 'pt',
      title: 'Copilot Island',
      description: 'Leve o GitHub Copilot CLI para o notch do seu MacBook',
      themeConfig: {
        nav: [
          { text: 'Início', link: '/pt/' },
          { text: 'Guia', link: '/pt/guide/' },
          { text: 'Changelog', link: '/pt/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/pt/guide/': [
            {
              text: 'Primeiros Passos',
              items: [
                { text: 'Instalação', link: '/pt/guide/installation' },
                { text: 'Início Rápido', link: '/pt/guide/quick-start' },
                { text: 'Configuração', link: '/pt/guide/configuration' },
              ]
            },
            {
              text: 'Funcionalidades',
              items: [
                { text: 'Monitoramento de Sessões', link: '/pt/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: 'Lançado sob a licença Apache 2.0.', copyright: 'Copyright © 2026 lordmos' },
      },
    },
    es: {
      label: 'Español',
      lang: 'es',
      title: 'Copilot Island',
      description: 'Lleva GitHub Copilot CLI a la muesca de tu MacBook',
      themeConfig: {
        nav: [
          { text: 'Inicio', link: '/es/' },
          { text: 'Guía', link: '/es/guide/' },
          { text: 'Changelog', link: '/es/changelog' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
        sidebar: {
          '/es/guide/': [
            {
              text: 'Primeros Pasos',
              items: [
                { text: 'Instalación', link: '/es/guide/installation' },
                { text: 'Inicio Rápido', link: '/es/guide/quick-start' },
                { text: 'Configuración', link: '/es/guide/configuration' },
              ]
            },
            {
              text: 'Características',
              items: [
                { text: 'Monitoreo de Sesiones', link: '/es/guide/session-monitoring' },
              ]
            }
          ]
        },
        footer: { message: 'Publicado bajo la licencia Apache 2.0.', copyright: 'Copyright © 2026 lordmos' },
      },
    },
  },

  themeConfig: {
    logo: '/hero.svg',
    siteTitle: 'Copilot Island',

    nav: [
      { text: 'Home', link: '/' },
      { text: 'Guide', link: '/guide/' },
      { text: 'Changelog', link: '/changelog' },
      { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' }
    ],

    sidebar: {
      '/guide/': [
        {
          text: 'Getting Started',
          items: [
            { text: 'Installation', link: '/guide/installation' },
            { text: 'Quick Start', link: '/guide/quick-start' },
            { text: 'Configuration', link: '/guide/configuration' },
          ]
        },
        {
          text: 'Features',
          items: [
            { text: 'Session Monitoring', link: '/guide/session-monitoring' },
          ]
        }
      ]
    },

    socialLinks: [
      { icon: 'github', link: 'https://github.com/lordmos/copilot-island' }
    ],

    footer: {
      message: 'Released under the Apache 2.0 License.',
      copyright: 'Copyright © 2026 lordmos'
    }
  }
})
