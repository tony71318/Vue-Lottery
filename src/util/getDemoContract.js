import Web3 from 'web3'
import {demoAddress, demoABI} from './constants/demoLottoContract'

let getDemoContract = new Promise(function (resolve, reject) {
  let web3 = new Web3(window.web3.currentProvider)
  let casinoContract = web3.eth.contract(demoABI)
  let casinoContractInstance = casinoContract.at(demoAddress)
  console.log(casinoContract)
  console.log(casinoContractInstance)
  resolve(casinoContractInstance)
})

export default getDemoContract
