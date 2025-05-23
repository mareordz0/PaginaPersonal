# --- Etapa de runtime: imagen ligera que solo ejecuta .NET ---
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS runtime
WORKDIR /app
EXPOSE 80

# --- Etapa de build: imagen con SDK para compilar tu código ---
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copia todo el repositorio al contenedor
COPY . .

# Publica en Release en la carpeta /app/publish
RUN dotnet publish PortafolioM.csproj -c Release -o /app/publish

# --- Etapa final: imagen de runtime con tus DLLs publicados ---
FROM runtime AS final
WORKDIR /app

# Copia los archivos publicados
COPY --from=build /app/publish .

# Punto de entrada: arranca tu aplicación
ENTRYPOINT ["dotnet", "PortafolioM.dll"]