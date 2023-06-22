import { ethers } from "hardhat";
import { CryptoMappDao } from "../typechain-types/CryptoMappDao";
import { expect } from "chai";

describe("CryptoMappDao", () => {
  let cryptoMappDao: CryptoMappDao;

  beforeEach(async () => {
    const CryptoMappDao = await ethers.getContractFactory("CryptoMappDao");
    cryptoMappDao = await CryptoMappDao.deploy();
  });

  it("should allow setting transaction fee", async () => {
    await cryptoMappDao.setTransactionFee(1000);
    expect(await cryptoMappDao.transactionFee()).to.equal(1000);
  });

  it("should allow setting registration fee", async () => {
    await cryptoMappDao.setRegistrationFee(1000);
    expect(await cryptoMappDao.registrationFee()).to.equal(1000);
  });

  it("should allow members to create proposals", async () => {
    await cryptoMappDao.createProposal("Change registration fee", 10);
    const proposal = await cryptoMappDao.proposals(0);
    expect(proposal.description).to.equal("Change registration fee");
    expect(proposal.endBlock).to.equal(10);
  });
});
