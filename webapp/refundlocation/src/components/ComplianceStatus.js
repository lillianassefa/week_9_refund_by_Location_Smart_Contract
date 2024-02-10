import React from 'react';

const ComplianceStatus = ({ devices }) => {
  return (
    <div>
      <h2>Compliance Status</h2>
      <table>
        <thead>
          <tr>
            <th>Device Address</th>
            <th>Time Limit</th>
            <th>GPS Reading Range</th>
            <th>Compliance Status</th>
          </tr>
        </thead>
        <tbody>
          {devices.map((device, index) => (
            <tr key={index}>
              <td>{device.deviceAddress}</td>
              <td>{device.timeLimit}</td>
              <td>{device.gpsReadingRange}</td>
              <td>{device.compliance ? 'Compliant' : 'Non-Compliant'}</td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default ComplianceStatus;
