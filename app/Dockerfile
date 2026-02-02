# ---------- BUILD ----------
    FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

    WORKDIR /app
    COPY . .
    
    WORKDIR /app/DotNet-8-Crud-Web-API-Example/DotNetCrudWebApi
    
    RUN dotnet tool install --global dotnet-ef --version 8.*
    ENV PATH="$PATH:/root/.dotnet/tools"
    
    RUN dotnet restore
    RUN dotnet ef migrations bundle -o /app/efbundle --self-contained -r linux-x64
    RUN dotnet publish -c Release -o /app/publish
    
    # ---------- RUNTIME ----------
    FROM mcr.microsoft.com/dotnet/aspnet:8.0
    
    WORKDIR /app
    EXPOSE 8080
    
    RUN mkdir -p /app/data
    
    COPY --from=build /app/publish .
    COPY --from=build /app/efbundle ./efbundle
    COPY ./entrypoint.sh ./entrypoint.sh
    
    RUN chmod +x ./entrypoint.sh ./efbundle \
     && chmod -R 777 /app/data
    
    ENTRYPOINT ["./entrypoint.sh"]
