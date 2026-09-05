import { ref } from 'vue';

export function useNotification() {
  const message = ref('');

  function notify(text) {
    message.value = text;
    setTimeout(() => {
      message.value = '';
    }, 3000);
  }

  return { message, notify };
}
