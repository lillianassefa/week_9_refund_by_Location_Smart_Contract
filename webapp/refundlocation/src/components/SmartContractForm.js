import React, { useState } from 'react';

const SmartContractForm = ({ contract }) => {
  const [withdrawAmount, setWithdrawAmount] = useState('');

  const handleWithdrawFunds = async () => {
    try {
      await contract.methods.withdrawFunds(window.ethereum.selectedAddress, withdrawAmount).send({ from: window.ethereum.selectedAddress });
    } catch (error) {
      console.error(error);
    }
  };

  return (
    <div>
      <h2>Withdraw Funds</h2>
      <input
        type="number"
        placeholder="Enter amount to withdraw"
        value={withdrawAmount}
        onChange={(e) => setWithdrawAmount(e.target.value)}
      />
      <button onClick={handleWithdrawFunds}>Withdraw Funds</button>
    </div>
  );
};

export default SmartContractForm;
