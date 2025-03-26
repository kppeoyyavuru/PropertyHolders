// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RealEstate {
    struct Property {
        uint256 id;
        address payable owner;
        string name;
        string location;
        uint256 price;
        bool isForSale;
        bool isForRent;
        uint256 rentPricePerDay;
        bool isRented;
    }

    uint256 public nextPropertyId;
    mapping(uint256 => Property) public properties;

    event PropertyListed(uint256 id, string name, uint256 price, bool isForSale, bool isForRent);
    event PropertySold(uint256 id, address buyer, uint256 price);
    event PropertyRented(uint256 id, address renter, uint256 daysRented);

    // List a new property
    function listProperty(
        string memory _name,
        string memory _location,
        uint256 _price,
        bool _isForSale,
        bool _isForRent,
        uint256 _rentPricePerDay
    ) external {
        properties[nextPropertyId] = Property(
            nextPropertyId,
            payable(msg.sender),
            _name,
            _location,
            _price,
            _isForSale,
            _isForRent,
            _rentPricePerDay,
            false
        );

        emit PropertyListed(nextPropertyId, _name, _price, _isForSale, _isForRent);
        nextPropertyId++;
    }

    // Buy a property
    function buyProperty(uint256 _id) external payable {
        Property storage property = properties[_id];

        require(property.isForSale, "Property not for sale");
        require(msg.value == property.price, "Incorrect price");

        property.owner.transfer(msg.value);
        property.owner = payable(msg.sender);
        property.isForSale = false;

        emit PropertySold(_id, msg.sender, msg.value);
    }

    // Rent a property
    function rentProperty(uint256 _id, uint256 _days) external payable {
        Property storage property = properties[_id];

        require(property.isForRent, "Property not available for rent");
        require(!property.isRented, "Already rented");
        
        uint256 totalRent = property.rentPricePerDay * _days;
        require(msg.value >= totalRent, "Insufficient funds");

        property.isRented = true;
        property.owner.transfer(msg.value);

        emit PropertyRented(_id, msg.sender, _days);
    }
}
