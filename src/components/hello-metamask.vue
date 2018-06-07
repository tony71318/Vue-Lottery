<template>
  <div class='metamask-info'>
    <b-badge v-if="isInjected" variant="success">Metamask installed</b-badge>
    <b-badge v-else variant="danger">Metamask installed</b-badge>
    <p><b-badge variant="success">{{ network }}</b-badge></p>
    <p>您的地址: <b-badge variant="success">{{ coinbase }}</b-badge></p>
    <p>您的餘額: <b-badge variant="success">{{ ethBalance }} Eth</b-badge></p>
  </div>
</template>

<script>
import {NETWORKS} from '../util/constants/networks'
import {mapState} from 'vuex'
export default {
  name: 'hello-metamask',
  computed: mapState({
    isInjected: state => state.web3.isInjected,
    network: state => NETWORKS[state.web3.networkId],
    coinbase: state => state.web3.coinbase,
    balance: state => state.web3.balance,
    ethBalance: state => {
      if (state.web3.web3Instance !== null) return state.web3.web3Instance().fromWei(state.web3.balance, 'ether')
    }
  })
}
</script>

<style scoped>
.metamask-info {
  text-align:center;
}
#has-metamask {
  color: green;
}
#no-metamask {
  color:red;
}</style>
