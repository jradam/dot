// ==UserScript==
// @name         Utilities
// @version      1.0
// @description  Small website improvements
// @match        *://*/*
// @grant        none
// @run-at       document-start
// ==/UserScript==

; (function () {
  'use strict'

  // Hide Reddit sidebar
  if (location.href.includes('.reddit.')) {
    const hideSideMenu = () => {
      const sideMenu = document.querySelector('.side')
      sideMenu.style.display = 'none'

      document.addEventListener('keydown', ({ key }) => {
        if (key === 'F2') {
          sideMenu.style.display =
            sideMenu.style.display === 'none' ? 'block' : 'none'
        }
      })
    }

    window.addEventListener('load', hideSideMenu)
  }

  // Hide unused Gmail UI elements
  if (location.href.includes('mail.google')) {
    const hideNavigation = () => {
      const nav = document.querySelectorAll('[role="navigation"]')[0]
      const tab = document.querySelectorAll('[role="complementary"]')[0]
        .parentElement

      nav.style.display = 'none'
      tab.style.display = 'none'

      window.addEventListener('resize', () => {
        nav.style.display = 'none'
        tab.style.display = 'none'
      })

      document.addEventListener('keydown', ({ key }) => {
        if (key === 'F2') {
          nav.style.display = nav.style.display === 'none' ? 'block' : 'none'
          tab.style.display = tab.style.display === 'none' ? 'block' : 'none'
        }
      })
    }

    window.addEventListener('load', hideNavigation)
  }

  // Allow WhatsApp inputs to expand
  if (location.href.includes('web.whatsapp.com')) {
    const style = document.createElement('style')
    style.textContent = `[role="textbox"] { max-height: none !important; }`
    document.head.appendChild(style)
  }
})()
