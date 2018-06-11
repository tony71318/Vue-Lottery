<template>
  <div id="app" class="main">
    <router-view/>
  </div>
</template>

<script>
export default {
  name: 'App'
}
</script>

<style>
.container {
 padding-right: 15px;
 padding-left: 15px;
 margin-right: auto;
 margin-left: auto;
}
@media (min-width: 768px) {
 .container {
 width: 750px;
 }
}

.main{
  text-align: center;
  padding-top: 2%;
  padding-bottom: 2%;
  font-family: '微軟正黑體';
}

</style>
