// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract AddLiquid {
    /**
     *  ADD LIQUIDITY WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1000 USDC and 1 WETH.
     *  Mint a position (deposit liquidity) in the pool USDC/WETH to msg.sender.
     *  The challenge is to provide the same ratio as the pool then call the mint function in the pool contract.
     *
     */
    function addLiquidity(address usdc, address weth, address pool, uint256 usdcReserve, uint256 wethReserve) public {
        IUniswapV2Pair pair = IUniswapV2Pair(pool);

        // your code start here

        // see available functions here: https://github.com/Uniswap/v2-core/blob/master/contracts/interfaces/IUniswapV2Pair.sol

        // pair.getReserves();
        // pair.mint(...);

        // token0 = USDC
        // token1 = WETH

        uint256 totalSupply = pair.totalSupply();

        // Invariant to keep ratio:
        //  - amount0.mul(_totalSupply) / _reserve0 = amount1.mul(_totalSupply) / _reserve1
        //  - therefore: amount1 = (amount0.mul(_totalSupply) / reserve0).mul(reserve1) / _totalSupply
        // Use 1000 USDC for amount0
        uint256 usdcAmount = 1000e6;
        uint256 wethAmount = (usdcAmount * totalSupply / usdcReserve) * wethReserve / totalSupply;

        IERC20(usdc).transfer(address(pair), usdcAmount);
        IERC20(weth).transfer(address(pair), wethAmount);

        pair.mint(msg.sender);
    }
}
