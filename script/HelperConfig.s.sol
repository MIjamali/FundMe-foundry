// SPDX-License-Identifier: MIT
// 1. Pragma
pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {MockV3Aggregator} from "../test/mocks/MockV3Aggregator.sol";
import "forge-std/console.sol";
contract HelperConfig is Script {

    NetworkConfig public activeNetworkConfig;

    uint8 public constant DECIMALS = 8;
    int256 public constant INITIAL_PRICE = 2000e8;

    struct NetworkConfig {
        address priceFeed;
    }

    constructor () {
        if (block.chainid == 11155111){
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            console.log (block.chainid);
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns (NetworkConfig memory) {
        NetworkConfig memory sepoliaConfig = NetworkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
    }


    function getOrCreateAnvilEthConfig()public  returns (NetworkConfig memory){
        if (activeNetworkConfig.priceFeed != address(0)){
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS,INITIAL_PRICE);
        vm.stopBroadcast();

        NetworkConfig memory anvilConfig = NetworkConfig({
            priceFeed: address(mockPriceFeed)
        });
        console.logAddress(anvilConfig.priceFeed);
        return anvilConfig;
    }

}







// Deploy mocks when we are on a local anvil chain 
// Keep track of a contract address across different chains
// Sepolia ETH/USD 
// Mainnet ETH/USD