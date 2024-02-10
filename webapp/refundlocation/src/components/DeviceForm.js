import React, { useState } from 'react';

const DeviceForm = ({ onDeviceAdded }) => {
  const [deviceAddress, setDeviceAddress] = useState('');
  const [timeLimit, setTimeLimit] = useState('');
  const [gpsReadingRange, setGpsReadingRange] = useState('');

  const handleAddDevice = () => {
    onDeviceAdded({ deviceAddress, timeLimit, gpsReadingRange });
    setDeviceAddress('');
    setTimeLimit('');
    setGpsReadingRange('');
  };

  return (
    <div>
      <h2>Add Device</h2>
      <input
        type="text"
        placeholder="Enter device address"
        value={deviceAddress}
        onChange={(e) => setDeviceAddress(e.target.value)}
      />
      <input
        type="number"
        placeholder="Enter time limit (in seconds)"
        value={timeLimit}
        onChange={(e) => setTimeLimit(e.target.value)}
      />
      <input
        type="number"
        placeholder="Enter GPS reading range (in meters)"
        value={gpsReadingRange}
        onChange={(e) => setGpsReadingRange(e.target.value)}
      />
      <button onClick={handleAddDevice}>Add Device</button>
    </div>
  );
};

export default DeviceForm;
