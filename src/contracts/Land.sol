// SPDX-Liense-Identifier: MIT
pragma solidity ^0.8.0;


//NFT contract, we will implement ERC721 from open openzeppelin
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract Land is ERC721{
    uint256 public cost = 1 ether; //256 byts of memory, positive number
    uint256 public maxSupply = 5;
    uint256 public totalSupply = 0;

    struct Building{
        string name;
        address owner;
        int256 posX;
        int256 posY;
        int256 posZ;
        uint256 sizeX;
        uint256 sizeY;
        uint256 sizeZ;
    }

    Building[] public buildings;

    constructor(string memory _name, string memory _symbol, uint256 _cost) ERC721(_name, _symbol) {
        cost = _cost;
        // address 0x0 meaning that this building does not bellong to anyone
        buildings.push(
            Building('City Hall', address(0x0), 0,0,0, 10, 10, 10)
        );
        buildings.push(
            Building('Stadium', address(0x0), 0,10,0, 10, 5, 3)
        );
        buildings.push(
            Building('University', address(0x0), 0,-10,0, 10, 5, 3)
        );
        buildings.push(
            Building('Shopping Plaza 1', address(0x0), 10,0,0, 5, 25, 5)
        );
        buildings.push(
            Building('Shopping Plaza 2', address(0x0), -10,0,0, 5, 25, 5)
        );
    }

    //This function is payable meaning you can send money to this function
    function mint(uint256 _id) public payable {
        uint256 supply = totalSupply;
        require(supply <= maxSupply ); // is the condition is not true the transaction will be reverted.
        require(buildings[_id -1].owner == address(0x0));
        //msg.value is the amount of eth that you sent to that payable function
        require(msg.value >= cost);

        //msg.sender contains the address of the invoker of this function
        buildings[_id - 1].owner = msg.sender;
        totalSupply = totalSupply + 1;
        _safeMint(msg.sender, _id); // a function from the ERC721 contract, handle buying the virtual land
    }

    //overrride is used when we want to overrride an already implemented function from the interface
    function transferFrom(address _from, address _to, uint256 tokenId) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId),
        "ERC721: transfer caller is not owner nor approved"
        );

        buildings[tokenId -1].owner = _to; //update building ownership
        _transfer(_from, _to, tokenId); // actual transfer function
    }

    function safeTransferFrom(address _from, address _to, uint256 tokenId, bytes memory _data) public override {
        require(_isApprovedOrOwner(_msgSender(), tokenId),
        "ERC721: transfer caller is not owner nor approved"
        );

        buildings[tokenId -1].owner = _to; //update building ownership
        _safeTransfer(_from, _to, tokenId, _data); // actual transfer function
    }

    // view is a key ward to indicate that we just reading from the blockchain and not updating it
    function getBuildings() public view returns(Building[] memory ) {
        return buildings;
    }

    function getBuilding(uint256 _id) public view returns (Building memory) {
        return buildings[_id -1];
    }
}