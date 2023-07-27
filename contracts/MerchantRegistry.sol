// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

interface IERC20Decimals is IERC20 {
    function decimals() external view returns (uint8);
}

contract MerchantRegistry is Ownable {
    using Counters for Counters.Counter;
    Counters.Counter private _merchantIds;
    Counters.Counter private _categoryIds;

    uint256 public registrationFee;

    struct Merchant {
        uint256 id;
        string name;
        string physicalAddress;
        string ipfsLogo;
        uint256 latitude;
        uint256 longitude;
        uint256 categoryId;
    }

    // Mapping from merchant ID to Merchant struct
    mapping(uint256 => Merchant) private _merchants;

    // Mapping from owner address to merchant ID
    mapping(address => uint256) private _merchantOwners;

    // Mapping from category ID to category name
    mapping(uint256 => string) private _categories;

    constructor(
        address daiAddress,
        address usdcAddress,
        address usdtAddress,
        uint256 _registrationFee
    ) {
        registrationFee = _registrationFee;

        // Instantiate tokens
        IERC20Decimals dai = IERC20Decimals(daiAddress);
        IERC20Decimals usdc = IERC20Decimals(usdcAddress);
        IERC20Decimals usdt = IERC20Decimals(usdtAddress);
    }

    function addCategory(string memory categoryName) public onlyOwner {
        _categoryIds.increment();
        uint256 newCategoryId = _categoryIds.current();
        _categories[newCategoryId] = categoryName;
    }

    function registerMerchant(
        string memory _name,
        string memory _physicalAddress,
        string memory _ipfsLogo,
        uint256 _latitude,
        uint256 _longitude,
        uint256 _categoryId,
        address _paymentToken
    ) public payable returns (uint256) {
        IERC20Decimals paymentToken = IERC20Decimals(_paymentToken);
        uint256 decimals = paymentToken.decimals();
        uint256 registrationFeeInWei = registrationFee * (10 ** decimals);
        require(
            paymentToken.transferFrom(
                msg.sender,
                address(this),
                registrationFeeInWei
            ),
            "Transfer failed"
        );

        _merchantIds.increment();
        uint256 newMerchantId = _merchantIds.current();
        Merchant memory newMerchant = Merchant(
            newMerchantId,
            _name,
            _physicalAddress,
            _ipfsLogo,
            _latitude,
            _longitude,
            _categoryId
        );
        _merchants[newMerchantId] = newMerchant;
        _merchantOwners[msg.sender] = newMerchantId;

        return newMerchantId;
    }

    function withdrawFunds(
        address tokenAddress,
        uint256 amount
    ) public onlyOwner {
        IERC20Decimals token = IERC20Decimals(tokenAddress);
        uint256 decimals = token.decimals();
        uint256 amountInWei = amount * (10 ** decimals);
        require(
            token.balanceOf(address(this)) >= amountInWei,
            "Not enough funds"
        );
        token.transfer(msg.sender, amountInWei);
    }
}
