<template>
  <div class="bg">
    <h1 v-on:click="changePage">區塊鏈大樂透</h1>
    <!-- <h4>決定下注金額</h4> -->
    <!-- <navbar/> -->
    <hello-metamask/>
    <!-- <casino-component/> -->
    <component :is="view"></component>
  </div>
</template>
<script>
import navbar from '@/components/navbar'
import HelloMetamask from '@/components/hello-metamask'
import CasinoComponent from '@/components/casino-component'
import LottoComponent from '@/components/lotto-component'
import DemoLottoComponent from '@/components/demo-lotto-component'
export default {
  name: 'casino-dapp',
  data () {
    return {
      view: 'lotto-component'
    }
  },
  methods: {
    changePage () {
      // eslint-disable-next-line
      if (this.view == 'lotto-component') {
        this.view = 'demo-lotto-component'
      } else {
        this.view = 'lotto-component'
      }
    }
  },
  beforeCreate () {
    console.log('registerWeb3 Action dispatched from casino-dapp.vue')
    this.$store.dispatch('registerWeb3')
  },
  components: {
    'hello-metamask': HelloMetamask,
    'casino-component': CasinoComponent,
    'lotto-component': LottoComponent,
    'demo-lotto-component': DemoLottoComponent,
    'navbar': navbar
  }
}
</script>

<style>
  body {
  background-image: url('../assets/casino.jpg');
}
</style>

<style scoped>

  .bg{
    background-color: rgba(255, 255, 255, 0.5);
    width:60%;
    display: inline-block;
    padding: 1em;
  }

</style>
