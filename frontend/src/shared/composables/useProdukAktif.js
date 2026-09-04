import { ref } from 'vue'

export function useProdukAktif() {
  const produkAktif = ref(null)

  const pilihProduk = (produk) => {
    produkAktif.value = produk
  }

  const reset = () => {
    produkAktif.value = null
  }

  return {
    produkAktif,
    pilihProduk,
    reset
  }
}
