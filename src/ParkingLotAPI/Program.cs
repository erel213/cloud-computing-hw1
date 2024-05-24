using Amazon;
using Amazon.DynamoDBv2;
using Amazon.Extensions.NETCore.Setup;
using Amazon.Runtime;
using ParkingLotAPI.Handlers;
using ParkingLotAPI.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

#region Configure AWS

AWSOptions awsOptions = new AWSOptions()
{
    Credentials = new EnvironmentVariablesAWSCredentials(),
    Region = RegionEndpoint.EUWest1
};
builder.Services.AddDefaultAWSOptions(awsOptions);
builder.Services.AddAWSService<IAmazonDynamoDB>();

#endregion

#region Configure Dependecy Injection Containers

builder.Services.AddScoped<ITicketRepository, TicketRepository>();
builder.Services.AddScoped<IParkingLotHandler, ParkingLotHandler>();

#endregion

var app = builder.Build();

// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.MapControllers();

app.Run();