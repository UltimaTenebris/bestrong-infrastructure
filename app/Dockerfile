# ---------- BUILD ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# 1) Restore кешований: копіюємо тільки csproj (+ optional files)
COPY app/*.csproj ./app/
WORKDIR /src/app
RUN dotnet restore

# 2) Копіюємо весь код
COPY app/ ./ 

# 3) EF tool (тільки в build stage)
RUN dotnet tool install --global dotnet-ef --version 8.*
ENV PATH="$PATH:/root/.dotnet/tools"

# 4) Збірка міграційного bundle (self-contained під linux-x64)
#    Важливо: output робимо в окрему директорію, щоб потім копіювати як файл
RUN dotnet ef migrations bundle \
    -r linux-arm64 \
    --self-contained \
    -o /out/efbundle


# 5) Publish апки
RUN dotnet publish -c Release -o /out/publish


# ---------- RUNTIME ----------
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# sqlite folder
RUN mkdir -p /app/data && chmod -R 777 /app/data

# app binaries
COPY --from=build /out/publish/ ./

# ef bundle як executable файл
COPY --from=build /out/efbundle ./efbundle

# entrypoint (якщо entrypoint.sh в repo root)
COPY app/entrypoint.sh ./entrypoint.sh

RUN chmod +x ./entrypoint.sh ./efbundle

ENTRYPOINT ["./entrypoint.sh"]
