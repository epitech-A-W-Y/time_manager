
import { fileURLToPath, URL } from 'node:url'
import { defineConfig } from 'vite'
import vue from '@vitejs/plugin-vue'

const cordovaScript = {
  name: 'cordova-script',
  transformIndexHtml(html) {
    return html.replace(
      '<head>',
      '<head>\n    <script src="cordova.js"></script>'
    )
  },
}

export default defineConfig({
  base: './',
  plugins: [vue(), cordovaScript],
  resolve: {
    alias: {
      '@': fileURLToPath(new URL('./src', import.meta.url)),
    },
  },
  build: {
    target: 'chrome66',
    outDir: '../mobile/app/www',
    emptyOutDir: true,
  },
  server: {
    proxy: {
      '/api': {
        target: 'http://localhost:4000',
        changeOrigin: true,
      },
    },
  },
})
