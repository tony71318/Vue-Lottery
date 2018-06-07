/* eslint-disable */
const address = '0xd15bd3755e46b50688668011da28d0e7b59d280c'
const ABI = [
	{
		"constant": true,
		"inputs": [],
		"name": "checkContractBalance",
		"outputs": [
			{
				"name": "",
				"type": "uint256"
			}
		],
		"payable": false,
		"stateMutability": "view",
		"type": "function"
	},
	{
		"anonymous": false,
		"inputs": [
			{
				"indexed": false,
				"name": "_status",
				"type": "bool"
			},
			{
				"indexed": false,
				"name": "_amount",
				"type": "uint256"
			}
		],
		"name": "Won",
		"type": "event"
	},
	{
		"constant": false,
		"inputs": [
			{
				"name": "_number",
				"type": "uint256"
			}
		],
		"name": "bet",
		"outputs": [],
		"payable": true,
		"stateMutability": "payable",
		"type": "function"
	},
	{
		"constant": false,
		"inputs": [],
		"name": "kill",
		"outputs": [],
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "function"
	},
	{
		"inputs": [
			{
				"name": "_minBet",
				"type": "uint256"
			},
			{
				"name": "_houseEdge",
				"type": "uint256"
			}
		],
		"payable": true,
		"stateMutability": "payable",
		"type": "constructor"
	},
	{
		"payable": false,
		"stateMutability": "nonpayable",
		"type": "fallback"
	}
]

export {address, ABI}
