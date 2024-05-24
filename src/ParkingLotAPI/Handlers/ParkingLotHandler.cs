using ParkingLotAPI.Domain;
using ParkingLotAPI.Dto;
using ParkingLotAPI.Repositories;

namespace ParkingLotAPI.Handlers;

public class ParkingLotHandler : IParkingLotHandler
{
    private readonly ITicketRepository _ticketRepository;

    public ParkingLotHandler(ITicketRepository ticketRepository)
    {
        _ticketRepository = ticketRepository;
    }

    public async Task<ServiceResponse<CheckinParkingLotDto>> EnterParkingLot(string plate, int parkingLot)
    {
        try
        {
            var ticket = new Ticket(
                entryTime: DateTime.UtcNow,
                licensePlate: plate,
                parkingLotId: parkingLot);

            await _ticketRepository.CreateTicket(ticket);
            
            return new ServiceResponse<CheckinParkingLotDto>
            {
                Success = true, Data = new CheckinParkingLotDto { TicketId = ticket.TicketId }
            };
        }

        catch (Exception exception)
        {
            return new ServiceResponse<CheckinParkingLotDto>
            {
                Success = false, Message = exception.Message
            };
        }
    }

    public ServiceResponse<CheckoutParkingLotDto> CheckoutParkingLot(int ticketId)
    {
        throw new NotImplementedException();
    }
}