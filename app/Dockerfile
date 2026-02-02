FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# копіюємо тільки csproj
COPY app/*.csproj ./
RUN dotnet restore

# копіюємо решту
COPY app/. ./

# EF тільки для збірки
RUN dotnet tool install --global dotnet-ef --version 8.0.2
ENV PATH="$PATH:/root/.dotnet/tools"

# зібрати міграції в bundle
RUN dotnet ef migrations bundle \
  --runtime linux-x64 \
  -o /out/efbundle
RUN chmod +x /out/efbundle


# зібрати апку
RUN dotnet publish -c Release -o /out


# -------- RUNTIME --------
FROM --platform=linux/amd64 mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app

EXPOSE 5000

COPY --from=build /out .

RUN mkdir -p /app/Data && chmod 777 /app/Data
RUN mkdir -p /app/data && chmod 777 /app/data


ENTRYPOINT ["/bin/sh", "-c", "./efbundle || true && dotnet DotNetCrudWebApi.dll"]
