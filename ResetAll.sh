#!/bin/bash

# 1. Fechar todos os simuladores abertos
echo "Fechando todos os simuladores..."
killall Simulator

# 2. Desligar todos os simuladores
echo "Desligando todos os simuladores..."
xcrun simctl shutdown all

# 3. Apagar todos os simuladores e seus dados
echo "Apagando todos os simuladores e dados..."
xcrun simctl erase all

# 4. Remover diretórios corrompidos dos simuladores
echo "Removendo diretórios de simuladores corrompidos..."
rm -rf ~/Library/Developer/CoreSimulator

# 5. Resetar Xcode CLI (se necessário)
echo "Resetando Xcode CLI..."
sudo xcode-select --reset

# 6. Remover e reinstalar o Command Line Tools (se necessário)
echo "Removendo Command Line Tools..."
sudo rm -rf /Library/Developer/CommandLineTools
echo "Instalando novamente Command Line Tools..."
xcode-select --install

# 7. Reinstalar runtimes iOS (se necessário, ajuste conforme o que você usa)
echo "Reinstalando runtimes iOS..."
# Essa etapa deve ser feita manualmente no Xcode, via:
# Xcode -> Preferences -> Components -> Reinstalar o runtime desejado

# 8. Confirmar se o simulador está funcionando
echo "Verificando se o simulador está funcionando..."
open -a Simulator
