pragma solidity ^0.5.0;

import "./PupperCoin.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/Crowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/emission/MintedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/CappedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/validation/TimedCrowdsale.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v2.5.0/contracts/crowdsale/distribution/RefundablePostDeliveryCrowdsale.sol";

// @TODO: Inherit the crowdsale contracts
contract PupperCoinCrowdSale is Crowdsale, MintedCrowdsale, CappedCrowdsale, TimedCrowdsale, RefundablePostDeliveryCrowdsale {


    constructor(
        // @TODO: Fill in the constructor parameters!
    //In our case, we can use constructor(uint rate, address payable wallet, PupperCoin token) since PupperCoin is compatible with 
    // the ERC20 interface (IERC20) that the crowdsale contract requires.
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal,
        uint cap,
        uint rate,
        uint openingTime,
        uint closingTime,
        PupperCoin token
    )
    
    
        // @TODO: Pass the constructor parameters to the crowdsale contracts.
        // You will need to pass in the parameters from the main constructor to the secondary Crowdsale constructor.
        // The body of the constructor can stay empty since all of the logic is inherited from Crowdsale and MintedCrowdsale.
        
        Crowdsale(rate, wallet, token)
        RefundableCrowdsale(goal)
        TimedCrowdsale(openingTime, closingTime)
        CappedCrowdsale(cap)
        
        public
    {
        // constructor can stay empty
    }
    
}

contract PupperCoinCrowdSaleDeployer {

    address public token_sale_address;
    address public token_address;
    

    constructor(
        // @TODO: Fill in the constructor parameters!
        string memory name,
        string memory symbol,
        address payable wallet,
        uint goal,
        uint cap,
        uint rate,
        uint openingTime,
        uint closingTime,
        PupperCoin token
        
        // block_timestamp "now" will be passed as opening_time directly in the function call instead of creating a variable
        //closing time is also passed via now + the duration. in this case we made the duration 1 hour for testing purposes
        
    )
        public
    {
        // @TODO: create the PupperCoin and keep its address handy
            // Create the PupperCoin by defining a variable like `PupperCoin token` and setting it to equal new PupperCoin(). 
            // Inside of the parameters of new PupperCoin, pass in the name and symbol variables. 
            // For the initial_supply variable that PupperCoin expects, pass in 0

        PupperCoin token = new PupperCoin(name, symbol, 0);

            // Then, store the address of the token by using token_address = address(token). 
            // This will allow us to easily fetch the token's address for later from the deploying contract.
        
        token_address = address(token);
        
        // @TODO: create the PupperCoinSale and tell it about the token, 
        // set the goal, and set the open and close times to now and now + 24 weeks.

        PupperCoinCrowdSale pupper_sale = new PupperCoinCrowdSale(name, symbol, wallet, goal, cap, rate, now, now + 24 weeks, token);
        token_sale_address = address(pupper_sale);
        
        // make the PupperCoinSale contract a minter, then have the PupperCoinSaleDeployer renounce its minter role
        token.addMinter(token_sale_address);
        token.renounceMinter();
    }
}

