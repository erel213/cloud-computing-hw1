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

    public async Task<ServiceResponse<CheckoutParkingLotDto>> CheckoutParkingLot(Guid ticketId)
    {
        try
        {
            var ticket = await _ticketRepository.GetTicket(ticketId);

            if (ticket == null)
            {
                return new ServiceResponse<CheckoutParkingLotDto> { Success = false, Message = "Ticket not found" };
            }

            if (ticket.IsCheckout)
            {
                return new ServiceResponse<CheckoutParkingLotDto>
                {
                    Success = false, Message = "Ticket has already been checked out"
                };
            }

            var checkoutDto = new CheckoutParkingLotDto
            {
                LicensePlate = ticket.LicensePlate,
                ParkedTime = DateTime.UtcNow - ticket.EntryTime,
                ParkingLotId = ticket.ParkingLotId,
                Charge = CalculateCharge(DateTime.UtcNow - ticket.EntryTime)
            };
            ticket.Checkout();
            await _ticketRepository.CreateTicket(ticket);
            return new ServiceResponse<CheckoutParkingLotDto>
            {
                Success = true, Data = checkoutDto
            };
        }

        catch (Exception exception)
        {
            return new ServiceResponse<CheckoutParkingLotDto>
            {
                Success = false, Message = exception.Message
            };
        }
    }

    private int CalculateCharge(TimeSpan parkingTime)
    {
        var chargeUnit = (int)Math.Floor(parkingTime.TotalMinutes / 15);

        return chargeUnit * 10;
    }
}