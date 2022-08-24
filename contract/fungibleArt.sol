//SPDX-License-Identifier: MIT
// File: contracts/fungibleArt.sol

/*==================================================
   _   _   _   _   _   _   _   _     _   _   _  
  / \ / \ / \ / \ / \ / \ / \ / \   / \ / \ / \ 
 ( F | u | n | g | i | b | l | e ) ( A | r | t )
  \_/ \_/ \_/ \_/ \_/ \_/ \_/ \_/   \_/ \_/ \_/ 

 * A possibly scarce tokenized art.
 * Initial liquidity on Spookyswap: 1 fART / 1 FTM

====================================================*/

pragma solidity ^0.8.12;

/**
 * @title fungibleArt
 * @author FantomPocong
 */

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract fungibleArt is ERC20, Ownable {

    uint256 public maxSupply = 1618 ether;

    mapping(address => bool) public hasCollected;

    error fARTisMintOut();
    error HasCollected();

    constructor() ERC20("fungibleArt", "fART") {
        // Owner gets 1 fART when deploying this contract 
        _mint(msg.sender, 1 ether);
    }

    /* Owner can collect a maximum of 1 more fART after deploying this contract,
     * that 1 more fART will be paired with 1 FTM on SpookySwap as initial liquidity.
     * fART is a free mint project, but donations are possible through this function.
    */
    function collectFART() external payable {
        uint256 supply = totalSupply();
        if(supply + 1 > maxSupply) revert fARTisMintOut();
        if(hasCollected[msg.sender]) revert HasCollected();
        hasCollected[msg.sender] = true;

        _mint(msg.sender, 1 ether);
    }
    
    function withdrawDonation() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function withdrawERC20Tokens(address tokenAddress) external onlyOwner {
        uint256 tokenAmount = IERC20(tokenAddress).balanceOf(address(this));
        IERC20(tokenAddress).transfer(owner(), tokenAmount);
    }
}
