void setup() {
    noStroke();
    textSize(tamanhoCelula * 0.25);
}

void settings() {
    size(tamanho * tamanhoCelula, tamanho * tamanhoCelula);
}

void draw() {
    if(!pausado) for(int i = 0; i < veloccicloAcaoTempo; i++) simular(); // A simulação só rodara caso não esteja pausado
    
    int ultimoX = mouseXGrid;
    int ultimoY = mouseYGrid;
    mouseXGrid = mouseX / tamanhoCelula;
    mouseYGrid = mouseY / tamanhoCelula;

    if(mouseXGrid != ultimoX || mouseYGrid != ultimoY) {
        ultimaTrocaSelecao = 0;
    }

    desenhaFundo();

    // Loop em cada pessoa
    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoas[i][j] != null) { 

                // Altera, gradualmente, a cor da pessoa para o estado atual dela
                if(pessoas[i][j].estado == Estado.SUSCETIVEL) {
                    pessoas[i][j].col = lerpColor(pessoas[i][j].col, COLOR_SUSCETIVEL, min(1, tempoInterpolacaoCor * veloccicloAcaoTempo));
                } else if(pessoas[i][j].estado == Estado.INFECTADO) {
                    pessoas[i][j].col = lerpColor(pessoas[i][j].col, COLOR_INFECTADO, min(1, tempoInterpolacaoCor * veloccicloAcaoTempo));
                } else if(pessoas[i][j].estado == Estado.IMUNE) {
                    pessoas[i][j].col = lerpColor(pessoas[i][j].col, COLOR_IMUNE, min(1, tempoInterpolacaoCor * veloccicloAcaoTempo));
                }
 
                // Altera, gradualmente, a posição e o tamanho da pessoa na tela
                PVector posicaoReal = new PVector(i * tamanhoCelula, j * tamanhoCelula);
                pessoas[i][j].posicaoTela.lerp(posicaoReal, min(tempoInterpolacaoMovimento * veloccicloAcaoTempo, 1));
                
                pessoas[i][j].tamanho = lerp(pessoas[i][j].tamanho, tamanhoCelula * 0.8, min(tempoInterpolacaoTamanho * veloccicloAcaoTempo, 1) );

                // Desenha cada pessoa
                fill(pessoas[i][j].col);
                rect(pessoas[i][j].posicaoTela.x + (tamanhoCelula - pessoas[i][j].tamanho) / 2, 
                    pessoas[i][j].posicaoTela.y + (tamanhoCelula - pessoas[i][j].tamanho) / 2, 
                    pessoas[i][j].tamanho, pessoas[i][j].tamanho, 
                    tamanhoCelula / 3);

                // Escreve o ID da pessoa
                textAlign(CENTER, CENTER);
                fill(255);
                textSize(tamanhoCelula * 0.4);

                text(str(pessoas[i][j].id), 
                    pessoas[i][j].posicaoTela.x + (tamanhoCelula - pessoas[i][j].tamanho) / 2, 
                    pessoas[i][j].posicaoTela.y + (tamanhoCelula - pessoas[i][j].tamanho) / 2, 
                    pessoas[i][j].tamanho, pessoas[i][j].tamanho);
            }
        }
    }

    desenhaPlacar();
}
 
// Desenha o fundo super legal
void desenhaFundo() {
    background(15, 34, 42);
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++) {
            if((i + j) % 2 == 0) {
                fill(20, 41, 52);
                rect(i * tamanhoCelula, j * tamanhoCelula, tamanhoCelula, tamanhoCelula, 10);
            }
            // Mostra a célula que o mouse está em cima
            if(mouseXGrid == i && mouseYGrid == j) {
                fill(255, 255, 255, 50);
                rect(i * tamanhoCelula, j * tamanhoCelula, tamanhoCelula, tamanhoCelula, 10);
            }
        }
}

