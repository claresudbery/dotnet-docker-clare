# Note that the original Dockerfile is actually in the publish folder, 
# but that seems like the wrong location so I'm experimenting with having it here instead.
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY dotnet-docker-clare/*.csproj ./dotnet-docker-clare/

# copy everything else and build app
COPY dotnet-docker-clare/. ./dotnet-docker-clare/
WORKDIR /source/dotnet-docker-clare
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./

# Tell Docker that when we run "docker run", we want it to
# run the following command:
CMD ASPNETCORE_URLS=http://*:$PORT dotnet dotnet-docker-clare.dll
# $PORT is set by Heroku - we don't use port 5000 like we normally would with ASP.Net


