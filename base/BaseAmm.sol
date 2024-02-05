// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SimpleAMM {
    uint256 public constant k = 10 ** 6; // Постоянная для упрощения, в реальных AMM k вычисляется исходя из балансов
    uint256 public reserveTokenA;
    uint256 public reserveTokenB;

    // Инициализация резервов токенов для простоты.
    constructor(uint256 _reserveTokenA, uint256 _reserveTokenB) {
        require(
            _reserveTokenA * _reserveTokenB >= k,
            "Invalid initial reserves"
        );
        reserveTokenA = _reserveTokenA;
        reserveTokenB = _reserveTokenB;
    }

    // Функция для расчета спотовой цены токена A относительно токена B
    function getSpotPriceTokenA() public view returns (uint256) {
        return reserveTokenB / reserveTokenA;
    }

    // Функция для расчета спотовой цены токена B относительно токена A
    function getSpotPriceTokenB() public view returns (uint256) {
        return reserveTokenA / reserveTokenB;
    }

    // Простая функция обмена токенов (без учета комиссий и проверок для упрощения)
    function swapTokenAForTokenB(uint256 amountTokenA) public {
        uint256 amountTokenB = (amountTokenA * reserveTokenB) /
            (reserveTokenA + amountTokenA);
        // В реальном контракте здесь будет логика для обновления балансов и проверки условий
        reserveTokenA += amountTokenA;
        reserveTokenB -= amountTokenB;
    }

    // Аналогичная функция для обмена токена B на токен A
    function swapTokenBForTokenA(uint256 amountTokenB) public {
        uint256 amountTokenA = (amountTokenB * reserveTokenA) /
            (reserveTokenB + amountTokenB);
        // Обновление балансов после обмена
        reserveTokenB += amountTokenB;
        reserveTokenA -= amountTokenA;
    }
}
