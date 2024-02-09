import { ethers } from "hardhat";
import { expect } from "chai";
import { Contract } from "ethers";

describe("RefundGeolocation Contract", function () {
  let RefundGeolocation: Contract;
  let owner: any;
  let device: any;
  let otherAccount: any;
  const latitude = 100;
  const longitude = 100;
  const range = 10;

  beforeEach(async function () {
    [owner, device, otherAccount] = await ethers.getSigners();

    const RefundGeolocationFactory = await ethers.getContractFactory("RefundGeolocation");
    RefundGeolocation = (await RefundGeolocationFactory.deploy(latitude, longitude, range)) as unknown as Contract;
    await RefundGeolocation.deployed();
    await RefundGeolocation.connect(owner); 
  });

  it("Should set the right owner", async function () {
    expect(await RefundGeolocation.company()).to.equal(owner.address);
  });

  it("Should allow the device to send coordinates", async function () {
    await expect(RefundGeolocation.connect(device)).to.emit(RefundGeolocation, "ComplianceChecked")
      .withArgs(device.address, true);
  });

  it("Should not allow other accounts to send coordinates", async function () {
    await expect(RefundGeolocation.connect(otherAccount))
      .to.be.revertedWith("Only Device can call this function");
  });

  it("Should correctly identify when the device is within range", async function () {
    const withinRange = await RefundGeolocation.isWithinRange(105, 105);
    expect(withinRange).to.be.true;
  });

  it("Should correctly identify when the device is out of range", async function () {
    const outOfRange = await RefundGeolocation.isWithinRange(200, 200);
    expect(outOfRange).to.be.false;
  });
});
