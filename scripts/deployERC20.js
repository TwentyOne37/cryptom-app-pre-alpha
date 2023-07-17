const hre = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();
  console.log("Deploying contracts with the account:", deployer.address);

  // Deploy DAI contract
  const DAI = await hre.ethers.getContractFactory("DAI");
  const dai = await DAI.deploy(ethers.parseUnits("1000", "ether"));
  await dai.waitForDeployment();
  console.log("DAI deployed to:", await dai.getAddress());

  // Deploy USDC contract
  const USDC = await hre.ethers.getContractFactory("USDC");
  const usdc = await USDC.deploy(ethers.parseUnits("1000", "mwei"));
  await usdc.waitForDeployment();
  console.log("USDC deployed to:", await usdc.getAddress());

  // Deploy USDT contract
  const USDT = await hre.ethers.getContractFactory("USDT");
  const usdt = await USDT.deploy(ethers.parseUnits("1000", "mwei"));
  await usdt.waitForDeployment();
  console.log("USDT deployed to:", await usdt.getAddress());

  // DAI
  const daiTransferTx = await dai.transfer(
    deployer.address,
    ethers.parseUnits("1000", "ether")
  );
  await daiTransferTx.wait();
  console.log("DAI tokens have been sent to:", deployer.address);

  // USDC
  const usdcTransferTx = await usdc.transfer(
    deployer.address,
    ethers.parseUnits("1000", "mwei")
  );
  await usdcTransferTx.wait();
  console.log("USDC tokens have been sent to:", deployer.address);

  // USDT
  const usdtTransferTx = await usdt.transfer(
    deployer.address,
    ethers.parseUnits("1000", "mwei")
  );
  await usdtTransferTx.wait();
  console.log("USDT tokens have been sent to:", deployer.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
