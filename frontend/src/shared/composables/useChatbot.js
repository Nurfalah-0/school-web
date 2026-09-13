import { ref, computed } from 'vue'
import client from '../../api/client'

const SESSION_KEY = 'chatbot_session_id'
const HISTORY_KEY = 'chatbot_history'
const OPEN_KEY = 'chatbot_open'

function getSessionId() {
  let sid = sessionStorage.getItem(SESSION_KEY)
  if (!sid) {
    sid = `sess_${Date.now()}_${Math.random().toString(36).slice(2, 9)}`
    sessionStorage.setItem(SESSION_KEY, sid)
  }
  return sid
}

function loadHistory() {
  try {
    const raw = sessionStorage.getItem(HISTORY_KEY)
    return raw ? JSON.parse(raw) : []
  } catch {
    return []
  }
}

function saveHistory(history) {
  try {
    sessionStorage.setItem(HISTORY_KEY, JSON.stringify(history))
  } catch {
    // ignore storage errors
  }
}

export function useChatbot() {
  const isOpen = ref(false)
  const messages = ref(loadHistory())
  const input = ref('')
  const isTyping = ref(false)
  const sessionId = ref(getSessionId())
  const quickReplies = ref(['Jurusan apa saja?', 'Cara daftar SPMB', 'Info kontak', 'Berita terbaru'])
  const isFirstOpen = computed(() => messages.value.length === 0)

  async function startConversation() {
    const { data } = await client.post('/chatbot/start', { context: 'general' })
    sessionId.value = data.session_id
    sessionStorage.setItem(SESSION_KEY, sessionId.value)
  }

  function toggle() {
    isOpen.value = !isOpen.value
    try {
      sessionStorage.setItem(OPEN_KEY, JSON.stringify(isOpen.value))
    } catch {
      // ignore
    }
  }

  function open() {
    isOpen.value = true
    try {
      sessionStorage.setItem(OPEN_KEY, 'true')
    } catch {
      // ignore
    }
  }

  function close() {
    isOpen.value = false
    try {
      sessionStorage.setItem(OPEN_KEY, 'false')
    } catch {
      // ignore
    }
  }

  function restoreState() {
    try {
      const stored = sessionStorage.getItem(OPEN_KEY)
      if (stored === 'true') {
        isOpen.value = true
      }
    } catch {
      // ignore
    }
  }

  function addBotMessage(text) {
    messages.value.push({ role: 'bot', content: text })
    saveHistory(messages.value)
  }

  async function sendMessage(content) {
    if (!content.trim() || isTyping.value) return

    const userMsg = content.trim()
    input.value = ''
    messages.value.push({ role: 'user', content: userMsg })
    saveHistory(messages.value)
    isTyping.value = true

    try {
      try {
        await client.get(`/chatbot/${sessionId.value}/history`)
      } catch (error) {
        if (error.response?.status !== 404) throw error
        await startConversation()
      }

      const { data } = await client.post(`/chatbot/${sessionId.value}/message`, {
        message: userMsg,
        context: 'general'
      })

      addBotMessage(data.bot_response?.message || data.message)
    } catch (error) {
      addBotMessage('Maaf, sedang ada gangguan koneksi. Silakan coba lagi atau hubungi kami di WhatsApp +62 823-3558-5491.')
    } finally {
      isTyping.value = false
    }
  }

  function sendQuickReply(text) {
    sendMessage(text)
  }

  function reset() {
    messages.value = []
    saveHistory([])
  }

  return {
    isOpen,
    messages,
    input,
    isTyping,
    sessionId,
    quickReplies,
    isFirstOpen,
    toggle,
    open,
    close,
    restoreState,
    sendMessage,
    sendQuickReply,
    reset
  }
}
