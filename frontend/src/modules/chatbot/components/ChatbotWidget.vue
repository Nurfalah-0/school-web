<template>
  <div class="chatbot-widget">
    <transition name="chat-fade">
      <div v-if="isOpen" class="chat-window" role="dialog" aria-modal="true" aria-label="Chatbot SMK Nurul Jadid">
        <div class="chat-header">
          <div class="chat-header-left">
            <div class="chat-avatar">
              <img :src="logoSrc" alt="Logo SMK" />
            </div>
            <div class="chat-header-info">
              <span class="chat-header-name">Asisten SMK Nurul Jadid</span>
              <span class="chat-header-status">
                <span class="chat-status-dot"></span>
                Online
              </span>
            </div>
          </div>
          <button class="chat-close" type="button" aria-label="Tutup chat" @click="close">
            <X :size="18" color="#ffffff" />
          </button>
        </div>

        <div class="chat-body" ref="chatBody">
          <div v-if="isFirstOpen" class="chat-welcome">
            <p class="chat-welcome-text">
              Assalamu'alaikum! <Sparkles :size="18" color="#2563eb" /> Saya Asisten AI SMK Nurul Jadid. Ada yang bisa saya bantu seputar profil sekolah, jurusan, pendaftaran (SPMB), atau info lainnya?
            </p>
            <div class="chat-quick-replies">
              <button
                v-for="reply in quickReplies"
                :key="reply"
                type="button"
                class="chat-quick-reply"
                @click="sendQuickReply(reply)"
              >
                {{ reply }}
              </button>
            </div>
          </div>

          <div class="chat-messages">
            <div
              v-for="(msg, idx) in messages"
              :key="idx"
              :class="['chat-message', msg.role === 'user' ? 'chat-message-user' : 'chat-message-bot']"
            >
              <div class="chat-bubble" v-html="formatMessage(msg.content)"></div>
            </div>

            <div v-if="isTyping" class="chat-message chat-message-bot">
              <div class="chat-bubble chat-typing">
                <span class="chat-typing-dot"></span>
                <span class="chat-typing-dot"></span>
                <span class="chat-typing-dot"></span>
              </div>
            </div>
          </div>
        </div>

        <div class="chat-footer">
          <form class="chat-form" @submit.prevent="handleSend">
            <input
              v-model="input"
              type="text"
              placeholder="Tulis pertanyaan Anda..."
              class="chat-input"
              :disabled="isTyping"
            />
            <button
              type="submit"
              class="chat-send"
              :disabled="!input.trim() || isTyping"
              aria-label="Kirim pesan"
            >
              <Send :size="18" color="#ffffff" />
            </button>
          </form>
        </div>
      </div>
    </transition>

    <button
      :class="['chat-fab', { 'chat-fab-open': isOpen }]"
      type="button"
      aria-label="Buka chatbot"
      @click="toggle"
    >
      <span class="chat-fab-icon">
        <MessageCircle :size="24" color="#ffffff" />
        <span v-if="isOpen" class="chat-fab-x">
          <X :size="14" color="#042d86" />
        </span>
      </span>
      <span v-if="!isOpen" class="chat-fab-badge"></span>
    </button>
  </div>
</template>

<script setup>
import { ref, onMounted, onUnmounted, nextTick, watch } from 'vue'
import { MessageCircle, Send, X, Sparkles } from 'lucide-vue-next'
import { useChatbot } from '../../../shared/composables/useChatbot'
import logoSrc from '../../../assets/logo.webp'

const {
  isOpen,
  messages,
  input,
  isTyping,
  quickReplies,
  isFirstOpen,
  toggle,
  close,
  sendMessage,
  sendQuickReply,
  restoreState
} = useChatbot()

const chatBody = ref(null)

onMounted(() => {
  restoreState()
  window.addEventListener('chatbot:open', openChatbot)
})

function openChatbot() {
  // useChatbot's open is not exposed, but toggle works
  if (!isOpen.value) {
    toggle()
  }
}

onUnmounted(() => {
  window.removeEventListener('chatbot:open', openChatbot)
})