void desenhaPlacar() {
    textSize(16);

    // Lista de todas as pessoas
    Pessoa[] todos = new Pessoa[0];
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++)
            if(pessoas[i][j] != null) 
                todos = (Pessoa[])append(todos, pessoas[i][j]);
    if(todos.length == 0) return;

    // Obtém a posição do placar
    int nTop;
    nTop = min(todos.length, 5);
    PVector tamanhoPlacar = new PVector(240, 8 + 28 * (nTop + 1));
    PVector posPlacar = new PVector(0, 0);
    switch(posicaoPlacar) {
        case 0:
            posPlacar = new PVector(4, 4);
        break;
        case 1:
            posPlacar = new PVector(width - tamanhoPlacar.x - 4, 4);
        break;
        case 2:
            posPlacar = new PVector(width - tamanhoPlacar.x - 4, height - tamanhoPlacar.y - 4);
        break;
        case 3:
            posPlacar = new PVector(4, height - tamanhoPlacar.y - 4);
        break;
    }

    // Organiza o vetor
    todos = mergeSort(todos);
    
    // Lista com os 5 melhores (ou menos)
    Pessoa[] top5 = new Pessoa[5];
    for(int i = 0; i < 5; i++) {
        if(todos.length - i - 1 >= 0) top5[i] = todos[todos.length - i - 1];
    }

    // Desenha o placar
    fill(15, 34, 42, 220);
    stroke(255);
    rect(posPlacar.x, posPlacar.y, tamanhoPlacar.x, tamanhoPlacar.y, 8);
    noStroke();
    fill(255);
    textAlign(LEFT, CENTER);
    text("ID", posPlacar.x + 4, posPlacar.y + 4, tamanhoPlacar.x - 8, (tamanhoPlacar.y - 8) / (nTop + 1) - 8);
    textAlign(RIGHT, CENTER);
    text("Infectados", posPlacar.x + 4, posPlacar.y + 4, tamanhoPlacar.x - 8, (tamanhoPlacar.y - 8) / (nTop + 1) - 8);

    // Escreve o nome dos Top 5
    for(int i = 0; i < nTop; i++) {
        textAlign(LEFT, CENTER);
        text(str(top5[i].id), 
            posPlacar.x + 4, 
            posPlacar.y + 4 + (i + 1) * (tamanhoPlacar.y - 0) / (nTop + 1), 
            tamanhoPlacar.x - 8, 
            (tamanhoPlacar.y - 8) / (nTop + 1) - 8);

        textAlign(RIGHT, CENTER);
        text(str(top5[i].pessoasInfectadas), 
            posPlacar.x + 4, 
            posPlacar.y + 4 + (i + 1) * (tamanhoPlacar.y - 0) / (nTop + 1), 
            tamanhoPlacar.x - 8, 
            (tamanhoPlacar.y - 8) / (nTop + 1) - 8);
    }
}

Pessoa[] mergeSort(Pessoa[] array) {
    if(array.length <= 1) return array;

    int meio = array.length / 2;

    // Divide o vetor em 2
    Pessoa[] subArray1 = mergeSort((Pessoa[])subset(array, 0, meio));
    Pessoa[] subArray2 = mergeSort((Pessoa[])subset(array, meio));

    Pessoa[] arrayOrdenado = new Pessoa[array.length];
    int i = 0, j = 0, k = 0;

    // Ordena o vetor
    while(i < subArray1.length && j < subArray2.length) {
        if(subArray1[i].pessoasInfectadas < subArray2[j].pessoasInfectadas) {
            arrayOrdenado[k++] = subArray1[i++];
        } else if(subArray1[i].id < subArray2[j].id && subArray1[i].pessoasInfectadas == subArray2[j].pessoasInfectadas) {
            arrayOrdenado[k++] = subArray1[i++];
        } else {
            arrayOrdenado[k++] = subArray2[j++];
        }
    }

    while(i < subArray1.length) arrayOrdenado[k++] = subArray1[i++];
    while(j < subArray2.length) arrayOrdenado[k++] = subArray2[j++];

    // Retorna o vetor organizado
    return arrayOrdenado;
}

