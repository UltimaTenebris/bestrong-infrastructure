FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY app/*.csproj ./app/
RUN dotnet restore ./app/DotNetCrudWebApi.csproj

COPY app/ ./app/
RUN dotnet publish ./app/DotNetCrudWebApi.csproj -c Release -o /out/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /out/publish/ ./
ENTRYPOINT ["dotnet", "DotNetCrudWebApi.dll"]
