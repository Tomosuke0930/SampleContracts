// SPDX-License-Identifier: MIT

pragma solidity ^0.7.0;

interface IAsset {
        // solhint-disable-previous-line no-empty-blocks
 }

/**
 * @dev Interface of the ERC20 standard as defined in the EIP.
 */
interface IERC20 {
    /**
     * @dev Returns the amount of tokens in existence.
     */
    function totalSupply() external view returns (uint256);

    /**
     * @dev Returns the amount of tokens owned by `account`.
     */
    function balanceOf(address account) external view returns (uint256);

    /**
     * @dev Moves `amount` tokens from the caller's account to `recipient`.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transfer(address recipient, uint256 amount) external returns (bool);

    /**
     * @dev Returns the remaining number of tokens that `spender` will be
     * allowed to spend on behalf of `owner` through {transferFrom}. This is
     * zero by default.
     *
     * This value changes when {approve} or {transferFrom} are called.
     */
    function allowance(address owner, address spender) external view returns (uint256);

    /**
     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * IMPORTANT: Beware that changing an allowance with this method brings the risk
     * that someone may use both the old and the new allowance by unfortunate
     * transaction ordering. One possible solution to mitigate this race
     * condition is to first reduce the spender's allowance to 0 and set the
     * desired value afterwards:
     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
     *
     * Emits an {Approval} event.
     */
    function approve(address spender, uint256 amount) external returns (bool);

    /**
     * @dev Moves `amount` tokens from `sender` to `recipient` using the
     * allowance mechanism. `amount` is then deducted from the caller's
     * allowance.
     *
     * Returns a boolean value indicating whether the operation succeeded.
     *
     * Emits a {Transfer} event.
     */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);

    /**
     * @dev Emitted when `value` tokens are moved from one account (`from`) to
     * another (`to`).
     *
     * Note that `value` may be zero.
     */
    event Transfer(address indexed from, address indexed to, uint256 value);

    /**
     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
     * a call to {approve}. `value` is the new allowance.
     */
    event Approval(address indexed owner, address indexed spender, uint256 value);
}


// solhint-disable

function _asIAsset(IERC20[] memory tokens) pure returns (IAsset[] memory assets) {
    // solhint-disable-next-line no-inline-assembly
    assembly {
        assets := tokens
    }
}

function _sortTokens(
    IERC20 tokenA,
    IERC20 tokenB,
    IERC20 tokenC
) pure returns (IERC20[] memory tokens) {
    (uint256 indexTokenA, uint256 indexTokenB, uint256 indexTokenC) = _getSortedTokenIndexes(tokenA, tokenB, tokenC);
    tokens = new IERC20[](3);
    tokens[indexTokenA] = tokenA;
    tokens[indexTokenB] = tokenB;
    tokens[indexTokenC] = tokenC;
}

function _insertSorted(IERC20[] memory tokens, IERC20 token) pure returns (IERC20[] memory sorted) {
    sorted = new IERC20[](tokens.length + 1);

    if (tokens.length == 0) {
        sorted[0] = token;
        return sorted;
    }

    uint256 i;
    for (i = tokens.length; i > 0 && tokens[i - 1] > token; i--) sorted[i] = tokens[i - 1];
    for (uint256 j = 0; j < i; j++) sorted[j] = tokens[j];
    sorted[i] = token;
}

function _getSortedTokenIndexes(
    IERC20 tokenA,
    IERC20 tokenB,
    IERC20 tokenC
)
    pure
    returns (
        uint256 indexTokenA,
        uint256 indexTokenB,
        uint256 indexTokenC
    )
{
    if (tokenA < tokenB) {
        if (tokenB < tokenC) {
            // (tokenA, tokenB, tokenC)
            return (0, 1, 2);
        } else if (tokenA < tokenC) {
            // (tokenA, tokenC, tokenB)
            return (0, 2, 1);
        } else {
            // (tokenC, tokenA, tokenB)
            return (1, 2, 0);
        }
    } else {
        // tokenB < tokenA
        if (tokenC < tokenB) {
            // (tokenC, tokenB, tokenA)
            return (2, 1, 0);
        } else if (tokenC < tokenA) {
            // (tokenB, tokenC, tokenA)
            return (2, 0, 1);
        } else {
            // (tokenB, tokenA, tokenC)
            return (1, 0, 2);
        }
    }
}