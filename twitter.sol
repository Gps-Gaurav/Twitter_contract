// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract TweetContract {
    struct Tweet {
        uint256 id;
        address author;
        string content;
        uint256 createdAt;
    }

    struct Message {
        uint256 id;
        string content;
        address from;
        address to;
        uint256 createdAt;
    }

    mapping(uint256 => Tweet) public tweets;

    mapping(address => uint256[]) public tweetsOf; //0xabc - 2,10,15,19,20,22

    mapping(address => Message[]) public conversations;

    mapping(address => mapping(address => bool)) public operators;

    mapping(address => address[]) public following;

    uint256 nextId; //0

    uint256 nextMessageId;

    function _tweet(address _from, string memory _content) internal {
        //tweet access check - owner,authority
        require(
            _from == msg.sender || operators[_from][msg.sender],
            "You don't have access"
        );

        tweets[nextId] = Tweet(nextId, _from, _content, block.timestamp);

        tweetsOf[_from].push(nextId);

        nextId = nextId + 1;
    }

    function _sendMessage(address _from, address _to, string memory _content)
        internal
    {
        //tweet access check - owner,authority
        require(
            _from == msg.sender || operators[_from][msg.sender],
            "You don't have access"
        );

        conversations[_from].push(
            Message(nextMessageId, _content, _from, _to, block.timestamp)
        );

        nextMessageId++;
    }

    function tweet(string memory _content) public {
        //owner
        _tweet(msg.sender, _content);
    }

    function tweet(address _from, string memory _content) public {
        //owner->address access
        _tweet(_from, _content);
    }

    function sendMessage(string memory _content, address _to) public {
        //owner
        _sendMessage(msg.sender, _to, _content);
    }

    function sendMessage(address _from, address _to, string memory _content)
        public
    {
        //owner - address access
        _sendMessage(_from, _to, _content);
    }

    function follow(address _followed) public {
        //abc - def,ghi,opr
        following[msg.sender].push(_followed);
    }


}
