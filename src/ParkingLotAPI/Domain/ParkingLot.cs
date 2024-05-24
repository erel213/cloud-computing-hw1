namespace ParkingLotAPI.Domain;

public class ParkingLot
{
    public int ParkingLotId { get; private set; }

    public ParkingLot(int parkingLotId)
    {
        ParkingLotId = parkingLotId;
    }
}