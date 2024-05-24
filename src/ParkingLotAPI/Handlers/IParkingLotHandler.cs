using ParkingLotAPI.Dto;

namespace ParkingLotAPI.Handlers;

public interface IParkingLotHandler
{
    public Task<ServiceResponse<CheckinParkingLotDto>> EnterParkingLot(string plate, int parkingLot);

    public ServiceResponse<CheckoutParkingLotDto> CheckoutParkingLot(int ticketId);
}