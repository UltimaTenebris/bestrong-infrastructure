FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY app/*.csproj ./
RUN dotnet restore

COPY app/. ./

RUN dotnet tool install --global dotnet-ef --version 8.0.2
ENV PATH="$PATH:/root/.dotnet/tools"

RUN dotnet ef migrations bundle -o /out/efbundle
RUN chmod +x /out/efbundle

RUN dotnet publish -c Release -o /out


FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

COPY --from=build /out ./

RUN mkdir -p /app/data && chmod 777 /app/data

ENTRYPOINT ["/bin/sh", "-c", "./efbundle && dotnet DotNetCrudWebApi.dll"]
