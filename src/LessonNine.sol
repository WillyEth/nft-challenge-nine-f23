// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC721/IERC721Receiver.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

interface ILessonNine {
    function solveChallenge(uint256, string calldata) external;

    function specialImage() external view returns (string memory);
}

contract Minter is IERC721Receiver {
    address public constant lessonAddress = 0x33e1fD270599188BB1489a169dF1f0be08b83509;
    ILessonNine constant lesson = ILessonNine(0x33e1fD270599188BB1489a169dF1f0be08b83509);

    // Mapping to store received tokens
    mapping(uint256 => address) public tokenOwner;

    event resultMint(address indexed _from, uint256 _lessonAnswer, string _twitterHandle);

    function getPrevrandao() public view returns (uint256) {
        return block.prevrandao;
    }

    function getTimeStamp() public view returns (uint256) {
        return block.timestamp;
    }

    function getSpecialImage() public view returns (string memory) {
        return lesson.specialImage();
    }

    function getPublicAnswer() public view returns (uint256) {
        uint256 publicAnswer =
            uint256(keccak256(abi.encodePacked(msg.sender, block.prevrandao, block.timestamp))) % 100000;

        return publicAnswer;
    }

    function mint() public {
        uint256 lessonAnswer =
            uint256(keccak256(abi.encodePacked(address(this), block.prevrandao, block.timestamp))) % 100000;

        string memory twitterHandle = "@btwit71";
        (bool success,) =
            lessonAddress.call(abi.encodeWithSignature("solveChallenge(uint256,string)", lessonAnswer, twitterHandle));
        if (!success) revert();

        emit resultMint(msg.sender, lessonAnswer, twitterHandle);
    }

    function onERC721Received(address, address from, uint256 tokenId, bytes memory) public override returns (bytes4) {
        tokenOwner[tokenId] = from;
        return this.onERC721Received.selector;
    }

    // Function to withdraw a specific token
    function withdrawToken(address foo1, address foo2, uint256 tokenId) public {
        // Transfer the token to the msg.sender
        IERC721(foo1).safeTransferFrom(address(this), foo2, tokenId);
    }
}
