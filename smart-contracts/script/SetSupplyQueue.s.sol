// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.21;

import {Script, console} from "forge-std/Script.sol";
import {MoreVaults} from "../contracts/MoreVaults.sol";
import {IWETH9} from "../contracts/IWETH9.sol";
import {MoreMarkets, MarketParams, Market, MarketParamsLib, Id, MathLib} from "../contracts/MoreMarkets.sol";
import {ERC20MintableMock} from "../contracts/mocks/ERC20MintableMock.sol";

// forge script script/SetSupplyQueue.s.sol:SetSupplyQueue --chain-id 747 --rpc-url https://mainnet.evm.nodes.onflow.org --broadcast -vv --slow
contract SetSupplyQueue is Script {
    using MarketParamsLib for MarketParams;

    MoreVaults moreVault;
    MoreMarkets markets;

    uint256[] public lltvs = [
        800000000000000000,
        945000000000000000,
        965000000000000000
    ];

    uint8 numberOfPremiumBuckets = 5;
    uint256[] public premiumLltvs = [
        1000000000000000000,
        1200000000000000000,
        1400000000000000000,
        1600000000000000000,
        2000000000000000000
    ];
    uint96 public categoryMultipliers = 2 ether;
    uint16[] public categorySteps = [4, 8, 12, 16, 24];

    MarketParams public marketParams;

    Id[] public marketsArray;

    // sentinel
    bytes32 MarketIdUSDfxFLOW =
        bytes32(
            0x0f510c5cca1c8b24bbbccb04833d1243dcb4e6ae07e4f39397dbd9fa6534dece
        );
    bytes32 MarketIdUSDfxANKR =
        bytes32(
            0x19993995e633d686a7a7a4db10d363c2f6dddc744f3ec31e6f8f12d6344bc25d
        );

    // prime
    bytes32 MarketIdwFLOWxBTCf =
        bytes32(
            0xaccc9ce078cc2228bc0a0328b0f207311a9dcdfd96d7e34ac829a38e8af953d1
        );
    bytes32 MarketIdwFLOWxUSDf =
        bytes32(
            0x16893ff750ddec34e292a65a8cb6a014627b3f4ad0b2b82c6da4cc28d1e0576d
        );

    // horizon
    bytes32 MarketIdwUSDCfxBTCf =
        bytes32(
            0x6bed9b33d3ee7142f53ba4cf930d61e4aff25a4677150cfe354e9b75a2ee2547
        );
    bytes32 MarketIdwUSDCfxETHf =
        bytes32(
            0x0f0de7ddadc86a7be1a3d3e1a9d2e8090a791299bcf0985626ae4ebd65add87e
        );
    bytes32 MarketIdwUSDCfxUSDf =
        bytes32(
            0xbb1c25a3dd81910d745b07e0926dc1cc7be6f09c2c5cc025c0d581e44c21c67f
        );

    // apex

    // nimbus
    bytes32 MarketIdBTCfxUSDCf =
        bytes32(
            0x75a964099ef99a0c7dc893c659a4dec8f6beeb3d7c9705e28df7d793694b6164
        );

    // mainnet Flow All Day
    bytes32 MarketIdwFLOWxankrFLOW =
        bytes32(
            0x2ae0c40dc06f58ff0243b44116cd48cc4bdab19e2474792fbf1f413600ceab3a
        );

    bytes32 MarketIdankrFlowxFLOW =
        bytes32(
            0x3dca1854528f8a9bff744889198eb07ceacdfe25937450965e62103cefc69aa5
        );

    function setUp() public {}

    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        moreVault = MoreVaults(vm.envAddress("SUPER_FLOW"));
        markets = MoreMarkets(vm.envAddress("MARKETS"));
        address owner = vm.envAddress("OWNER");

        vm.startBroadcast(deployerPrivateKey);
        marketsArray.push(Id.wrap(MarketIdankrFlowxFLOW));
        // marketsArray.push(Id.wrap(MarketIdwFLOWxUSDf));
        // marketsArray.push(Id.wrap(MarketIdwUSDCfxUSDf));

        marketParams = getMarketParams(Id.wrap(MarketIdankrFlowxFLOW));

        // moreVault.submitCap(marketParams, 33557047 * 1e18);
        // moreVault.acceptCap(marketParams);

        // marketParams = getMarketParams(Id.wrap(MarketIdwFLOWxBTCf));

        // moreVault.submitCap(marketParams, 90000 * 1e18);
        // moreVault.acceptCap(marketParams);

        // marketParams = getMarketParams(Id.wrap(MarketIdwUSDCfxUSDf));

        // moreVault.submitCap(marketParams, 60000 * 1e6);
        // moreVault.acceptCap(marketParams);

        moreVault.submitCap(marketParams, 37558686 * 1e18);
        moreVault.acceptCap(marketParams);
        moreVault.setSupplyQueue(marketsArray);
        moreVault.setFeeRecipient(
            address(0x3Ba5aAB8d8CD479ffb4a2f03609e9122552dD150)
        );
        // IWETH9(address(0xd3bF53DAC106A0290B0483EcBC89d40FcC961f3e)).deposit{
        //     value: 190 * 1e18
        // }();
        // ERC20MintableMock(address(0xd3bF53DAC106A0290B0483EcBC89d40FcC961f3e))
        //     .approve(
        //         address(0x8434D9E41C822F4e10AACcc1D777AAcDf9D4BA60),
        //         190 * 1e18
        //     );
        // moreVault.deposit(190 * 1e18, owner);
        moreVault.setFee(0.10e18);
        moreVault.setCurator(
            address(0xB37a5BA4060D6bFD00a3bFCb235Bb596F13932Bd)
        );

        vm.stopBroadcast();
    }

    function getMarketParams(
        Id marketId
    ) internal view returns (MarketParams memory _marketParams) {
        (
            bool isPremium,
            address loanToken,
            address collateralToken,
            address marketOracle,
            address marketIrm,
            uint256 lltv,
            address creditAttestationService,
            uint96 irxMaxLltv,
            uint256[] memory categoryLltv
        ) = markets.idToMarketParams(marketId);
        _marketParams.isPremiumMarket = isPremium;
        _marketParams.loanToken = loanToken;
        _marketParams.collateralToken = collateralToken;
        _marketParams.oracle = marketOracle;
        _marketParams.irm = marketIrm;
        _marketParams.lltv = lltv;
        _marketParams.creditAttestationService = creditAttestationService;
        _marketParams.irxMaxLltv = irxMaxLltv;
        _marketParams.categoryLltv = categoryLltv;
    }
}
