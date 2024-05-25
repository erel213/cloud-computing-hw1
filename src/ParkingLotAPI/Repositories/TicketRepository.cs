using Amazon.DynamoDBv2;
using Amazon.DynamoDBv2.Model;
using ParkingLotAPI.Domain;

namespace ParkingLotAPI.Repositories;

public class TicketRepository : ITicketRepository
{
    private readonly IAmazonDynamoDB _dynamoDb;

    public TicketRepository(IAmazonDynamoDB dynamoDb)
    {
        _dynamoDb = dynamoDb;
    }

    public async Task CreateTicket(Ticket ticket)
    {
        try
        {
            var putRequest = new PutItemRequest
            {
                TableName = Constants.Constants.DynamoDbConstants.DynamodbTableName,
                Item = new Dictionary<string, AttributeValue>
                {
                    { "TicketId", new AttributeValue { S = ticket.TicketId.ToString() } },
                    { "LicensePlate", new AttributeValue { S = ticket.LicensePlate } },
                    { "EntryTime", new AttributeValue { S = ticket.EntryTime.ToString("yyyy-MM-ddTHH:mm:ss.fffZ") } },
                    { "ParkingLotId", new AttributeValue { N = ticket.ParkingLotId.ToString() } },
                    { "IsCheckout", new AttributeValue {BOOL = false}}
                }
            };

            var response = await _dynamoDb.PutItemAsync(putRequest);
        }

        catch (Exception exception)
        {
            throw new Exception("Failed to create ticket in DynamoDB", exception);
        }
    }

    public async Task<Ticket?> GetTicket(Guid ticketId)
    {
        try
        {
            var getRequest = new GetItemRequest
            {
                TableName = Constants.Constants.DynamoDbConstants.DynamodbTableName,
                Key = new Dictionary<string, AttributeValue>
                {
                    { "TicketId", new AttributeValue { S = ticketId.ToString() } }
                }
            };

            var getResponse = await _dynamoDb.GetItemAsync(getRequest);
            
            if (getResponse.Item == null)
            {
                return null;
            }

            var retrievedTicket = new Ticket(
                licensePlate: getResponse.Item["LicensePlate"].S,
                entryTime: DateTime.Parse(getResponse.Item["EntryTime"].S),
                parkingLotId: int.Parse(getResponse.Item["ParkingLotId"].N),
                ticketId: Guid.Parse(getResponse.Item["TicketId"].N),
                isCheckout: getResponse.Item["IsCheckout"].BOOL
            );
            
            return retrievedTicket;
        }

        catch (Exception exception)
        {
            throw new Exception("Failed to retrieve ticket from DynamoDB", exception);
        }
    }
}