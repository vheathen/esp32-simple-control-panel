# Esp32 Simple Control

The very first experience and look on a esp32 devkit v1 and micro-controllers in overall, kind of extended "Hello, world".
Nothing polished, dirty and non-optimized code and so on, just to check if it works.

Let's manage a led remotely with:

1. An esp32 micro-controller running esp-idf based mqtt client (check [firmware external repository](https://github.com/vheathen/esp32-simple-control-firmware))
2. A remote mqtt server (VerneMQ)
3. A remote web-server (Elixir + Phoenix Framework && Phoenix LiveView + Tortoise) as a control panel
 
To start your control panel server:

  * Checkout this project and open its directory
  * Start a VerneMQ docker container with `sudo docker-compose -f vernemq/docker-compose.yml up -d` (you can actually use any MQTT server). Please mind that mqtt server must be reachable from your esp32 device
  * Edit config/config.exs and adapt `mqtt_host` and `mqtt_port` parameters to your situation
  * Install dependencies with `mix deps.get`
  * Install Node.js dependencies with `npm install --prefix assets`
  * Start Phoenix endpoint with `mix phx.server`
  * Build esp32 firmware (check the project by a link above), upload it and restart the micro-controller

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser and try to manage your dev board led.

If you use Windows 10 and running docker and\or web-server in WSL2 then you might probably find `redirect_to_wsl2.ps1` script useful to redirect ports from the local machine to WSL2 instance.

## Got any questions?

Please, open an issue.