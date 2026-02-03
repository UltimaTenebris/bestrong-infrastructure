# ---------- EF BUNDLE STAGE ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS efbundle
WORKDIR /src

# 1) ТІЛЬКИ те, що впливає на міграції
COPY app/*.csproj ./app/
COPY app/Migrations ./app/Migrations
COPY app/*DbContext*.cs ./app/

WORKDIR /src/app
RUN dotnet restore

# 2) ФІКСОВАНА версія tool (важливо для кешу)
RUN dotnet tool install --global dotnet-ef --version 8.0.1
ENV PATH="$PATH:/root/.dotnet/tools"

# 3) Генеруємо bundle
RUN dotnet ef migrations bundle \
    -r linux-arm64 \
    --self-contained \
    -o /out/efbundle

    # ---------- BUILD APP ----------
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# restore окремо
COPY app/*.csproj ./app/
WORKDIR /src/app
RUN dotnet restore

# весь код (можеш міняти — bundle НЕ перебудується)
COPY app/ ./

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

# ef bundle (закешований)
COPY --from=efbundle /out/efbundle ./efbundle

# entrypoint
COPY app/entrypoint.sh ./entrypoint.sh
RUN chmod +x ./entrypoint.sh ./efbundle

ENTRYPOINT ["./entrypoint.sh"]


