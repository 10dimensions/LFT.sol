// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";


contract EarthTokens is ERC1155 {

    struct gridResource{
        string resourceType;
        uint256 amount;
        string units;
    }

    struct gridData{
        uint256 minLat;
        uint256 maxLat;
        uint256 minLon;
        uint256 maxLon;

        string URL;
        gridResource[] resources;
    }

    struct gridLicense{
        uint32 licenseId;                                                
        uint256 plotId;
        
        uint256 minLat;
        uint256 maxLat;
        uint256 minLon;
        uint256 maxLon;

        string name;
        string URL;
    }

    uint256 public constant PLOT = 1;

    address public governance;
    uint256 public gridCount;
    
    mapping(uint256 => gridData) public gridMetaData;
    mapping(uint256 => gridLicense) public gridLicense;

    modifier onlyGovernance() {
        require(msg.sender == governance, "only governance can call this");
        
        _;
    }

    constructor(address governance_) public ERC1155("") {
        governance = governance_;
        gridCount = 0;
    }
    
    function mintPlot(uint256 initialSupply) public {
        gridCount++;
        uint256 earthTokenClassId = gridCount;

        _mint(msg.sender, earthTokenClassId, initialSupply, "");        
    }

    function addResource() public {
        
    }
}