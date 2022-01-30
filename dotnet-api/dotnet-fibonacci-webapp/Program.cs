using Microsoft.Extensions.Hosting;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Server.Kestrel.Core;
using System.Net;

await Host.CreateDefaultBuilder(args)
    .ConfigureWebHostDefaults(config => {
            
            config
            .ConfigureKestrel(options => {
                options.Listen(IPAddress.Any, 8082, listenOptions =>
                    {
                        listenOptions.Protocols = HttpProtocols.Http1AndHttp2;
                    });
                options.Limits.MaxConcurrentConnections = 200;
                options.Limits.KeepAliveTimeout = TimeSpan.FromMinutes(5);
            })
            .Configure(app => {

                app.UseRouting()
                .UseEndpoints(endpoint => {

                    endpoint.MapGet("/fibonacci" ,GetFibonacci);
                    endpoint.MapGet("/healthz",GetHealthz);

                });

            });
    })
    .Build()
    .RunAsync();

    async void GetHealthz(HttpContext context){
         await context.Response.WriteAsync("Ok");
    }

    async void GetFibonacci( HttpContext context ){

        var startTime = DateTime.Now;
        var result = Fibonacci.Run();
        var endTime = DateTime.Now;
        
        var duration = (endTime - startTime).Ticks / 10000;
        await context.Response.WriteAsync(duration.ToString()+ " ms");

    }





