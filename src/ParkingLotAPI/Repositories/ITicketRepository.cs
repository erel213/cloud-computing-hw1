using ParkingLotAPI.Domain;

namespace ParkingLotAPI.Repositories;

public interface ITicketRepository
{
    public Task CreateTicket(Ticket ticket);
    public Task<Ticket?> GetTicket(Ticket ticket);
}