import React, { useState } from 'react';
import './App.css';
import SmartContractForm from './components/SmartContractForm';
import DeviceForm from './components/DeviceForm';
import ComplianceStatus from './components/ComplianceStatus';
// import Web3 from 'web3';

function App() {
  const [contractDeployed, setContractDeployed] = useState(false);
  const [devices, setDevices] = useState([]);

  const handleContractDeployed = () => {
    setContractDeployed(true);
  };

  const handleDeviceAdded = (device) => {
    setDevices([...devices, device]);
  };

  return (
    <div className="App">
      <h1>Refund by Location Confirmation</h1>
      <SmartContractForm onContractDeployed={handleContractDeployed} />
       <DeviceForm onDeviceAdded={handleDeviceAdded} />
      <ComplianceStatus devices={devices} />
    </div>
  );
}

export default App;
