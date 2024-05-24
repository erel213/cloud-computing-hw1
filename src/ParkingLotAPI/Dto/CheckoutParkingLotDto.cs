namespace ParkingLotAPI.Dto;

public class CheckoutParkingLotDto
{
    public string LicensePlate { get; set; } = string.Empty;
    public TimeSpan ParkedTime { get; set; }
    public int ParkingLotId { get; set; }
    public decimal Charge { get; set; }
}