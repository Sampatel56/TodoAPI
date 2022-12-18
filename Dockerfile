FROM mcr.microsoft.com/dotnet/sdk:6.0 AS sdk
FROM mcr.microsoft.com/dotnet/aspnet:6.0 AS runtime

FROM sdk AS build
COPY . /src
WORKDIR "/scr/"

RUN dotnet restore "TodoAPI/TodoAPI.csproj"
RUN dotnet build

FROM build AS publish
WORKDIR "/src/"
RUN dotnet publish -c Release -o /app

FROM runtime AS final 
WORKDIR "/app"
COPY --from=publish /app .

EXPOSE 80
ENTRYPOINT ["dotnet", "TodoAPI.dll", "--urls", "http://*:80"] 