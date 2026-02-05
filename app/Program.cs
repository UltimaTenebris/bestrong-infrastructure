using DotNetCrudWebApi.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.OpenApi.Models;

var builder = WebApplication.CreateBuilder(args);

// ===== BLUE / GREEN MARKER =====
const string APP_VERSION = "1.0.4";
// ===============================

// Add services to the container.
builder.Services.AddDbContext<AppDbContext>();
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();

builder.Services.AddHealthChecks();


builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo
    {
        Version = APP_VERSION,
    });
});

var app = builder.Build();

if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

//app.UseHttpsRedirection();
app.UseAuthorization();
app.MapHealthChecks("/health");

app.MapControllers();
app.Run();
