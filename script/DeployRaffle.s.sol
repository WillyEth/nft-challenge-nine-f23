// SPDX-License-Identifier: UNLICENSED

//forge test -m "testMinimumDollarIsFive"

pragma solidity ^0.8.19;

import {Script} from "forge-std/Script.sol";
import {Minter} from "../src/LessonNine.sol";

contract DeployFundMe is Script {
    function run() external returns (Minter) {
        //Before startBroadCast -> Not a Real TX

        vm.startBroadcast();
        Minter minter = new Minter();
        vm.stopBroadcast();
        return minter;
    }
}
