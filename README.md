# Epidemia
por: André Dias de Paula, Bernardo Drummond Oliveira Penna, Frederico Santos Gonçalves, Gabriel Della Gaspera

### Sobre:
Uma simulação simples utilizando ***Processing*** que utiliza uma grid quadrada onde habitam pessoas. Cada espaço desse tabuleiro pode conter:
- 🔴 uma pessoas infectada
- 🟢 uma pessoa saudável
- 🔵 uma pessoa imune
- ⚪ um espaço vazio

Cada pessoa se move conforme o seu tempo próprio ao longo do tabuleiro. Pessoas infectadas possuem uma chance de 50% de infectar as pessoas que não são imunes que estão ao seu lado após se moverem. Todos os infectados se recuperam após um intervalo de 1500 a 4500 frames, se tornando imunes.

Além disso, cada indivíduo possui um contador que guarda o número de pessoas que ela infectou. Esses dados são compilados e organizados por meio de um algoritmo de MergeSort para que sejam exibidos os 5 indivíduos que mais infectaram pessoas.

### Comandos:
- 1 ou M1: criar pessoa infectado
- 2 ou M2: criar pessoa saudável
- 3: criar pessoa imune
- TAB: alternar posição do placar
- BACKSPACE: reiniciar tabuleiro
