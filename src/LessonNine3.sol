// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface ILessonNine {
    function solveChallenge(uint256, string calldata) external;
    function specialImage() external view returns (string memory);
}

contract Minter {
    address public constant lessonAddress = 0x33e1fD270599188BB1489a169dF1f0be08b83509;
    ILessonNine constant lesson = ILessonNine(0x33e1fD270599188BB1489a169dF1f0be08b83509);

    event resultMint(address indexed _from, uint256 _lessonAnswer, string _twitterHandle, bool _success, bytes _result);

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
        (bool success, bytes memory result) =
            lessonAddress.call(abi.encodeWithSignature("solveChallenge(uint256,string)", lessonAnswer, twitterHandle));

        emit resultMint(msg.sender, lessonAnswer, twitterHandle, success, result);
    }
}
