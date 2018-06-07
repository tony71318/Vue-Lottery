<template>
  <div class="lotto container">
    <h1>區塊鏈大樂透</h1>
    <h4>決定下注金額</h4>
    下注金額: <input v-model="amount" placeholder="0 Ether">
    <b-button size="sm" variant="primary" v-on:click = "bet">買樂透</b-button>

    <div class='contract-info'>
      <p>樂透號碼: <b-badge variant="danger">{{ OwnedDicingResult }}</b-badge></p>
      <p>樂透擁有者: <b-badge variant="success">{{ owner }}</b-badge></p>
      <p>累積獎金: <b-badge variant="success">{{ ethBalance }} Eth</b-badge></p>
      <p>累積人數: <b-badge variant="success">{{ playerCount }}</b-badge></p>
      <b-button variant="primary" v-on:click = "getContractInfo">更新合約資訊</b-button>
    </div>
    <img v-if="pending" id="loader" src="https://loading.io/spinners/double-ring/lg.double-ring-spinner.gif">
    <div class="event" v-if="winEvent">
      <p>您的號碼: {{ PlayerDicingResult }}</p>
      <p v-if="winEvent._status" id="has-won"><i aria-hidden="true" class="fa fa-check"></i> 大吉大利, 你贏得 {{winEvent._amount}} Eth</p>
      <p v-else id="has-lost"><i aria-hidden="true" class="fa fa-times"></i> 太可惜啦，在試一次吧</p>
    </div>
  </div>
</template>

<script>
import {mapState} from 'vuex'
export default {
  name: 'lotto',
  computed: mapState({
    coinbase: state => state.web3.coinbase
  }),
  data () {
    return {
      amount: null,
      pending: false,
      winEvent: null,

      owner: '',
      balance: 0,
      ethBalance: 0,
      playerCount: 0,
      OwnedDicingResult: '',
      PlayerDicingResult: ''
    }
  },
  methods: {
    bet (event) {
      console.log('BETTING ON Lottery, AMOUNT = ', this.amount)
      this.winEvent = null
      this.pending = true
      this.$store.state.contractInstance().PlayerDicing({
        gas: 300000,
        value: this.$store.state.web3.web3Instance().toWei(this.amount, 'ether'),
        from: this.$store.state.web3.coinbase
      }, (err, result) => {
        if (err) {
          console.log(err)
          this.pending = false
        } else {
          let Won = this.$store.state.contractInstance().Won()
          Won.watch((err, result) => {
            if (err) {
              console.log('could not get event Won()')
            } else {
              console.log(result)
              this.winEvent = result.args
              this.winEvent._amount = this.$store.state.web3.web3Instance().fromWei(result.args._amount, 'ether')
              this.pending = false
            }
          })
        }
      })
    },
    getContractInfo () {
      this.$store.state.contractInstance().owner.call((error, result) => {
        if (error) {
          console.log(error)
        }
        this.owner = result
      })
      this.$store.state.contractInstance().getBalance((error, result) => {
        if (error) {
          console.log(error)
        }
        result = parseInt(result)
        this.balance = result
        this.ethBalance = this.$store.state.web3.web3Instance().fromWei(result, 'ether')
      })
      this.$store.state.contractInstance().getPlayerCount((error, result) => {
        if (error) {
          console.log(error)
        }
        result = parseInt(result)
        this.playerCount = result
      })
      this.$store.state.contractInstance().OwnedDicingResult((error, result) => {
        if (error) {
          console.log(error)
        }
        this.OwnedDicingResult = result.c[0]
      })
      this.$store.state.contractInstance().PlayerDicingResult((error, result) => {
        if (error) {
          console.log(error)
        }
        this.PlayerDicingResult = result.c[0]
      })
      // let Won = this.$store.state.contractInstance().Won({fromBlock: '3391700', toBlock: 'latest'})
      // Won.get((err, result) => {
      //   if (err) {
      //     console.log('could not get event Won()')
      //   } else {
      //     console.log(result)
      //   }
      // })
    }
  },
  mounted () {
    console.log('dispatching getContractInstance')
    this.$store.dispatch('getContractInstance')
  }
}
</script>

<style scoped>
.casino {
     margin-top: 50px;
     text-align:center;
}
#loader {
  width:150px;
}
ul {
    margin: 25px;
    list-style-type: none;
    display: grid;
    grid-template-columns: repeat(5, 1fr);
    grid-column-gap:25px;
    grid-row-gap:25px;
}
li{
    padding: 20px;
    margin-right: 5px;
    border-radius: 50%;
    cursor: pointer;
    background-color:#fff;
    border: -2px solid #bf0d9b;
    color: #bf0d9b;
    box-shadow:3px 5px #bf0d9b;
}
li:hover{
    background-color:#bf0d9b;
    color:white;
    box-shadow:0px 0px #bf0d9b;
}
li:active{
    opacity: 0.7;
}

#has-won {
  color: green;
}
#has-lost {
  color:red;
}

.contract-info {
  text-align:center;
}

.lotto {
     margin-top: 50px;
     text-align:center;
}
</style>
