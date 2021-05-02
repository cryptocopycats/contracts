// File contracts/ERC721OnOpenSea.sol


pragma solidity ^0.8.0;


/**
 * @dev helper contract to allow gasless OpenSea listings
 */
contract ERC721OnOpenSea is ERC721Enumerable {
    address public proxyRegistryAddress;

    constructor(
        string memory name,
        string memory symbol,
        address registryProxyAddress_
    ) ERC721(name, symbol) {
        proxyRegistryAddress = registryProxyAddress_;
    }

    function isApprovedForAll(address owner, address operator)
        public
        view
        override
        returns (bool)
    {
        ProxyRegistry proxyRegistry = ProxyRegistry(proxyRegistryAddress);

        if (address(proxyRegistry.proxies(owner)) == operator) {
            return true;
        }

        return super.isApprovedForAll(owner, operator);
    }
}

