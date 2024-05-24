namespace ParkingLotAPI.Domain;

public class Ticket
{
    public Guid TicketId { get; private set; }

    public string LicensePlate { get; private set; }
    
    public DateTime EntryTime { get; private set; }
    
    public int ParkingLotId { get; private set; }

    public bool IsCheckout { get; private set; }

    public Ticket(string licensePlate, DateTime entryTime, int parkingLotId, Guid? ticketId = null, bool isCheckout=false)
    {
        TicketId = ticketId ?? Guid.NewGuid();
        LicensePlate = licensePlate;
        EntryTime = entryTime;
        ParkingLotId = parkingLotId;
        IsCheckout = isCheckout;
    }

    public Ticket Checkout()
    {
        IsCheckout = true;
        return this;
    }
}