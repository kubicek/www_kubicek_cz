---
title: Programovatelný vařič
tags: [termostat, PID]
slug: programovatelny_varic
---

## Idea

Pro [eloxování](hliník) by bylo vhodné mít zařízení, které by umožňovalo dosažení a udržení kapaliny v požadované teplotě.

První nápad spočíval v úpravě plotýnkového vařiče a jeho spínání pomocí stykačů ovládaných esp32 na základě teplot zjištěných z DS18B20.

V zásobách jsem nalezl dvě desky Original Prusa HeatBed Mk42 s NTC 100k termistorem.

> The Mk42 heat bed is rated at 12V and has a nominal resistance of 1 Ohm. The copper tracks of the heated bed are the resistor. Put 12V though and it will draw 12 Amps and generate 144W of heat<br />
> -- <cite><https://forum.prusa3d.com/forum/original-prusa-i3-mk3s-mk3-improvements-archive/heating-bed-with-24-volts/></cite>
{: .prompt-info}

Deska si vezme 12A a vygeneruje 144W tepla

> The amount of energy needed to raise the temperature of 1 g of water by 1 degree Celcius or (1 Kelvin) equals 1 calorie. And 1 calorie equals 4,184 Joule. So if you want to raise the temperature of 1 litre of water (1 litre = 1000g for water) by 80 degrees Celcius, your calculation should look like this: 1000g\*4,184J/(g*°C)*80°C= 334 720 Joules <br/>
> 1 kWh = 3 600 000 Joules, because 1 watt of power during 1 second equals 1 Joule. So 3600 seconds in 1 hour multiplied with a power of 1000 Watt equals 3 600 000 Joules. <br/>
> 334 720 / 3 600 000 = 0,093 kWh of energy to heat 1 kg of water from 20 °C tot 100 °C<br/>
> If you want to deliver 0,093 kWh in 1 minute instead of 1 hour, the required power output during that minute would be 0,093*60 = 5,58 kW or 5580 Watt. <br/>
> -- <cite><https://www.quora.com/How-many-watts-do-you-need-to-boil-water></cite>
{: .prompt-info}

Zdá se, že za hodinu bychom mohli na desce uvařit litr vody, tedy pro udržení teploty kolem 90°C nebo 50°C bychom měli mít dostatek výkonu. Problematické by mohlo být rozprostřední výkonu do celé plochy desky, zatímco ohřívaná kapalina bude v menší nádobě.

Pro spínání desky jsem v zásobách nalezl modul HW-700, který by měl být schopen spínat až 25A.

Mělo by tedy stačit na esp32 postavit PID regulátor, propojit vstup do HW-700, připojit termistor na desce a připojit DS18B20 pro měření teploty kapaliny.

U neagresivních kapalin může měření probíhat ponořením do kapaliny, u agresivních kapalin budeme měřit přiložením na nádobu.

Asi nejjednodušší je použí a nakonfigurovat ESPHome, který již obsahuje modul [PID Climate](https://esphome.io/components/climate/pid.html), včetně autotune parametrů.

PID regulátor bych napojl na čidlo teploty kapaliny a termistor na desce bych nechal pouze pro účely horního limitu teploty ohřevu desky.

V ESPHome tedy budeme mít dva sensory (NTC Sensor a Dallas Temperature Sensor), jeden PID regulátor (PID Climate) a jeden výstup (GPIO Switch).

Termistor se připojuje přes odpor, který slouží jako dělič napětí. <https://learn.adafruit.com/thermistor/using-a-thermistor#self-heating-3-22>. Jeho 3.3V výstup připojíme na GPIO a budeme ho spínat jen na dobu měření, abychom předešli jeho samovolnému ohřevu

DS18B20 se připojuje přes odpor 4.7kOhm.

## Materiál
* deska HeatBed MK42 + NTC 100k termistor
* modul HW-700
* modul ESP32
* čidlo s DS18B20 na kabelu
* odpor 4.7kOhm pro DS18B20
* odpor 100kOhm pro termistor
* zdroj 12V asi 16A
* step-down 12V -> 3.3V pro ESP32

## Konfigurace

```
dallas:
  - pin: 23
sensor:
  - platform: dallas
    id: liquid_temperature
    # address: 0x1c0000031edd2a28
    name: "Liquid Temperature"
  - platform: ntc
    id: heatbed_ntc
    name: "heatbed Temperature"
    sensor: heatbed_resistance_sensor
    calibration:
      b_constant: 3950
      reference_temperature: 25°C
      reference_resistance: 100kOhm
      #- 10.0kOhm -> 25°C
      #- 27.219kOhm -> 0°C
      #- 14.674kOhm -> 15°C
  - platform: resistance
    id: heatbed_resistance_sensor
    sensor: heatbed_sensor
    configuration: DOWNSTREAM
    resistor: 100kOhm
    name: Resistance Sensor
  - platform: adc
    id: heatbed_sensor
    pin: A0
    update_interval: never
switch:
  - platform: gpio
    pin: D0
    id: heatbed_ntc_vcc
  - platform: gpio
    id: heatbed_switch
    pin:
      number: 25
      # default off
      inverted: true
interval:
  - interval: 60s
    then:
      - switch.turn_on: heatbed_ntc_vcc
      - component.update: heatbed_sensor
      - switch.turn_off: heatbed_ntc_vcc
climate:
  - platform: pid
    name: "PID Climate Controller"
    sensor: temperature_sensor
    default_target_temperature: 21°C
    heat_output: heater
    control_parameters:
      kp: 0.49460
      ki: 0.00487
      kd: 12.56301
      output_averaging_samples: 5
      derivative_averaging_samples: 5
    deadband_parameters:
      threshold_high: 2.5°C
      threshold_low: -2.5°C
```
