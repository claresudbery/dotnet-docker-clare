# dotnet-docker-clare

Aim: Dockerising an ASP.Net Core app and deploying to Heroku.

Reason: I successfully Dockerised an ASP.Net Core app following [this tutorial here](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/building-net-docker-images?view=aspnetcore-5.0)...

...but I was unable to get it successfully deployed to Heroku. So then I started again from scratch, using this tutorial](https://docs.microsoft.com/en-us/aspnet/core/getting-started/?view=aspnetcore-5.0&tabs=windows)to create a vanilla ASP.Net Core app, and then [followed this article](https://medium.com/@vnqmai.hcmue/deploy-asp-net-core-to-heroku-for-free-using-docker-bd6d6fc161ae) to containerise it using Docker (see [notes below](#changes-i-made-from-medium-article)) and then deploy the Docker container to Heroku. But that put `Dockerfile` in a weird place...

So I ended up with a `Dockerfile` in the root that was mostly copied from [the original tutorial](https://docs.microsoft.com/en-us/aspnet/core/host-and-deploy/docker/building-net-docker-images?view=aspnetcore-5.0) but removed the `dotnet restore` command, and replace the `ENTRYPOINT` command with the line starting `CMD ASPNETCORE_URLS=`. This worked! 

# Deployed app

You can find the app [deployed in Heroku here](https://dotnet-docker-clare.herokuapp.com/).

# Changes I made from Medium article

Changes I need to make from that [Medium article](https://medium.com/@vnqmai.hcmue/deploy-asp-net-core-to-heroku-for-free-using-docker-bd6d6fc161ae):

- Check the [dotnet docker hub](https://hub.docker.com/_/microsoft-dotnet) for the latest Docker image (check out my Dockerfile - in dotnet-docker-clare\bin\Release\net5.0\publish\Dockerfile - for the result)
- Change the folder in the `docker build` command (for me it was bin\Release\net5.0\publish, for you it will depend on your .Net version - also I had to give it a fully qualified path, not a relative path)
    - Note: It bothers me that the Dockerfile is buried down in a publish folder, which apart from anything else means it doesn't automatically get pushed to source control - but I haven't managed to get it working yet with a `Dockerfile` in the root folder.
- I used the command `heroku container:push web --app dotnet-docker-clare` instead of the suggested `docker tag` and `docker push` commands
    - I was confused at first by the error "No images to push", but then I realised I needed to be in the same folder as the `Dockerfile` before I could run `heroku container` commands.
- Note that the Dockerfile is actually in the publish folder, but that doesn't get pushed to source control so I've copied a version to the root.