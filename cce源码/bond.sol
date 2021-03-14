pragma solidity >=0.4.25 <0.6.0;
pragma experimental ABIEncoderV2;


contract ERC721 {
    function totalCardSupply() public view returns (uint256 total);
    function balanceCardOf(address _owner) public view returns (uint256 balance);
    function ownerCardOf(uint256 _carId) public view returns (address owner);
    function transfercard(address _to, uint256 _carId) public;

     // Events
    event TransferCard(address from, address to, uint256 cardid);
}

contract Token {

    /// @return total amount of tokens
    function totalSupply() public returns (uint supply) {}

    /// @param _owner The address from which the balance will be retrieved
    /// @return The balance
    function balanceOf(address _owner) public view returns (uint balance) {}

    /// @notice send `_value` token to `_to` from `msg.sender`
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transfer(address _to, uint _value)public returns (bool success) {}

    /// @notice send `_value` token to `_to` from `_from` on the condition it is approved by `_from`
    /// @param _from The address of the sender
    /// @param _to The address of the recipient
    /// @param _value The amount of token to be transferred
    /// @return Whether the transfer was successful or not
    function transferFrom(address _from, address _to, uint _value)public returns (bool success) {}

    /// @notice `msg.sender` approves `_addr` to spend `_value` tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @param _value The amount of wei to be approved for transfer
    /// @return Whether the approval was successful or not
    function approve(address _spender, uint _value)public returns (bool success) {}

    /// @param _owner The address of the account owning tokens
    /// @param _spender The address of the account able to transfer the tokens
    /// @return Amount of remaining tokens allowed to spent
    function allowance(address _owner, address _spender) public returns (uint remaining) {}

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}

contract Context {
    
    mapping (address => uint) balances;
    mapping (address => mapping (address => uint)) allowed;
    
    address payable public owner;
    uint    public totalsupply;
    uint8   public decimals;
    string  public name;
    string  public symbol;
    /*
        0-Common--C
        1-Rare--R
        2-Epic--E
    */
    
    uint256 stakingprofit = 150000 * 10 ** 6;
    uint256 nftprofit = 15000 * 10 ** 6;
    
    string[] words;
    string[] brands;
    string[] chars;
    
    function random(uint _length) internal returns (uint){
        uint256 random = uint256(keccak256(abi.encodePacked(block.difficulty, now)));
        return random%_length;
    }
}

