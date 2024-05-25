using Microsoft.AspNetCore.Mvc;
using ParkingLotAPI.Dto;
using ParkingLotAPI.Handlers;

namespace ParkingLotAPI.Controllers;

[ApiController]
[Route("")]
public class ParkingTicketController : ControllerBase
{
    private readonly IParkingLotHandler _parkingLotHandler;

    public ParkingTicketController(IParkingLotHandler parkingLotHandler)
    {
        _parkingLotHandler = parkingLotHandler;
    }

    [HttpPost("entry")]
    public async Task<ActionResult<ServiceResponse<CheckinParkingLotDto>>> EnterParking(string plate, int parkingLot)
    {
        try
        {   
            var response = await _parkingLotHandler.EnterParkingLot(plate, parkingLot);
            return  StatusCode(200, response);
        }

        catch (Exception exception)
        {
            var exceptionResponse = new ServiceResponse<CheckinParkingLotDto>()
            {
                Success = false,
                Message = $"Failed to enter to parking lot {exception.Message}"
            };

            return StatusCode(400, exceptionResponse);
        }
    }

    [HttpPost("exit")]
    public async Task<ActionResult<ServiceResponse<CheckoutParkingLotDto>>> CheckoutParking(Guid ticketId)
    {
        try
        {
            var response = await _parkingLotHandler.CheckoutParkingLot(ticketId);
            return StatusCode(200, response);
        }

        catch (Exception exception)
        {
            var exceptionResponse = new ServiceResponse<CheckoutParkingLotDto>()
            {
                Success = false,
                Message = $"Failed to checkout from parking lot {exception.Message}"
            };

            return StatusCode(400, exceptionResponse);
        }
    }
}