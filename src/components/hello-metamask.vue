<template>
  <div class='metamask-info'>
    <div>
      <b-badge v-if="isInjected" variant="success"><i aria-hidden="true" class="fa fa-check"></i> Metamask installed</b-badge>
      <b-badge v-else variant="danger"><i aria-hidden="true" class="fa fa-times"></i> Metamask not found</b-badge>
      <b-badge variant="success"><i aria-hidden="true" class="fa fa-check"></i> {{ network }}</b-badge>
    </div>
    <br>

    <h5 class="no_margin">您的地址:</h5>
    <h5><b-badge variant="success"><i class="fa fa-address-card-o"></i> {{ coinbase }}</b-badge></h5>
    <h5 class="no_margin">您的餘額:</h5>
    <h5><b-badge variant="success"><i class="fa fa-usd"></i> {{ ethBalance }} Eth</b-badge></h5>
    <hr>
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
}
.no_margin{
  margin-bottom: 0;
}
</style>
