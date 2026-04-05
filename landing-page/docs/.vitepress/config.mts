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
          { text: '指南', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: '指南', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: 'ガイド', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: '가이드', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: 'Guide', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: 'Anleitung', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: 'Guia', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
          { text: 'Guía', link: '/guide/' },
          { text: 'GitHub', link: 'https://github.com/lordmos/copilot-island' },
        ],
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
