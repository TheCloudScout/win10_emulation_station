Emulation Station configurado para Windows 10
======

Auto instalador para configurar corretamente o Emulation Station em uma máquina com Windows 10 64bit.

Destaques
-----

- Usa uma versão atualizada do Emulation Station da branch do Raspery Pi
- Popula automaticamente emuladores com roms de domínio público
- Instala automaticamente um tema popular com suporte para a adição de favoritos
- Instalador inicial com menos alguns KB, já que são apenas scripts
- Inclue um recuperador de informações de roms dentro da pasta de rom (execute %UserProfile%\\.emulationstation\roms\scraper.exe)

Passo-a-passo
-----

1. Execute prepare.ps1 em uma sessão administrativa Powershell
  (NOTA: Powershell pode reiniciar seu computador já que algumas bibliotecas requerem o reinício, se isto ocorrer, simplesmente re-execute depois de seu PC reiniciar)
2. Execute o Emulation Station and aproveite
3. Acesse suas ROMS aqui %UserProfile%\\.emulationstation\roms

GIF da instalação:
![alt text](https://github.com/Francommit/github_gif_dump/blob/master/installation-instructions.gif?raw=true)

Informações adicionais
-----

Se deseja saber mais sobre o projeto ou comentar algo, pode visitar os posts abaixo do meu blog:

[Emulationstation - configuração simples para Windows](https://paulorobertoelias.com.br/2018-07-04-emulationstation-configuracao-simples-para-windows/)  
[Emulationstation fácil para Windows - novidades](https://paulorobertoelias.com.br/2018-09-09-emulationstation-facil-para-windows-novidades/)  

Recursos Opcionais e Dicas
-----

- Se você prefere executar seus scripts usando o menu de contexto (botão direito do mouse), mas não possui a opção de executá-los em modo administrador, você pode simplesmente dar um duplo-clique no arquivo "powershell_run-as-admin.reg" e aceitar as modificações ao registro. Será criado uma nova entrada no menu para executar facilmente
- Se você usa o OneDrive para armazenar suas ROMs e saves, pode executar o script onedrive.ps1 ou pode modificá-lo para qualquer outra pasta específica. Mais instruções nos comentários
- Alguns novos temas apresentam vídeos: [es-theme-crt](https://github.com/PRElias/es-theme-crt)
- Script para recuperar informações (scraper) de forma fácil incluído. Apenas execute e ele fará o backup dos arquivos gamelist.xml para cada pasta de ROMs e produzirá um novo arquivo com dados recuperados dos serviços de scrap (se você modificou sua pasta de ROMs, por favor, confira a mesma antes de executar)

Possíveis problemas e soluções
-----

- Se o seu controle não está funcionando no jogo, configure o Input no Retroarch (%UserProfile%\\.emulationstation\systems\retroarch\retroarch.exe)
- Jogos de PS1 and PS2 não carregam a não ser que você tenha e inclua suas bios nas respectivas pastas (%UserProfile%\.emulationstation\systems\epsxe\bios e %UserProfile%\\.emulationstation\systems\pcsx2\bios)
- PS1 e PS2 também requerem configuração manual para os controles(%UserProfile%\.emulationstation\systems\epsxe\ePSXe.exe e %UserProfile%\\.emulationstation\systems\pcsx2\pcsx2.exe)
- Se o script falhar por qualquer razão, apague o conteúdo da pasta %UserProfile%\\.emulationstation e tente novamente.
- O Emulation Station pode travar quando você retorna para ele depois de um programa externo, certifique-se que sua placa de vídeo possui os drivers atualizados.
- Se ao executar uma rom no Retroarch, retornar para o Emulationstation, você provavelmente está em uma versão 32-bit do Windows e precisará de outros cores (DLLs do Retroarch).
- Comandos Powershell podem falhar, certifique-se que sua sessão está em modo administrador.
- Se o Powershell reclamar da sintaxe, você provavelmente está executando uma versão do Powershell abaixo da 5. Execute 'choco install powershell -y' para atualizar.
- Se você estiver usando controles do Xbox e tendo problemas ao configurar o botão guia como hotkey, localize o arquivo (%UserProfile%\\.emulationstation\es_input.cfg e altere a linha do hotkeyenable para ```<input id="5" name="hotkeyenable" type="button" value="10" />```
- Se você não conseguir executar o script no menu de contexto (botão direito do mouse), reverta o padrão "Abrir com" para o Bloco de Notas.

Traduções
-----

[English](README.en.md)


Agradecimentos Especiais
-----

- [jrassa](https://github.com/jrassa/EmulationStation) pela sua versão atualizada da compilação do Emulation Station
- [Nesworld](http://www.nesworld.com/) por suas ROMs livres de NES  
- [Libretro](https://www.libretro.com/) por sua versão do Retroarch  
- [dtgm](https://chocolatey.org/packages/emulationstation) por manter o pacote chocolatey do Emulation Station 
- [OpenEmu](https://github.com/OpenEmu/OpenEmu-Update) por seu trabalho na coleção de rom livres 
- [recalbox](https://github.com/recalbox/recalbox-themes) por seus temas 
- [sselph](https://github.com/sselph/scraper) por seu maravilhoso recuperador de informações de roms 
- [Paulo Elias](http://paulorobertoelias.com.br) pela tradução em Português do Brasil, automatização do choco e funcionalidades opcionais
- [Chris Franco](https://github.com/Francommit) que teve a ideia e montou toda a estrutura do script original 
