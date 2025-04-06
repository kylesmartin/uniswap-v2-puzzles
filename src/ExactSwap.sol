// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./interfaces/IUniswapV2Pair.sol";
import "./interfaces/IERC20.sol";

contract ExactSwap {
    /**
     *  PERFORM AN SIMPLE SWAP WITHOUT ROUTER EXERCISE
     *
     *  The contract has an initial balance of 1 WETH.
     *  The challenge is to swap an exact amount of WETH for 1337 USDC token using the `swap` function
     *  from USDC/WETH pool.
     *
     */
    function performExactSwap(address pool, address weth, address usdc) public {
        /**
         *     swap(uint256 amount0Out, uint256 amount1Out, address to, bytes calldata data);
         *
         *     amount0Out: the amount of USDC to receive from swap.
         *     amount1Out: the amount of WETH to receive from swap.
         *     to: recipient address to receive the USDC tokens.
         *     data: leave it empty.
         */

        /*
        amount0In = 0
        Solve for amount1In (WETH inputted)

        balance1 = reserve1 + amount1In
        uint amount1In = balance1 > _reserve1 - amount1Out ? balance1 - (_reserve1 - amount1Out)


        */
        (uint256 reserve0, uint256 reserve1,) = IUniswapV2Pair(pool).getReserves();

        uint256 amount0In = 0;
        uint256 amount0Out = 1337e6;
        uint256 balance0 = reserve0 - amount0Out;

        uint256 balance0Adjusted = (balance0 * 1000) - (amount0In * 3);
        uint256 reserveProduct = reserve0 * reserve1 * 1000**2;

        uint256 balance1Adjusted = (reserveProduct / balance0Adjusted);
        /*
        balance1Adjusted = (balance1 * 1000) - (amount1In * 3)
        balance1Adjusted = ((reserve1 + amount1In) * 1000) - (amount1In * 3)
        balance1Adjusted = (reserve1 * 1000 + amount1In * 1000) - (amount1In * 3)
        balance1Adjusted = 1000reserve1 + 1000amount1In - 3amount1In
        balance1Adjusted = 1000reserve1 + 997amount1In

        amount1In = (balance1Adjusted - 1000reserve1) / 997
        */
        uint256 amount1In = ((balance1Adjusted - 1000 * reserve1) / 997) + 1; // add 1 to avoid rounding errors

        IERC20(weth).transfer(pool, amount1In);
        IUniswapV2Pair(pool).swap(amount0Out, 0, address(this), new bytes(0));
    }
}