function handleSend() {
  sendMessage(input.value)
  nextTick(scrollToBottom)
}

function scrollToBottom() {
  if (chatBody.value) {
    chatBody.value.scrollTop = chatBody.value.scrollHeight
  }
}

function formatMessage(text) {
  return text
    .replace(/&/g, '&amp;')
    .replace(/</g, '&lt;')
    .replace(/>/g, '&gt;')
    .replace(/\n/g, '<br />')
}

watch(() => messages.value.length, () => {
  nextTick(scrollToBottom)
})

watch(() => isOpen.value, (newVal) => {
  if (newVal) {
    nextTick(scrollToBottom)
  }
})
</script>

<style lang="scss" scoped>
@use '../../../assets/styles/variables' as *;

.chatbot-widget {
  position: fixed;
  bottom: 1.5rem;
  right: 1.5rem;
  z-index: 50;
  display: flex;
  flex-direction: column;
  align-items: flex-end;
  gap: 1rem;
  font-family: 'Manrope', system-ui, sans-serif;
}

.chat-fab {
  width: 3.75rem;
  height: 3.75rem;
  border-radius: 9999px;
  border: none;
  background: $brand;
  color: #ffffff;
  display: grid;
  place-items: center;
  cursor: pointer;
  box-shadow: 0 12px 28px rgba(4, 45, 134, 0.35);
  transition: transform 0.2s ease, box-shadow 0.2s ease;
  position: relative;
}

.chat-fab:hover {
  transform: translateY(-2px);
  box-shadow: 0 16px 34px rgba(4, 45, 134, 0.45);
}

.chat-fab-open {
  background: #ffffff;
  color: $brand;
  box-shadow: 0 8px 20px rgba(0, 0, 0, 0.12);
}

.chat-fab-icon {
  position: relative;
  display: grid;
  place-items: center;
}

.chat-fab-x {
  position: absolute;
  display: grid;
  place-items: center;
  width: 1.25rem;
  height: 1.25rem;
  border-radius: 9999px;
  background: #ffffff;
}

.chat-fab-badge {
  position: absolute;
  top: -2px;
  right: -2px;
  width: 14px;
  height: 14px;
  border-radius: 9999px;
  background: #ef4444;
  border: 2px solid #ffffff;
}

.chat-fade-enter-active,
.chat-fade-leave-active {
  transition: opacity 0.2s ease, transform 0.2s ease;
}

.chat-fade-enter-from,
.chat-fade-leave-to {
  opacity: 0;
  transform: translateY(1rem) scale(0.96);
}

.chat-window {
  position: absolute;
  bottom: 5rem;
  right: 0;
  width: min(20rem, calc(100vw - 2rem));
  height: min(30rem, 80vh);
  max-height: 80vh;
  background: #ffffff;
  border-radius: 1.5rem;
  box-shadow: 0 24px 48px rgba(15, 23, 42, 0.18);
  display: flex;
  flex-direction: column;
  overflow: hidden;
}

@media (max-width: 640px) {
  .chat-window {
    position: fixed;
    inset: 0;
    bottom: auto;
    right: auto;
    width: 100%;
    height: 100%;
    max-height: 100%;
    border-radius: 0;
  }
}

.chat-header {
  background: $brand;
  padding: 1rem 1.25rem;
  display: flex;
  align-items: center;
  justify-content: space-between;
  gap: 1rem;
}

.chat-header-left {
  display: flex;
  align-items: center;
  gap: 0.75rem;
}

.chat-avatar {
  width: 2.5rem;
  height: 2.5rem;
  border-radius: 9999px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.15);
  display: grid;
  place-items: center;
  flex-shrink: 0;
}

.chat-avatar img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.chat-header-info {
  display: flex;
  flex-direction: column;
  gap: 0.15rem;
}

.chat-header-name {
  font-weight: 800;
  font-size: 0.95rem;
  color: #ffffff;
}

.chat-header-status {
  display: inline-flex;
  align-items: center;
  gap: 0.35rem;
  font-size: 0.75rem;
  color: rgba(255, 255, 255, 0.85);
}