void simular() {
    // Cria um vetor clone de pessoas (para fazer as atualizações)
    Pessoa[][] pessoasNovo = new Pessoa[tamanho][tamanho];  

    /* Para cada pessoa no vetor, a pessoa envelhece, atualizar
     * o contador de "tempo infectado" e, se a pessoa já puder
     * se recuperar, ela é considerada imune 
     */ 
    for(int x = 0; x < tamanho; x++) {
        for(int y = 0; y < tamanho; y++) {

            if(pessoas[x][y] != null) {
                pessoas[x][y].cicloAcao += 1;
                if(pessoas[x][y].estado == Estado.INFECTADO) {
                    pessoas[x][y].tempoInfeccao += 1;
                    if(pessoas[x][y].tempoInfeccao >= pessoas[x][y].tempoRecuperacao) pessoas[x][y].estado = Estado.IMUNE;
                }
            }
            pessoasNovo[x][y] = pessoas[x][y];
        }
    }

    // Para cada pessoa no vetor, se for momento dela fazer uma ação,
    // ela se move para alguma posição adjacente
    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoas[i][j] != null && pessoas[i][j].cicloAcao > pessoas[i][j].tempoAcao) {
                pessoas[i][j].cicloAcao = 0;

                // Vetor que cuida das possíveis posições que a pessoa pode ir
                PVector[] adjacentes = new PVector[0];

                // Posições (adjacentes) que a pessoa pode ir
                for(int x = -1; x <= 1; x++) {
                    for(int y = -1; y <= 1; y++) {
                        if((x != 0 || y != 0)               // Se não for da, exatamente, mesma posição da pessoa atual
                        && x + i >= 0 && x + i < tamanho    // Se o movimento x estiver dentro da área do grid
                        && y + j >= 0 && y + j < tamanho) { // Se o movimento y estiver dentro da área do grid

                            // Adiciona essa posição para o vetor
                            adjacentes = (PVector[])append(adjacentes, new PVector(i + x, j + y));
                        }
                    }
                }

                // Escolhe um valor de 1 a 8 (8 = número máximo de casas adjacentes).
                // Se a respectiva casa escolhida estiver vazia, se move para ela.
                int index = (int)random(8); 
                if(index < adjacentes.length) {
                    int x = (int)adjacentes[index].x;
                    int y = (int)adjacentes[index].y;
                    if(pessoasNovo[x][y] == null) {
                        // Se move para a casa escolhida e deixa a casa
                        // que a pessoa atual estava vazia
                        pessoasNovo[i][j] = null;
                        pessoasNovo[x][y] = pessoas[i][j];
                    }
                }
            }
        }
    }


    // Loop em cada pessoa (infectada)
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++) {
            if(pessoasNovo[i][j] != null)
                if(pessoasNovo[i][j].estado == Estado.INFECTADO && pessoasNovo[i][j].cicloAcao == 0) {
                    // Lista que guarda as posições (com pessoas) que pode infectar
                    ArrayList<PVector> infectaveis = new ArrayList<PVector>();

                    // Verifica as casas adjacentes para ver se pode infectar alguém
                    for(int x = -1; x <= 1; x++)
                        for(int y = -1; y <= 1; y++)
                            if((x != 0 || y != 0)               // Se não for da, exatamente, mesma posição da pessoa atual
                            && x + i >= 0 && x + i < tamanho    // Se o movimento x estiver dentro da área do grid
                            && y + j >= 0 && y + j < tamanho)   // Se o movimento y estiver dentro da área do grid
                                if(pessoasNovo[i + x][j + y] != null) // Se alguém estiver naquela casa
                                    if(pessoasNovo[i + x][j + y].estado == Estado.SUSCETIVEL) // Se a pessoa naquela casa for suscetível
                                        // Adiciona a pessoa na lista de "infectáveis" 
                                        infectaveis.add(new PVector(i + x, j + y));         

                    
                    // Se encontrou, pelo menos, uma pessoa para infectar,
                    // tenta a sorte para infectá-la!
                    if(infectaveis.size() > 0) {
                        // Tenta infectar todas as pessoas infectáveis
                        for(PVector posicao : infectaveis) {
                            int x = (int)posicao.x;
                            int y = (int)posicao.y;
                            if(random(1) <= chanceContagio) {
                                pessoasNovo[i][j].pessoasInfectadas++;
                                pessoasNovo[x][y].estado = Estado.INFECTADO;
                            }
                        }
                    }
                }
            
        }

    // O vetor pessoas agora é o clone
    pessoas = pessoasNovo;
}

void mouseReleased() {
    // Se o mouse está em cima de uma célula válida, adiciona
    // uma pessoa infectada ou suscetível nela.
    if(mouseXGrid >= 0 && mouseXGrid < tamanho && mouseYGrid >= 0 && mouseYGrid < tamanho) {
        if(pessoas[mouseXGrid][mouseYGrid] == null) {
            Estado estado = null;
            switch(mouseButton) {
                case LEFT:
                    estado = Estado.INFECTADO;
                break;
    
                case RIGHT:
                    estado = Estado.SUSCETIVEL;
                break;
            }

            // Adiciona uma pessoa se a entrada for certa
            if(estado != null) pessoas[mouseXGrid][mouseYGrid] = new Pessoa(estado);
            pessoas[mouseXGrid][mouseYGrid].posicaoTela = new PVector(mouseXGrid * tamanhoCelula, mouseYGrid * tamanhoCelula);
        }
    }
}

void keyPressed() {
    if(mouseXGrid >= 0 && mouseXGrid < tamanho && mouseXGrid >= 0 && mouseXGrid < tamanho) {
        if(pessoas[mouseXGrid][mouseXGrid] == null) {
            Estado estado = null;
            switch(key) {
                case '1':
                    estado = Estado.INFECTADO;
                break;

                case '2':
                    estado = Estado.SUSCETIVEL;
                break;

                case '3':
                    estado = Estado.IMUNE;
                break;
            }

            if(estado != null) {
                pessoas[mouseXGrid][mouseYGrid] = new Pessoa(estado);
                pessoas[mouseXGrid][mouseYGrid].posicaoTela = new PVector(mouseXGrid * tamanhoCelula, mouseYGrid * tamanhoCelula);
            }
        }
    }

    if(key == BACKSPACE) {
        pessoas = new Pessoa[tamanho][tamanho];
        proxId = 0;
    }
    if(key == TAB)
        posicaoPlacar = (4 + posicaoPlacar + 1) % 4;
    if(key == ' ')
        pausado = !pausado; 
}
