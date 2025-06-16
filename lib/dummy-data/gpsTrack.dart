import '../models/local/gpsTrackModel.dart';

List<GpsTrackModel> GpsTracData = [
  GpsTrackModel(
    id: " 1",
    longitude: 12.345,
    latitude: 45.678,
    device: 'Device 1',
    shippingId: 'ABC123',
    inObservation: true,
  ),
  GpsTrackModel(
    id: "2",
    longitude: 23.456,
    latitude: 56.789,
    device: 'Device 2',
    shippingId: 'DEF456',
    inObservation: false,
  ),
  GpsTrackModel(
    id: "3",
    longitude: 34.567,
    latitude: 67.890,
    device: 'Device 3',
    shippingId: 'GHI789',
    inObservation: true,
  ),
  GpsTrackModel(
    id: "4",
    longitude: 45.678,
    latitude: 78.901,
    device: 'Device 4',
    shippingId: 'JKL012',
    inObservation: false,
  ),
  GpsTrackModel(
    id: "5",
    longitude: 56.789,
    latitude: 89.012,
    device: 'Device 5',
    shippingId: 'MNO345',
    inObservation: true,
  ),
];