.chat-status-dot {
  width: 8px;
  height: 8px;
  border-radius: 9999px;
  background: #22c55e;
}

.chat-close {
  width: 2rem;
  height: 2rem;
  display: grid;
  place-items: center;
  border: none;
  border-radius: 9999px;
  background: rgba(255, 255, 255, 0.12);
  color: #ffffff;
  cursor: pointer;
  transition: background 0.2s ease;
}

.chat-close:hover {
  background: rgba(255, 255, 255, 0.22);
}

.chat-body {
  flex: 1;
  overflow-y: auto;
  padding: 1.25rem;
  display: flex;
  flex-direction: column;
  gap: 1rem;
  background: #f8fafc;
}

.chat-welcome {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.chat-welcome-text {
  margin: 0;
  background: #ffffff;
  border: 1px solid #e2e8f0;
  padding: 1rem;
  border-radius: 1rem;
  color: #334155;
  font-size: 0.9rem;
  line-height: 1.6;
}

.chat-quick-replies {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.chat-quick-reply {
  padding: 0.5rem 0.85rem;
  border-radius: 9999px;
  border: 1px solid rgba(4, 45, 134, 0.15);
  background: #ffffff;
  color: $brand;
  font-weight: 700;
  font-size: 0.85rem;
  cursor: pointer;
  transition: background 0.2s ease;
}

.chat-quick-reply:hover {
  background: #eef2ff;
}

.chat-messages {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.chat-message {
  display: flex;
}

.chat-message-user {
  justify-content: flex-end;
}

.chat-message-bot {
  justify-content: flex-start;
}

.chat-bubble {
  max-width: 85%;
  padding: 0.85rem 1rem;
  border-radius: 1rem;
  font-size: 0.9rem;
  line-height: 1.6;
  word-wrap: break-word;
}

.chat-message-user .chat-bubble {
  background: $brand;
  color: #ffffff;
  border-bottom-right-radius: 0.25rem;
}

.chat-message-bot .chat-bubble {
  background: #ffffff;
  color: #0f172a;
  border: 1px solid #e2e8f0;
  border-bottom-left-radius: 0.25rem;
}

.chat-typing {
  display: inline-flex;
  gap: 0.35rem;
  padding: 0.85rem 1.1rem;
}

.chat-typing-dot {
  width: 8px;
  height: 8px;
  border-radius: 9999px;
  background: #94a3b8;
  animation: typingPulse 1.4s infinite ease-in-out both;
}

.chat-typing-dot:nth-child(1) { animation-delay: -0.32s; }
.chat-typing-dot:nth-child(2) { animation-delay: -0.16s; }

@keyframes typingPulse {
  0%, 80%, 100% {
    transform: scale(0.75);
    opacity: 0.5;
  }
  40% {
    transform: scale(1);
    opacity: 1;
  }
}

.chat-footer {
  padding: 0.75rem 1rem;
  background: #ffffff;
  border-top: 1px solid #e2e8f0;
}

.chat-form {
  display: flex;
  gap: 0.5rem;
  align-items: center;
}

.chat-input {
  flex: 1;
  padding: 0.75rem 1rem;
  border: 1px solid #cbd5e1;
  border-radius: 9999px;
  background: #f8fafc;
  color: #0f172a;
  font-size: 0.9rem;
  outline: none;
  transition: border-color 0.2s ease, background 0.2s ease;
}

.chat-input:focus {
  border-color: rgba(4, 45, 134, 0.4);
  background: #ffffff;
}

.chat-input:disabled {
  opacity: 0.7;
  cursor: not-allowed;
}

.chat-send {
  width: 2.5rem;
  height: 2.5rem;
  display: grid;
  place-items: center;
  border: none;
  border-radius: 9999px;
  background: $brand;
  color: #ffffff;
  cursor: pointer;
  flex-shrink: 0;
  transition: background 0.2s ease, opacity 0.2s ease;
}

.chat-send:hover:not(:disabled) {
  background: #03348f;
}

.chat-send:disabled {
  opacity: 0.6;
  cursor: not-allowed;
}
</style>
