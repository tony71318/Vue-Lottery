pragma solidity ^0.4.18;

contract Lottogame {
    // 樂透發起者地址
    address public owner;
    // 贏家地址
    address public winner;
    // 玩家對應資料
    struct Player {
        address addr; // 玩家地址
        uint amount;  // 儲值總額
    }
    // 初始化樂透與玩家骰子
    uint [3] Ownedrandom = [0, 0, 0];
    uint [3] Playerrandom = [0, 0, 0];
    uint randNonce = 0;
    //
    event transfer(address indexed _from, address indexed _to, uint indexed value);

    // 樂透結果確定, 並先將樂透發起者與贏家的變數給予發起遊戲者
    function Lottogame() payable public {
        // 樂透發起者可以先存錢進合約內當作獎勵
        address current = this;
        uint value = msg.value;
        transfer(msg.sender, current, value);
        owner = msg.sender;
        winner = msg.sender;
        OwnedDicing();
    }
    // 決定樂透結果, 函數設為private
    function OwnedDicing() private {
    // 生成3個 1~3 的隨機數:
        for(uint i =0; i<3; i++) {
            Ownedrandom[i] = (uint(keccak256(block.number, now, msg.sender, randNonce)) % 3) + 1;
            randNonce++;
        }
        randNonce = 0;
    }
    // 玩家骰值函數
    function PlayerDicing() payable public returns (bool) {
        // 先付錢
        address current = this;
        uint value = msg.value;
        if(value != 1 ether)
            return false;
        transfer(msg.sender, current, value);
        // 生成3個 1~3 的隨機數:
        for(uint i =0; i<3; i++) {
            Playerrandom[i] = (uint(keccak256(block.number, now, msg.sender, randNonce)) % 3) + 1;
            randNonce++;
        }
        if(CheckResult(Playerrandom[0], Playerrandom[1], Playerrandom[2])==true) {
            winner = msg.sender;
        }
        randNonce = 0;
        return true;
    }

    // 骰出的結果與樂透相同返回true
    function CheckResult(uint random0, uint random1, uint random2) constant public returns (bool){
        bool state1 = false;
        bool state2 = false;
        if(random0==Ownedrandom[0])
            state1 = true;
            else if(random1==Ownedrandom[1])
                state2 = true;
                else if(random2==Ownedrandom[2])
                    return true;
        return false;
    }
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
    modifier onlyWinner {
        require(msg.sender == winner);
        _;
    }
    // 取得合約內已投入多少錢
    function getBalance() constant returns (uint) {
      return this.balance;
    }
    function deposit() payable {
        address current = this;
        uint value = msg.value;
        transfer(msg.sender, current, value);
    }
    function fee() payable {
        require(msg.value==5 ether);
        address current = this;
        uint value = msg.value;
        transfer(msg.sender, current, value);
    }
    // 贏家可以領錢
    function withdraw() payable onlyWinner {
        winner = msg.sender;
        uint fee = this.balance;
        owner.transfer(fee*1/10);
        winner.transfer(this.balance);
    }
    function kill() {
        if ((msg.sender==owner)||(this.balance==0))
        selfdestruct(owner);
    }
    function getWinner() constant returns (address) {
      return winner;
    }
    function getOwner() constant returns (address) {
      return owner;
    }
    function getAddress() constant returns (address) {
      address value = msg.sender;
      return value;
    }

    // 顯示樂透結果
    function OwnedDicingResult() constant returns (uint) {
        uint Ownedresult = 100*Ownedrandom[0] + 10*Ownedrandom[1] + Ownedrandom[2];
        return Ownedresult;
    }
    function OwnedDicingResult0() constant returns (uint) {
        return Ownedrandom[0];
    }
    function OwnedDicingResult1() constant returns (uint) {
        return Ownedrandom[1];
    }
    function OwnedDicingResult2() constant returns (uint) {
        return Ownedrandom[2];
    }
    function PlayerDicingResult() constant returns (uint) {
        uint Playerresult = 100*Playerrandom[0] + 10*Playerrandom[1] + Playerrandom[2];
        return Playerresult;
    }
    function PlayerDicingResult0() constant returns (uint) {
        return Playerrandom[0];
    }
    function PlayerDicingResult1() constant returns (uint) {
        return Playerrandom[1];
    }
    function PlayerDicingResult2() constant returns (uint) {
        return Playerrandom[2];
    }

}
