<template>
  <div class="profile-container">
    <div class="card">

      <img
        class="foto"
        :src="profileImg"
        alt="Foto Profil"
      >

      <h1>Muhammad Fawaizul Umam Al Azis</h1>
      <p class="nim">NIM : 230411100001</p>

      <hr>

      <table>
        <tr>
          <td>Program Studi</td>
          <td>: Teknik Informatika</td>
        </tr>

        <tr>
          <td>Universitas</td>
          <td>: Universitas Nurul Jadid</td>
        </tr>

        <tr>
          <td>Email</td>
          <td>: umam@email.com</td>
        </tr>

        <tr>
          <td>No HP</td>
          <td>: 08xxxxxxxxxx</td>
        </tr>

        <tr>
          <td>Alamat</td>
          <td>: Probolinggo, Jawa Timur</td>
        </tr>

        <tr>
          <td>Hobi</td>
          <td>: Coding, Desain, Membaca</td>
        </tr>

        <tr>
          <td>Cita-cita</td>
          <td>: Full Stack Developer</td>
        </tr>
      </table>

      <button>Edit Profil</button>

    </div>
  </div>
</template>

<script setup>
import profileImg from '../assets/profile-penobatan.jpg';
</script>

<style scoped>
.profile-container{
    display:flex;
    justify-content:center;
    align-items:center;
    background:#f4f4f4;
    min-height:100vh;
}

.card{
    width:500px;
    background:white;
    padding:30px;
    border-radius:15px;
    box-shadow:0 5px 20px rgba(0,0,0,.2);
}

.foto{
    width:100%;
    max-height:240px;
    object-fit:cover;
    border-radius:12px;
    display:block;
    margin:auto;
}

h1{
    text-align:center;
    margin-top:15px;
}

.nim{
    text-align:center;
    color:gray;
}

table{
    width:100%;
    margin-top:20px;
}

td{
    padding:8px;
}

button{
    width:100%;
    margin-top:25px;
    padding:12px;
    background:#42b883;
    color:white;
    border:none;
    border-radius:8px;
    cursor:pointer;
    font-size:16px;
}

button:hover{
    background:#2f9c6b;
}
</style>