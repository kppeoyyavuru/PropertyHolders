const hre = require("hardhat");

async function main() {
    const RealEstate = await hre.ethers.getContractFactory("RealEstate");

    // Deploy the contract
    const contract = await RealEstate.deploy();

    // Ensure deployment completion before accessing the address
    await contract.waitForDeployment();

    console.log(`Contract deployed to: ${contract.target}`); //Contract deployed to: 0xdf249af9e8961812C6C4b6772f27c382a6eeCdB9
}

main().catch((error) => {
    console.error(error);
    process.exitCode = 1;
});
