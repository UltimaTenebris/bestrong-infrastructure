using DotNetCrudWebApi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;
using Serilog;
using Serilog.Sinks.OpenTelemetry;
using Serilog.Events;

var builder = WebApplication.CreateBuilder(args);

// ===== SERILOG + OTLP =====
Log.Logger = new LoggerConfiguration()
    .ReadFrom.Configuration(builder.Configuration)
    .MinimumLevel.Information()
    .Enrich.FromLogContext()
    .Enrich.WithProperty("service.name", builder.Configuration["Otlp:ServiceName"])
    .WriteTo.OpenTelemetry(options =>
    {
        options.Endpoint = builder.Configuration["Otlp:Endpoint"];
        options.Protocol = OtlpProtocol.Grpc;

        options.ResourceAttributes = new Dictionary<string, object>
        {
            ["service.name"] = "bestrong-api"
        };
    })
    .CreateLogger();


builder.Host.UseSerilog();
// ===========================

builder.Services.AddHealthChecks();

// ===== BLUE / GREEN MARKER =====
var APP_VERSION = Environment.GetEnvironmentVariable("APP_VERSION") ?? "1.1.0";
// ===============================

var baseConnectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (string.IsNullOrWhiteSpace(baseConnectionString))
{
    Log.Fatal("DefaultConnection missing");
    throw new InvalidOperationException("Connection string 'DefaultConnection' was not found.");
}

var pgPassword = Environment.GetEnvironmentVariable("POSTGRES_PASSWORD");
if (string.IsNullOrWhiteSpace(pgPassword))
{
    Log.Fatal("POSTGRES_PASSWORD not set");
    throw new InvalidOperationException("POSTGRES_PASSWORD env var not set");
}

var connectionString = $"{baseConnectionString};Password={pgPassword}";

builder.Services.AddDbContext<AppDbContext>(options =>
    options.UseNpgsql(connectionString));

builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = APP_VERSION,
    });
});

var app = builder.Build();

app.UseSerilogRequestLogging();


using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    Log.Information("Applying database migrations...");
    dbContext.Database.Migrate();
    Log.Information("Database migration completed");
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseAuthorization();

app.MapHealthChecks("/health", new Microsoft.AspNetCore.Diagnostics.HealthChecks.HealthCheckOptions
{
    AllowCachingResponses = false,
    ResultStatusCodes =
    {
        [Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus.Healthy] = StatusCodes.Status200OK,
        [Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus.Degraded] = StatusCodes.Status200OK,
        [Microsoft.Extensions.Diagnostics.HealthChecks.HealthStatus.Unhealthy] = StatusCodes.Status503ServiceUnavailable
    }
});

app.MapControllers();

Log.Information("BeStrong API started. Version: {Version}", APP_VERSION);

app.Run();