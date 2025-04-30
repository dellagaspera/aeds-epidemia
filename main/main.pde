enum Estado {
    SUSCETIVEL, INFECTADO, IMUNE
};

public class Pessoa {
    int id = 0;
    Estado estado = Estado.SUSCETIVEL;
    int tempoInfeccao = 0;
    int tempoRecuperacao = 0;
    int pessoasInfectadas = 0;
    int tempoAcao = 0;
    int idade = 0;
    PVector posicaoTela = new PVector(-tamanhoCelula, -tamanhoCelula);
    float tamanho = 0;
    color col = COLOR_IMUNE;

    Pessoa(Estado estado) {
        this.id = proxId;
        proxId++;
        this.estado = estado;
        this.tempoRecuperacao = (int) random(1500, 6000);
        this.tempoAcao = (int) random(30, 180);
        if(estado == Estado.SUSCETIVEL) {
            col = COLOR_SUSCETIVEL;
        } else if(estado == Estado.INFECTADO) {
            col = COLOR_INFECTADO;
        } else if(estado == Estado.IMUNE) {
            col = COLOR_IMUNE;
        }
    }
}

final color COLOR_INFECTADO = color(255, 80, 80);
final color COLOR_SUSCETIVEL = color(80, 255, 80);
final color COLOR_IMUNE = color(80, 80, 255);

static int proxId = 0;
int tamanho = 24;
int tamanhoCelula = 32;
float chanceContagio = 0.5;
int posicaoPlacar = 0;
Pessoa[][] pessoas = new Pessoa[tamanho][tamanho];
boolean pausado = false;

void setup() {
    noStroke();
    textSize(tamanhoCelula * 0.25);
}

void settings() {
    size(tamanho * tamanhoCelula, tamanho * tamanhoCelula);
}

void draw() {
    if(!pausado) simular();

    desenhaFundo();
    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoas[i][j] != null) {
                if(pessoas[i][j].estado == Estado.SUSCETIVEL) {
                    pessoas[i][j].col = lerpColor(pessoas[i][j].col, COLOR_SUSCETIVEL, 0.1);
                } else if(pessoas[i][j].estado == Estado.INFECTADO) {
                    pessoas[i][j].col = lerpColor(pessoas[i][j].col, COLOR_INFECTADO, 0.1);
                } else if(pessoas[i][j].estado == Estado.IMUNE) {
                    pessoas[i][j].col = lerpColor(pessoas[i][j].col, COLOR_IMUNE, 0.1);
                }
                PVector posicaoReal = new PVector(i * tamanhoCelula, j * tamanhoCelula);
                pessoas[i][j].posicaoTela.lerp(posicaoReal, 0.5);
                pessoas[i][j].tamanho = lerp(pessoas[i][j].tamanho, tamanhoCelula * 0.8, 0.5);
                fill(pessoas[i][j].col);
                rect(pessoas[i][j].posicaoTela.x + (tamanhoCelula - pessoas[i][j].tamanho) / 2, pessoas[i][j].posicaoTela.y + (tamanhoCelula - pessoas[i][j].tamanho) / 2, pessoas[i][j].tamanho, pessoas[i][j].tamanho, tamanhoCelula / 3);
                textAlign(CENTER, CENTER);
                fill(255);
                textSize(tamanhoCelula * 0.4);
                text(str(pessoas[i][j].id), pessoas[i][j].posicaoTela.x + (tamanhoCelula - pessoas[i][j].tamanho) / 2, pessoas[i][j].posicaoTela.y + (tamanhoCelula - pessoas[i][j].tamanho) / 2, pessoas[i][j].tamanho, pessoas[i][j].tamanho);
            }
        }
    }

    desenhaPlacar();
}
 
void desenhaFundo() {
    background(15, 34, 42);
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++)
            if((i + j) % 2 == 0) {
                fill(20, 41, 52);
                rect(i * tamanhoCelula, j * tamanhoCelula, tamanhoCelula, tamanhoCelula, 10);
            }
}

void desenhaPlacar() {
    textSize(16);
    Pessoa[] todos = new Pessoa[0];
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++)
            if(pessoas[i][j] != null) todos = (Pessoa[])append(todos, pessoas[i][j]);
    if(todos.length == 0) return;

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
    todos = mergeSort(todos);
    
    Pessoa[] top5 = new Pessoa[5];
    for(int i = 0; i < 5; i++) {
        if(todos.length - i - 1 >= 0) top5[i] = todos[todos.length - i - 1];
    }

    fill(15, 34, 42, 220);
    stroke(255);
    rect(posPlacar.x, posPlacar.y, tamanhoPlacar.x, tamanhoPlacar.y, 8);
    noStroke();
    fill(255);
    textAlign(LEFT, CENTER);
    text("ID", posPlacar.x + 4, posPlacar.y + 4, tamanhoPlacar.x - 8, (tamanhoPlacar.y - 8) / (nTop + 1) - 8);
    textAlign(RIGHT, CENTER);
    text("Infectados", posPlacar.x + 4, posPlacar.y + 4, tamanhoPlacar.x - 8, (tamanhoPlacar.y - 8) / (nTop + 1) - 8);
    for(int i = 0; i < nTop; i++) {
        textAlign(LEFT, CENTER);
        text(str(top5[i].id), posPlacar.x + 4, posPlacar.y + 4 + (i + 1) * (tamanhoPlacar.y - 0) / (nTop + 1), tamanhoPlacar.x - 8, (tamanhoPlacar.y - 8) / (nTop + 1) - 8);
        textAlign(RIGHT, CENTER);
        text(str(top5[i].pessoasInfectadas), posPlacar.x + 4, posPlacar.y + 4 + (i + 1) * (tamanhoPlacar.y - 0) / (nTop + 1), tamanhoPlacar.x - 8, (tamanhoPlacar.y - 8) / (nTop + 1) - 8);
    }
}