contract CardBase is Context{
    
    uint _dropcount = 15;
    uint256 _interval = 24 hours;
    uint256 time = now +_interval;
    

    event TransferCard(address from, address to, uint256 carId);

    struct Card {
        uint256  id;
        uint     grade;
        string   char;
        string   cardname;
        uint256  time;
        bool     status;
        bool     sellstatus;
    }
    
    struct SellCard {
        uint256 id;
        uint256  cardid;
        uint     grade;
        string   char;
        string   cardname;
        uint256  time;
        uint256  price;
        bool     status;
        uint     Type;
    }
    
    struct ProfitRecord {
        uint     Type;//0-staking,1-nft
        uint256  value;
        uint256  time;
    }
    
    struct StakingRecord {
        uint256  value;
        uint256  surplus;
        uint256  time;
        uint256  bstime;
        uint256  bsurplustime;
        uint256  bsurplusvalue;
    }
    
    struct DropRecord {
        uint     grade;
        string   char;
        string   cardname;
        uint256  time;
        address  user;
    }
    
    struct BoostRecord {
        uint[]     cards;
        uint256    time;
    }
    
    
    
    struct TransferRecord {
        uint256  id;
        uint256  cardid;
        uint     grade;
        string   char;
        string   cardname;
        uint256  status; //0-sell,1-transfer,2-buy
        uint256  price;
        uint256  time;
        uint256  Type;//0-eth,1-token
    }
    
  
    Card[] cards;
    DropRecord[] drops;
    SellCard[]  sellrecords;
    mapping(address => TransferRecord[])  usersellrecords;
    
    mapping(address => ProfitRecord[])  profitrecords;
    
    mapping(address => TransferRecord[])  transferrecords;
    
    mapping(address => BoostRecord[])  userboostrecords;
    
    mapping(address => StakingRecord[])  stakingrecords;
    
    mapping (address => uint256) stakingnumber;
    mapping (address => bool) booststatus;
    mapping (address => uint256) boosttimes;
    
    uint256 totalstaking;
    
    
    mapping (address => uint256) userstakingprofit;
    mapping (address => uint256) usernftprofit;
    
    mapping (address => uint256[]) usergradecount;
    uint256 totalccount;
    uint256 totalrcount;
    uint256 totalecount;
    
    mapping(address => uint256) userccount;
    mapping(address => uint256) userrcount;
    mapping(address => uint256) userecount;


    mapping (uint256 => address) public cardIndexToOwner;
    mapping (address => uint256) ownercardTokenCount;
    
    

    function _transfercard(address _from, address _to, uint256 _cardId) internal {
        if (_from != address(0)) {
            ownercardTokenCount[_from]--;
        }
        ownercardTokenCount[_to]++;
        cardIndexToOwner[_cardId] = _to;
        emit TransferCard(_from, _to, _cardId);
    }
    
   

    function _createCard(uint _grade,string memory _cardname,string memory _char) internal{
        Card memory _card = Card({
            id:cards.length,
            grade:_grade,
            char:_char,
            cardname:_cardname,
            time:now,
            status:false,
            sellstatus:false
        });
        cards.push(_card);
        _transfercard(0x0000000000000000000000000000000000000000, msg.sender, _card.id);
        if(_grade == 10){
            totalccount ++;
            userccount[msg.sender]++;
        }else if(_grade == 12){
            totalrcount ++;
            userrcount[msg.sender]++;
        }else if(_grade == 15){
            totalecount ++;
            userecount[msg.sender]++;
        }
    }
    
    
    function _randDrop() internal{
       if(_dropcount > 0 && now <= time){
           _dropcount--;
           uint _grade = 10;
           uint _rand = random(100);
           if(_rand % 7 == 0){
               if(_rand >= 90){
                   _grade = 12;
               }else if(_rand >= 70){
                   _grade = 15;
               }
           }
           uint _index = random(brands.length);
           string memory _cardname = brands[_index];
           string memory _char = chars[_index];
           _createCard(_grade,_cardname,_char);
           DropRecord memory _drop = DropRecord({
                grade:_grade,
                char:_char,
                cardname:_cardname,
                time:now,
                user:msg.sender
           });
           drops.push(_drop);
       }else{
           _dropcount = 15;
           time = now + _interval;
       }
       
    }
    
    function strconcat(string memory _a, string memory _b) internal returns (string memory){
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ret = new string(_ba.length + _bb.length);
        bytes memory bret = bytes(ret);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++)bret[k++] = _ba[i];
        for (uint j = 0; j < _bb.length; j++) bret[k++] = _bb[j];
        return string(ret);
   }  
}    
    
   
    
