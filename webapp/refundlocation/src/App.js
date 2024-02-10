import React, { useState, useEffect } from 'react';
import './App.css';
import SmartContractForm from './components/SmartContractForm';
import DeviceForm from './components/DeviceForm';
import ComplianceStatus from './components/ComplianceStatus';
import Web3 from 'web3';
import RefundGeolocationABI from '/home/lillian/Documents/TenAcademy/week9/week_9_refund_by_Location_Smart_Contract/artifacts/contracts/Geolocation.sol/RefundGeolocation.json'

function App() {
  const [contract, setContract] = useState(false);
  const [devices, setDevices] = useState([]);

  useEffect(() => {
    loadBlockchainData();
  }, []);

  async function loadBlockchainData() {
    if(
      window.etherum
    ) {
      const web3 = new Web3(window.etherum);
      try {
        await window.ethereum.request({ method: 'eth_requestAccounts'});
        const networkId = await web3.eth.net.getId;
        const deployedNetwork = RefundGeolocationABI.networks[networkId];
        const contract = new web3.eth.Contract(RefundGeolocationABI.abi,deployedNetwork && deployedNetwork.address);
        setContract(contract);
  
      }
      catch(e){
        console.error(e);
      }
    }
  }


  const handleDeviceAdded = async (device) => {
    try{
      await contract.methods.addDevice(device.address, device.timeLimit, device.gpsReadingRange).send({
        from: window.ethereum.selectedAddress
      });
    }catch(e){
      console.error(e);
    }
  };

  return (
    <div className="App">
      <h1>Refund by Location Confirmation</h1>
      <SmartContractForm contract={contract} />
      {contract && <DeviceForm onDeviceAdded={handleDeviceAdded} />}
      <ComplianceStatus devices={devices} />
    </div>
  );
}

export default App;
