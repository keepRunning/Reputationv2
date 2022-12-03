import { ethers } from "hardhat";

async function main() {
  // const currentTimestampInSeconds = Math.round(Date.now() / 1000);
  // const ONE_YEAR_IN_SECS = 365 * 24 * 60 * 60;
  // const unlockTime = currentTimestampInSeconds + ONE_YEAR_IN_SECS;

  // const lockedAmount = ethers.utils.parseEther("1");

  // const Lock = await ethers.getContractFactory("Lock");
  // const lock = await Lock.deploy(unlockTime, { value: lockedAmount });

  // await lock.deployed();

  // console.log(`Lock with 1 ETH and unlock timestamp ${unlockTime} deployed to ${lock.address}`);

  const signers = await ethers.getSigners();
  const deployer = signers[0].address;

  const RepToken = await ethers.getContractFactory("RepToken");
  const repToken = await RepToken.deploy();

  const OrderRecords = await ethers.getContractFactory("OrderRecords");
  const orderRecords = await OrderRecords.deploy();
  
  const ReviewRecords = await ethers.getContractFactory("ReviewRecords");
  const reviewRecords = await ReviewRecords.deploy();

  const FinalRatings = await ethers.getContractFactory("FinalRatings");
  const finalRatings = await FinalRatings.deploy();

  const RatingsCalculator = await ethers.getContractFactory("RatingsCalculator");
  const ratingsCalculator = await RatingsCalculator.deploy();

  const ReconciliationCalculator = await ethers.getContractFactory("ReconciliationCalculator");
  const reconciliationCalculator = await ReconciliationCalculator.deploy();


  const TimelockController = await ethers.getContractFactory("TimelockController");
  const timelockController = await TimelockController.deploy(1000, [deployer], [deployer], deployer); // temp

  const ReputationGoverner = await ethers.getContractFactory("ReputationGoverner");
  const reputationGoverner = await ReputationGoverner.deploy(repToken.address,timelockController.address);

}


// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
