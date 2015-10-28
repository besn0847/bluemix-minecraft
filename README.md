Minecraft server running in Docker container on Bluemix.


To start the container, simply type :
```
[prompt]> cf ic run -p 22:22 -p 9080:9080 -m 128 --name Minecraft registry.ng.bluemix.net/besnard_mobi/minecraft-server 
```

If you need to bind to an IP address :
```
[prompt]> cf ic ip list
[prompt]> cf ic ip bind <your_selected_public_ip> <your_container_id> 
```

Don't forget to change the default user password !!!
