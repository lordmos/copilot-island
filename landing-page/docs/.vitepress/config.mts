import { defineConfig } from 'vitepress'

export default defineConfig({
  title: 'Copilot Island',
  description: 'Bring GitHub Copilot CLI to your MacBook Notch',
  base: '/copilot-island/',

  head: [
    ['link', { rel: 'icon', href: '/copilot-island/hero.svg' }],
    ['meta', { name: 'theme-color', content: '#6E40C9' }],
    ['meta', { property: 'og:type', content: 'website' }],
    ['meta', { property: 'og:title', content: 'Copilot Island' }],
    ['meta', { property: 'og:description', content: 'Bring GitHub Copilot CLI to your MacBook Notch' }],
  ],

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
            { text: 'GitHub Models Chat', link: '/guide/api-chat' },
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
