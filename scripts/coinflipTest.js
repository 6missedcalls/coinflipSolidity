const hre = require("hardhat");

async function main() {
    const coinflipContract = await hre.ethers.getContractFactory("coinflip");
    const coinflip = await coinflipContract.deploy();
    await coinflip.deployed();
    console.log("Coinflip deployed to:", coinflip.address); 

    for (let i = 0; i < 100; i++) {
      // flipCoin
      const flipCoin = await coinflip.flipCoin({value: hre.ethers.utils.parseEther("0.1")});
      await flipCoin.wait();
      // getBalance
      const getBalance = await coinflip.getBalance();
      console.log("Balance:", hre.ethers.utils.formatEther(getBalance));
    }

    // getTotalWins
    const getTotalWins = await coinflip.getTotalWins();
    console.log("Total wins:", hre.ethers.utils.formatEther(getTotalWins));

    // totalLossed
    const totalLossed = await coinflip.getTotalLosses();
    console.log("Total losses:", hre.ethers.utils.formatEther(totalLossed));
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
