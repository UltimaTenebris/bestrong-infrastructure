using DotNetCrudWebApi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// ===== BLUE / GREEN MARKER =====
var APP_VERSION = Environment.GetEnvironmentVariable("APP_VERSION") ?? "1.1.0";

// ===============================

// Add services to the container.
var baseConnectionString = builder.Configuration.GetConnectionString("DefaultConnection");
if (string.IsNullOrWhiteSpace(baseConnectionString))
{
    throw new InvalidOperationException("Connection string 'DefaultConnection' was not found.");
}

var pgPassword = Environment.GetEnvironmentVariable("POSTGRES_PASSWORD");
if (string.IsNullOrWhiteSpace(pgPassword))
{
    throw new InvalidOperationException("POSTGRES_PASSWORD env var not set");
}

var connectionString = $"{baseConnectionString};Password={pgPassword}";

if (string.IsNullOrWhiteSpace(connectionString))
{
    throw new InvalidOperationException("Connection string 'DefaultConnection' was not found.");
}

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

using (var scope = app.Services.CreateScope())
{
    var dbContext = scope.ServiceProvider.GetRequiredService<AppDbContext>();
    dbContext.Database.Migrate();
}

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();
app.Run();
