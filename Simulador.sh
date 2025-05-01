#!/bin/bash

# Defina o nome do simulador e o tipo de dispositivo (iPhone 15, iPhone 14, etc)
SIMULATOR_NAME="iPhone"
DEVICE_TYPE="com.apple.CoreSimulator.SimDeviceType.iPhone-15"
RUNTIME="com.apple.CoreSimulator.SimRuntime.iOS-17-5"

# Cria o simulador (caso não exista)
echo "Criando simulador $SIMULATOR_NAME..."
SIMULATOR_UDID=$(xcrun simctl create "$SIMULATOR_NAME" "$DEVICE_TYPE" "$RUNTIME")

# Verifica se a criação foi bem-sucedida
if [ -z "$SIMULATOR_UDID" ]; then
  echo "Falha ao criar o simulador. Abortando."
  exit 1
fi

echo "Simulador $SIMULATOR_NAME criado com sucesso. UDID: $SIMULATOR_UDID"

# Inicia o simulador
echo "Iniciando simulador $SIMULATOR_NAME..."
xcrun simctl boot "$SIMULATOR_UDID"

# Abre o simulador
echo "Abrindo o simulador..."
open -a Simulator --args -CurrentDeviceUDID "$SIMULATOR_UDID"

# (Opcional) Começa a mostrar os logs em tempo real
echo "Mostrando logs do simulador em tempo real..."
xcrun simctl spawn "$SIMULATOR_UDID" log stream --level debug
