Passos para resetar todos os simuladores:
Abra o Terminal.

Execute o seguinte comando:

bash
Copiar
Editar
xcrun simctl shutdown all && xcrun simctl erase all
O que esse comando faz:
xcrun simctl shutdown all: garante que todos os simuladores estejam desligados.

xcrun simctl erase all: reseta todos os simuladores, apagando apps instalados, dados, etc.

xcrun simctl list runtimes
iOS 17.5 (17.5 - 21F79) - com.apple.CoreSimulator.SimRuntime.iOS-17-5
xcrun simctl list devicetypes

xcrun simctl create "iPhone2" "com.apple.CoreSimulator.SimDeviceType.iPhone-15" "com.apple.CoreSimulator.SimRuntime.iOS-17-5"



xcrun simctl list devices

open -a Simulator --args -CurrentDeviceUDID


Info.list
<key>NSLocationWhenInUseUsageDescription</key>
<string>Este aplicativo precisa acessar sua localização para encontrar restaurantes próximos a você</string>
