<template>
  <div class="lotto">
    <h3><b-badge variant="info">買了一定會中哦</b-badge></h3>
    <h5>下注金額: <input v-model="amount" placeholder="0 Ether"></h5>
    <b-button variant="primary" v-on:click = "bet">買樂透</b-button>
    <hr>

    <div class='contract-info'>
      <h5>樂透號碼: <h1><b-badge v-if="OwnedDicingResult" variant="info">
        <font-awesome-icon v-if="dice[0]" :icon="['fa', 'dice-' + dice[0]]" /> <font-awesome-icon v-if="dice[1]" :icon="['fa', 'dice-' + dice[1]]" /> <font-awesome-icon v-if="dice[2]" :icon="['fa', 'dice-' + dice[2]]" /></b-badge></h1>
      </h5>
      <h5>樂透擁有者: <b-badge variant="success">{{ owner }}</b-badge></h5>
      <h5>樂透贏家: <b-badge id="winner" variant="success">{{ winner }}</b-badge></h5>
      <h5>累積獎金: <b-badge v-if="ethBalance" variant="success">{{ ethBalance }} Eth</b-badge></h5>
      <h5>累積人數: <b-badge variant="success">{{ playerCount }}</b-badge></h5>
      <h5>區塊高度: <b-badge variant="success">{{ currentBlockNumber }}</b-badge></h5>
      <b-button variant="primary" v-on:click = "getContractInfo">更新合約資訊</b-button>
    </div>
    <hr>

    <img v-if="pending" id="loader" src="https://loading.io/spinners/double-ring/lg.double-ring-spinner.gif">
    <div class="event" v-if="winEvent">
      <h5>您的號碼: <h1><b-badge v-if="PlayerDicingResult" variant="info">
        <font-awesome-icon v-if="playerDice[0]" :icon="['fa', 'dice-' + playerDice[0]]" /> <font-awesome-icon v-if="playerDice[1]" :icon="['fa', 'dice-' + playerDice[1]]" /> <font-awesome-icon v-if="playerDice[2]" :icon="['fa', 'dice-' + playerDice[2]]" /></b-badge></h1>
      </h5>
      <h5 v-if="winEvent._status" id="has-won"><i aria-hidden="true" class="fa fa-check"></i> 大吉大利, 你贏得 {{winEvent._amount}} Eth</h5>
      <h5 v-else id="has-lost"><b-badge variant="danger"><i aria-hidden="true" class="fa fa-times"></i> 太可惜啦，在試一次吧</b-badge></h5>
      <b-button v-if="winEvent._status" variant="success" v-on:click = "withdraw">領取獎金</b-button>
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
      balance: '',
      ethBalance: '',
      playerCount: '',
      OwnedDicingResult: '',
      PlayerDicingResult: '',
      winner: null,
      currentBlockNumber: null,

      dice: [],
      playerDice: []

    }
  },
  methods: {
    bet (event) {
      this.getBlockInfo()
      console.log('BETTING ON Lottery, AMOUNT = ', this.amount)
      this.winEvent = null
      this.pending = true
      this.$store.state.demoContractInstance().PlayerDicing({
        gas: 300000,
        value: this.$store.state.web3.web3Instance().toWei(this.amount, 'ether'),
        from: this.$store.state.web3.coinbase
      }, (err, result) => {
        if (err) {
          console.log(err)
          this.pending = false
        } else {
          let Won = this.$store.state.demoContractInstance().Won({}, {fromBlock: '3396274', toBlock: 'latest'})
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
    withdraw (event) {
      this.getBlockInfo()
      // console.log('withdraw ether', this.winEvent._amount)
      this.$store.state.demoContractInstance().withdraw({
        gas: 300000,
        from: this.$store.state.web3.coinbase
      }, (err, result) => {
        if (err) {
          console.log(err)
        } else {
          console.log(result)
        }
      })
    },
    getContractInfo () {
      this.$store.state.demoContractInstance().owner.call((error, result) => {
        if (error) {
          console.log(error)
        }
        this.owner = result
      })
      this.$store.state.demoContractInstance().getBalance((error, result) => {
        if (error) {
          console.log(error)
        }
        result = parseInt(result)
        this.balance = result
        this.ethBalance = this.$store.state.web3.web3Instance().fromWei(result, 'ether')
      })
      this.$store.state.demoContractInstance().getPlayerCount((error, result) => {
        if (error) {
          console.log(error)
        }
        result = parseInt(result)
        this.playerCount = result
      })
      this.$store.state.demoContractInstance().OwnedDicingResult((error, result) => {
        if (error) {
          console.log(error)
        }
        this.OwnedDicingResult = result.c[0]
        let tempResult = this.OwnedDicingResult.toString()
        for (let i = 0; i < tempResult.length; i++) {
          if (tempResult.charAt(i) === '1') {
            this.dice[i] = 'one'
          }
          if (tempResult.charAt(i) === '2') {
            this.dice[i] = 'two'
          }
          if (tempResult.charAt(i) === '3') {
            this.dice[i] = 'three'
          }
          if (tempResult.charAt(i) === '4') {
            this.dice[i] = 'four'
          }
          if (tempResult.charAt(i) === '5') {
            this.dice[i] = 'five'
          }
          if (tempResult.charAt(i) === '6') {
            this.dice[i] = 'six'
          }
        }
      })
      this.$store.state.demoContractInstance().PlayerDicingResult((error, result) => {
        if (error) {
          console.log(error)
        }
        this.PlayerDicingResult = result.c[0]
        let tempResult = this.PlayerDicingResult.toString()
        for (let i = 0; i < tempResult.length; i++) {
          if (tempResult.charAt(i) === '1') {
            this.playerDice[i] = 'one'
          }
          if (tempResult.charAt(i) === '2') {
            this.playerDice[i] = 'two'
          }
          if (tempResult.charAt(i) === '3') {
            this.playerDice[i] = 'three'
          }
          if (tempResult.charAt(i) === '4') {
            this.playerDice[i] = 'four'
          }
          if (tempResult.charAt(i) === '5') {
            this.playerDice[i] = 'five'
          }
          if (tempResult.charAt(i) === '6') {
            this.playerDice[i] = 'six'
          }
        }
      })
      this.$store.state.demoContractInstance().getWinner((error, result) => {
        if (error) {
          console.log(error)
        }
        // eslint-disable-next-line
        if (result == this.owner) {
          this.winner = '無人中獎'
        } else {
          this.winner = result
        }
      })
      // Block~~~~~~~~~~
      this.getBlockInfo()
      // getEvent
      let Won = this.$store.state.demoContractInstance().Won({}, {fromBlock: '3396100', toBlock: 'latest'})
      Won.get((err, result) => {
        if (err) {
          console.log('could not get event Won()')
        } else {
          console.log(result)
        }
      })
    },
    getBlockInfo () {
      this.$store.state.web3.web3Instance().eth.getBlockNumber((error, result) => {
        if (error) {
          console.log(error)
        }
        this.currentBlockNumber = result
      })
    }
  },
  mounted () {
    console.log('dispatching getDemoContractInstance')
    this.$store.dispatch('getDemoContractInstance').then(() => {
      this.getContractInfo()
    })
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
