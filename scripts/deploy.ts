import { ethers } from "hardhat";

async function main() {
  const latitude = 40;
  const longitude = 40;
  const range = 100;

  const Geolocation = await ethers.getContractFactory("RefundGeolocation");
  const geolocation = await Geolocation.deploy(latitude, longitude, range);
  // await geolocation.waitForDeployment();
 const address = await geolocation.getAddress();
//  address = " 0x9fE46736679d2D9a65F0992F2272dE9f3c7fa6e0"
  console.log("Geolocation contract deploed to:", address);
}
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