Pessoa[] mergeSort(Pessoa[] array) {
    if(array.length <= 1) return array;

    int meio = array.length / 2;

    Pessoa[] subArray1 = mergeSort((Pessoa[])subset(array, 0, meio));
    Pessoa[] subArray2 = mergeSort((Pessoa[])subset(array, meio));

    Pessoa[] arrayOrdenado = new Pessoa[array.length];
    int i = 0, j = 0, k = 0;

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

    return arrayOrdenado;
}

void simular() {
    Pessoa[][] pessoasNovo = new Pessoa[tamanho][tamanho];  
    for(int x = 0; x < tamanho; x++) {
        for(int y = 0; y < tamanho; y++) {

            if(pessoas[x][y] != null) {
                pessoas[x][y].idade++;
                if(pessoas[x][y].estado == Estado.INFECTADO) {
                    pessoas[x][y].tempoInfeccao++;
                    if(pessoas[x][y].tempoInfeccao >= pessoas[x][y].tempoRecuperacao) pessoas[x][y].estado = Estado.IMUNE;
                }
            }
            pessoasNovo[x][y] = pessoas[x][y];
        }
    }

    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoas[i][j] != null && pessoas[i][j].idade % pessoas[i][j].tempoAcao == 0) {
                pessoas[i][j].idade = 0;
                PVector[] adjacentes = new PVector[0];
                for(int x = -1; x <= 1; x++) {
                    for(int y = -1; y <= 1; y++) {
                        if((x != 0 || y != 0) && x + i >= 0 && x + i < tamanho && y + j >= 0 && y + j < tamanho) {
                            adjacentes = (PVector[])append(adjacentes, new PVector(i + x, j + y));
                        }
                    }
                }

                int index = (int)random(8);
                if(index < adjacentes.length) {
                    int x = (int)adjacentes[index].x;
                    int y = (int)adjacentes[index].y;
                    if(pessoasNovo[x][y] == null) {
                        pessoasNovo[i][j] = null;
                        pessoasNovo[x][y] = pessoas[i][j];
                    }
                }
            }
        }
    }

    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++) {
            if(pessoasNovo[i][j] != null)
                if(pessoasNovo[i][j].estado == Estado.INFECTADO && pessoasNovo[i][j].idade == 0) {
                    ArrayList<PVector> infectaveis = new ArrayList<PVector>();
                    for(int x = -1; x <= 1; x++)
                        for(int y = -1; y <= 1; y++)
                            if((x != 0 || y != 0) && x + i >= 0 && x + i < tamanho && y + j >= 0 && y + j < tamanho)
                                if(pessoasNovo[i + x][j + y] != null)
                                    if(pessoasNovo[i + x][j + y].estado == Estado.SUSCETIVEL) 
                                        infectaveis.add(new PVector(i + x, j + y));    

                    
                    if(infectaveis.size() > 0) {
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

    pessoas = pessoasNovo;
}

void mouseReleased() {
    int tabX = mouseX / tamanhoCelula;
    int tabY = mouseY / tamanhoCelula;

    if(tabX >= 0 && tabX < tamanho && tabY >= 0 && tabY < tamanho) {
        if(pessoas[tabX][tabY] == null) {
            Estado estado = null;
            switch(mouseButton) {
                case LEFT:
                    estado = Estado.INFECTADO;
                break;

                case RIGHT:
                    estado = Estado.SUSCETIVEL;
            }

            if(estado != null) pessoas[tabX][tabY] = new Pessoa(estado);
            pessoas[tabX][tabY].posicaoTela = new PVector(tabX * tamanhoCelula, tabY * tamanhoCelula);
        }
    }
}

void keyTyped() {
    int tabX = mouseX / tamanhoCelula;
    int tabY = mouseY / tamanhoCelula;

    if(tabX >= 0 && tabX < tamanho && tabY >= 0 && tabY < tamanho) {
        if(pessoas[tabX][tabY] == null) {
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
                pessoas[tabX][tabY] = new Pessoa(estado);
                pessoas[tabX][tabY].posicaoTela = new PVector(tabX * tamanhoCelula, tabY * tamanhoCelula);
            }
        }
    }

    if(key == BACKSPACE)
        pessoas = new Pessoa[tamanho][tamanho];
    if(key == TAB)
        posicaoPlacar = (4 + posicaoPlacar + 1) % 4;
    if(key == ' ')
        pausado = !pausado;
}
