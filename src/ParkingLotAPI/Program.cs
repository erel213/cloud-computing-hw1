using Amazon;
using Amazon.DynamoDBv2;
using Amazon.Extensions.NETCore.Setup;
using Amazon.Runtime;
using Microsoft.Extensions.Diagnostics.HealthChecks;
using ParkingLotAPI.Handlers;
using ParkingLotAPI.Repositories;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

#region Configure AWS

AWSOptions awsOptions;
var env = Environment.GetEnvironmentVariable("ENV_VAR");
if (env == "production")
{
    awsOptions = new AWSOptions()
    {
        Region = RegionEndpoint.EUWest1
    };
}

else
{   
    awsOptions = new AWSOptions()
    {
        Credentials = new EnvironmentVariablesAWSCredentials(),
        Region = RegionEndpoint.EUWest1
    };
}

builder.Services.AddDefaultAWSOptions(awsOptions);
builder.Services.AddAWSService<IAmazonDynamoDB>();


#endregion

builder.Services.AddHealthChecks()
    .AddCheck("health", () =>
        HealthCheckResult.Healthy("The check indicates a healthy result."), tags: new[] { "example" });

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

// Map health checks to a specific endpoint
app.MapHealthChecks("/health");

app.MapControllers();

app.Run();