contract CardCore is CardBase, ERC721,Token {

    constructor () public {
        words.push("BOND");
        brands.push("CHANEL");
        chars.push("C");
        owner = msg.sender;
        totalsupply = 1000000000 * 10 ** 6; // Give the creator all initial tokens
        decimals = 6;  // Amount of decimals for display purposes
        name = "Le Bond Finance";                                   // Set the name for display purposes
        symbol = "BOND";
        balances[msg.sender] =  totalsupply - 550000000 * 10 ** 6;  // Update total supply
        emit Transfer(0x0000000000000000000000000000000000000000,msg.sender,totalsupply - 550000000 * 10 ** 6);
        emit Transfer(0x0000000000000000000000000000000000000000,address(this),550000000 * 10 ** 6);
    }
    
    function sendprofit() internal{
        if(stakingnumber[msg.sender] > 0){
            uint256 _profit = getstakingprofit(msg.sender);
            require(balances[address(this)] >= _profit);
            userstakingprofit[msg.sender] += _profit;
            balances[msg.sender] += _profit;
            balances[address(this)] -= _profit;
            emit Transfer(address(this),msg.sender,_profit);
        }
        if(balanceCardOf(msg.sender) > 0){
            uint256 _profit = getnftprofit(msg.sender);
            require(balances[address(this)] >= _profit);
            balances[msg.sender] += _profit;
            balances[address(this)] -= _profit;
            usernftprofit[msg.sender] += _profit;
            emit Transfer(address(this),msg.sender,_profit);
        }
        updateuserrec();
    }
    
    function updateuserrec() internal{
        if(stakingnumber[msg.sender] > 0){
            StakingRecord[] memory _stakings = getstakingrecord(msg.sender);
            for(uint i=0;i<_stakings.length;i++){
                StakingRecord memory _staking = _stakings[i];
                if(_staking.bsurplustime > 0 && now > _staking.bstime){
                    _staking.bsurplustime = 0;
                }else{
                    _staking.bsurplustime = 24 hours - (now - _staking.bstime);
                }
                _staking.time = now;
                stakingrecords[msg.sender][i] = _staking;
            }
        }
        Card[] memory _cards = getUserCards(msg.sender);
        for(uint i=0;i<_cards.length;i++){
            Card memory _card = _cards[i];
            if(!_card.sellstatus){
                _card.time = now;
            }
        }
    }
    
    function transfer(address _to, uint _value)public returns (bool) {
        sendprofit();
        //Default assumes totalSupply can't be over max (2^256 - 1).
        require(balances[msg.sender] >= _value && balances[_to] + _value >= balances[_to]);
        balances[msg.sender] -= _value;
        balances[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }

    function transferFrom(address _from, address _to, uint _value)public returns (bool) {
        sendprofit();
        if (balances[_from] >= _value && allowed[_from][msg.sender] >= _value && balances[_to] + _value >= balances[_to]) {
            balances[_to] += _value;
            balances[_from] -= _value;
            allowed[_from][msg.sender] -= _value;
            emit Transfer(_from, _to, _value);
            return true;
        } else { return false; }
    }

    function balanceOf(address _owner) public view returns (uint256) {
        return balances[_owner] + getstakingprofit(_owner) + getnftprofit(_owner);
    }

    function approve(address _spender, uint _value) public returns (bool) {
        sendprofit();
        allowed[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }

    function allowance(address _owner, address _spender) public returns (uint) {
        return allowed[_owner][_spender];
    }
    
    function _validAddress(address _sub) internal view returns (bool) {
        return _sub != 0x0000000000000000000000000000000000000000;
    }

    function _ownscard(address _claimant, uint256 _cardId) internal view returns (bool) {
        return cardIndexToOwner[_cardId] == _claimant;
    }

    function balanceCardOf(address _owner) public view returns (uint256 count) {
        return ownercardTokenCount[_owner];
    }

    function transfercard(address _to, uint256 _cardId) public {
        require(_to != address(0));
        require(_to != address(this));
        require(_ownscard(msg.sender, _cardId));
        _transfercard(msg.sender, _to, _cardId);
        sendprofit();
        Card memory _card = getCard(_cardId);
        TransferRecord memory _transrec = TransferRecord({
            id:sellrecords.length,
            cardid:_card.id,
            grade:_card.grade,
            char:_card.char,
            cardname:_card.cardname,
            status:1,
            price:0,
            time:now,
            Type:0
            
        });
        usersellrecords[msg.sender].push(_transrec);
    }
    
   

     function totalCardSupply() public view returns (uint) {
        return cards.length;
     }
     

    function ownerCardOf(uint256 _cardId) public view returns (address owner) {
        owner = cardIndexToOwner[_cardId];
        require(owner != address(0));
    }
    
   
    function tokensCardOfOwner(address _owner) public view returns(uint256[] memory ownerTokens) {
        uint256 tokenCount = balanceCardOf(_owner);
        if (tokenCount == 0) {
            return new uint256[](0);
        } else {
            uint256[] memory result = new uint256[](tokenCount);
            uint256 totalCards = totalCardSupply();
            uint256 resultIndex = 0;

            uint256 cardId;

            for (cardId = 0; cardId <= totalCards-1; cardId++) {
                if (cardIndexToOwner[cardId] == _owner) {
                    result[resultIndex] = cardId;
                    resultIndex++;
                }
            }
            return result;
        }
    }
    

    function getCard(uint256 _id) public view returns (Card memory) {
        Card memory card = cards[_id];
        return card;
    }
    
    
    function getUserCards(address _owner) public view returns (Card[] memory) {
        Card[] memory cards;
        uint256 cardCount = balanceCardOf(_owner);
        if (cardCount == 0) {
            return cards;
        } else {
            cards = new Card[](cardCount);
            uint256 totalCards = totalCardSupply();
            uint256 resultIndex = 0;

            uint256 cardId;

            for (cardId = 0; cardId <= totalCards-1; cardId++) {
                if (cardIndexToOwner[cardId] == _owner) {
                    cards[resultIndex] = getCard(cardId);
                    resultIndex++;
                }
            }
            return cards;
        }
    }
    
    function pushwords(string memory _word) public returns(bool){
        require(msg.sender == owner);
        words.push(_word);
    }
    
    function getwords() public view returns(string[] memory) {
        return words;
    }
    
    function pushbrands(string memory _char,string memory _brand) public returns(bool){
        require(msg.sender == owner);
        brands.push(_brand);
        chars.push(_char);
    }
    
    function getbrands() public view returns(string[] memory) {
        return brands;
    }
    
    function createCard(string memory _cardname,string memory _char) public returns(bool){
        _createCard(10,_cardname,_char);
    }
    
    function boost(uint256[] memory _cards) public returns (bool) {
        require(!booststatus[msg.sender]);
        sendprofit();
        BoostRecord memory _boostrec = BoostRecord({
            cards:_cards,
            time:now
        });
        string memory _word;
        for(uint i=0;i<_cards.length;i++){
            Card memory _card = getCard(_cards[i]);
            require(_ownscard(msg.sender,_card.id) && !_card.status);
            _word = strconcat(_word,_card.char);
        }
        userboostrecords[msg.sender].push(_boostrec);
        for(uint j=0;j<words.length;j++){
            if(keccak256(abi.encodePacked(words[j])) == keccak256(abi.encodePacked(_word))){
                booststatus[msg.sender] =true;
                boosttimes[msg.sender]++; 
                for(uint i=0;i<_cards.length;i++){
                    Card memory _card = getCard(_cards[i]);
                    _transfercard(msg.sender,0x0000000000000000000000000000000000000000,_card.id);
                }
                return true;
            }
        }
        StakingRecord[] memory _stakings = getstakingrecord(msg.sender);
        for(uint k=0;k<_stakings.length;k++){
            StakingRecord memory _staking = _stakings[k];
            _staking.bstime = now + 24 hours;
            _staking.bsurplustime = 24 hours;
            _staking.bsurplusvalue = _staking.surplus;
            stakingrecords[msg.sender][k] = _staking;
        }
        return false;
    }
    
    
     function getboostrec(address _owner) public view returns (BoostRecord[] memory _boostrec) {
        _boostrec = userboostrecords[_owner];
    }
    
    function staking(uint256 _value) public payable {
        require(balances[msg.sender] >= _value);
        transfer(address(this),_value);
        stakingnumber[msg.sender] += _value;
        totalstaking += _value;
        StakingRecord memory _staking = StakingRecord({
            value:_value,
            surplus:_value,
            time:now,
            bstime:0,
            bsurplustime:0,
            bsurplusvalue:0
        });
        stakingrecords[msg.sender].push(_staking);
        _randDrop();
    }
    
    function unstaking(uint256 _value) public payable returns (bool) {
        require(stakingnumber[msg.sender] >= _value && balances[address(this)] >= _value);
        sendprofit();
        StakingRecord[] memory _stakings = stakingrecords[msg.sender];
        uint256 _num = 0;
        for(uint i=0;i<_stakings.length;i++){
            StakingRecord memory _staking = _stakings[i];
            if(_staking.surplus > 0){
                _num += _staking.surplus;
                if(_num < _value){
                    if(_staking.bstime < now){
                        _staking.bsurplusvalue -= _staking.surplus;
                    }
                    _staking.surplus = 0;
                    stakingrecords[msg.sender][i] = _staking;
                }else{
                    _staking.surplus = _num - _value;
                    if(_staking.bstime < now){
                        _staking.bsurplusvalue = _staking.surplus;
                    }
                    stakingrecords[msg.sender][i] = _staking;
                }
            }
        }
        balances[msg.sender] += _value;
        balances[address(this)] -= _value;
        totalstaking -= _value;
        stakingnumber[msg.sender] -= _value;
        
    }
    
    function sell(uint256 _cardid,uint _type,uint256 _price) public payable returns (bool) {
        require(_ownscard(msg.sender,_cardid));
        Card memory _card = getCard(_cardid);
        require(!_card.status && !_card.sellstatus);
        sendprofit();
        SellCard memory _sell = SellCard({
            id:sellrecords.length,
            cardid:_cardid,
            grade:_card.grade,
            char:_card.char,
            cardname:_card.cardname,
            time:now,
            price:_price,
            status:false,
            Type:_type
        });
        
      
        TransferRecord memory _transrec = TransferRecord({
            id:sellrecords.length,
            cardid:_cardid,
            grade:_card.grade,
            char:_card.char,
            cardname:_card.cardname,
            status:0,
            price:_sell.price,
            time:now,
            Type:_sell.Type
            
        });
        usersellrecords[msg.sender].push(_transrec);
        sellrecords.push(_sell);
        _card.sellstatus = true;
        cards[_card.id] = _card;
    }
    
    function cancel(uint256 _id) public returns (bool) {
        SellCard memory _sellcard = sellrecords[_id];
        Card memory _card = getCard(_sellcard.cardid);
        require(_ownscard(msg.sender,_card.id) && _card.sellstatus);
        sendprofit();
        _sellcard.status = true;
        sellrecords[_id] = _sellcard;
        _card.sellstatus = false;
        cards[_card.id] = _card;
    }
    
    function sellcards() public view returns (SellCard[] memory) {
        return sellrecords;
    }
    
    function getusersellcards(address _owner) public view returns (TransferRecord[] memory) {
        return usersellrecords[_owner];
    }
    
    function buyether(uint256 _id) public payable returns (bool) {
        require(sellrecords.length >= _id);
        SellCard memory _sell = sellrecords[_id];
        require(_sell.status == false);
        require(msg.value == _sell.price);
        sendprofit();
        _sell.status = true;
        sellrecords[_id] = _sell;
        Card memory _card = getCard(_sell.cardid);
        _card.sellstatus = false;
        cards[_card.id] = _card;
        TransferRecord memory _transrec = TransferRecord({
            id:sellrecords.length,
            cardid:_card.id,
            grade:_card.grade,
            char:_card.char,
            cardname:_card.cardname,
            status:1,
            price:_sell.price,
            time:now,
            Type:_sell.Type
            
        });
        usersellrecords[msg.sender].push(_transrec);
        _transfercard(ownerCardOf(_card.id),msg.sender,_card.id);
        address(uint160(ownerCardOf(_card.id))).transfer(msg.value);
    }
    
    function buytoken(uint256 _id,uint256 _value) public payable returns (bool) {
        require(sellrecords.length >= _id);
        SellCard memory _sell = sellrecords[_id];
        require(_sell.status == false);
        _sell.status = true;
        sellrecords[_id] = _sell;
        Card memory _card = getCard(_sell.cardid);
        _card.sellstatus = false;
        cards[_card.id] = _card;
        TransferRecord memory _transrec = TransferRecord({
            id:sellrecords.length,
            cardid:_card.id,
            grade:_card.grade,
            char:_card.char,
            cardname:_card.cardname,
            status:1,
            price:_sell.price,
            time:now,
            Type:_sell.Type
            
        });
        usersellrecords[msg.sender].push(_transrec);
        transfer(address(uint160(ownerCardOf(_card.id))),_sell.price);
        _transfercard(ownerCardOf(_card.id),msg.sender,_card.id);
        address(uint160(ownerCardOf(_card.id))).transfer(msg.value);
    }
    
    
    
   
    function getBoostStatus(address _owner) public view returns (bool ) {
        return booststatus[_owner];
    }
    
    
    function getstakingrecord(address _owner) public view returns (StakingRecord[] memory ) {
        return stakingrecords[_owner];
    }
    
    function getstakingprofit(address _owner) public view returns(uint256){
        StakingRecord[] memory _stakings = stakingrecords[msg.sender];
        uint256 _profit = 0;
        if(stakingnumber[_owner] > 0){
            for(uint i=0;i<_stakings.length;i++){
                StakingRecord memory _staking = _stakings[i];
                if(_staking.surplus > 0){
                   _profit += (now - _staking.time) * stakingprofit * _staking.surplus  / totalstaking /24 hours;
                }
                if(_staking.bsurplusvalue > 0 && _staking.bsurplustime > 0){
                    if(now > _staking.bstime){
                        _profit +=  stakingprofit * _staking.bsurplusvalue  / totalstaking;
                    }else{
                        uint256 _time = now - (_staking.bstime - 24 hours);
                        _profit +=  _time * stakingprofit * _staking.bsurplusvalue  / totalstaking/24 hours;
                        _staking.bsurplustime = 24 hours - _time;
                    }
                }
            }
        }
        return _profit;
    }
    
    function getnftprofit(address _owner) public view returns(uint256){
        Card[] memory _cards = getUserCards(_owner);
        uint _cardcprofit = 0;
        uint _cardrprofit = 0;
        uint _cardeprofit = 0;
        for(uint i=0;i<_cards.length;i++){
            Card memory _card = _cards[i];
            if(!_card.sellstatus){
                if(_card.grade == 10){
                    _cardcprofit += (now - _card.time) * nftprofit / totalccount /24 hours;
                }else if(_card.grade == 12){
                    _cardrprofit += (now - _card.time) * nftprofit * 12 / totalrcount /24 hours/10;
                }else if(_card.grade == 15){
                    _cardeprofit += (now - _card.time) * nftprofit * 15  / totalecount /24 hours/10;
                }
            }
        }
        return _cardcprofit+_cardrprofit+_cardeprofit;
    }
    
    
    function getdailystakingprofit(address _owner) public view returns(uint256){
        StakingRecord[] memory _stakings = stakingrecords[_owner];
        uint256 _profit = 0;
        if(stakingnumber[_owner] > 0){
            for(uint i=0;i<_stakings.length;i++){
                StakingRecord memory _staking = _stakings[i];
                if(_staking.surplus > 0){
                   _profit += stakingprofit * _staking.surplus  / totalstaking ;
                }
            }
        }
       
        return _profit;
    }
    
    function getdailynftprofit(address _owner) public view returns(uint256){
       
        Card[] memory _cards = getUserCards(_owner);
        uint _cardcprofit = 0;
        uint _cardrprofit = 0;
        uint _cardeprofit = 0;
        for(uint i=0;i<_cards.length;i++){
            Card memory _card = _cards[i];
            if(!_card.sellstatus){
                if(_card.grade == 10){
                    _cardcprofit += nftprofit/ totalccount;
                }else if(_card.grade == 12){
                    _cardrprofit += nftprofit * 12/ totalrcount/10;
                }else if(_card.grade == 15){
                    _cardeprofit += nftprofit * 15 / totalecount/10;
                }
            }
        }
        return _cardcprofit +_cardrprofit +_cardeprofit;
    }
    
    
    function indexstakinginfo(address _owner) public view returns(uint256[4] memory _indexinfo,Card[] memory _cards,DropRecord[] memory _drops,uint256 _times){
        _indexinfo[0] = totalstaking;
        _indexinfo[1] = userstakingprofit[_owner] + getstakingprofit(_owner) ;
        _indexinfo[2] = getdailystakingprofit(_owner);
        _indexinfo[3] = stakingnumber[_owner];
        _cards = getUserCards(_owner);
        _drops = drops;
        _times = boosttimes[_owner];
    }
    
    function indexnftinfo(address _owner) public view returns(uint256[2] memory _indexinfo,Card[] memory _cards,TransferRecord[] memory _trans){
        _indexinfo[0] = usernftprofit[_owner] + getnftprofit(_owner);
        _indexinfo[1] = getdailynftprofit(_owner);
        _cards = getUserCards(_owner);
        _trans = usersellrecords[_owner];
    }
    
}