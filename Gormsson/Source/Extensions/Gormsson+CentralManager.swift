//
//  Gormsson+CentralManager.swift
//  Gormsson
//
//  Created by Loïc GRIFFIE on 12/04/2019.
//  Copyright © 2019 Loïc GRIFFIE. All rights reserved.
//

import CoreBluetooth

extension Gormsson: CBCentralManagerDelegate {
    /// Invoked when the central manager’s state is updated.
    public func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            state = .isPoweredOn
            if needScan, let block = didDiscoverBlock {
                scan(services, options: options, didDiscover: block)
                needScan = false
                services = nil
                options = nil
            }
        default:
            if state == .isPoweredOn {
                current = nil
                state = .didLostBluetooth
            } else {
                state = .needBluetooth
            }
        }
    }

    /// Invoked when the central manager discovers a peripheral while scanning.
    public func centralManager(_ central: CBCentralManager,
                               didDiscover peripheral: CBPeripheral,
                               advertisementData: [String: Any],
                               rssi RSSI: NSNumber) {
        didDiscoverBlock?(peripheral, GattAdvertisement(with: advertisementData, rssi: RSSI.intValue))
    }

    /// Invoked when an existing connection with a peripheral is torn down.
    public func centralManager(_ central: CBCentralManager,
                               didDisconnectPeripheral peripheral: CBPeripheral,
                               error: Error?) {
        //TODO: Add auto-reconnect
    }

    public func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        current = peripheral
        current?.discoverServices(nil)
    }
}