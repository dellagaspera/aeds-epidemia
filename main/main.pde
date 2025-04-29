enum Estado {
    SUSCETIVEL, INFECTADO, IMUNE
};

public class Pessoa {
    int id;
    Estado estado = Estado.SUSCETIVEL;
    int tempoInfeccao = 0;
    int tempoRecuperacao = 0;
    int pessoasInfectadas = 0;
    int tempoAcao = 0;
    int idade = 0;
    PVector posicaoTela = new PVector(-tamanhoCelula, -tamanhoCelula);

    Pessoa(Estado estado) {
        this.id = proxId;
        proxId++;
        this.estado = estado;
        this.tempoRecuperacao = (int) random(1500, 3000);
        this.tempoAcao = (int) random(30, 180);
    }
}

static int proxId = 0;
int tamanho = 16;
int tamanhoCelula = 50;
float chanceContagio = 0.5;
Pessoa[][] pessoas = new Pessoa[tamanho][tamanho];

public void setup() {
    noStroke();
    textSize(tamanhoCelula * 0.25);
}

void settings() {
    size(tamanho * tamanhoCelula, tamanho * tamanhoCelula);
}

public void draw() {
    simular();

    desenhaFundo();
    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoas[i][j] != null) {
                if(pessoas[i][j].estado == Estado.SUSCETIVEL) {
                    fill(80, 255, 80);
                } else if(pessoas[i][j].estado == Estado.INFECTADO) {
                    fill(255, 80, 80);
                } else if(pessoas[i][j].estado == Estado.IMUNE) {
                    fill(80, 80, 255);
                }
                PVector posicaoReal = new PVector(i * tamanhoCelula + 2, j * tamanhoCelula + 2);
                pessoas[i][j].posicaoTela.lerp(posicaoReal, 0.5);
                rect(pessoas[i][j].posicaoTela.x, pessoas[i][j].posicaoTela.y, tamanhoCelula - 2, tamanhoCelula - 2, tamanhoCelula / 3);
                textAlign(CENTER, CENTER);
                fill(255);
                textSize(tamanhoCelula * 0.4);
                text(str(pessoas[i][j].id), pessoas[i][j].posicaoTela.x, pessoas[i][j].posicaoTela.y, tamanhoCelula - 4, tamanhoCelula - 4);
            }
        }
    }

    desenhaPlacar();
}

public void desenhaFundo() {
    background(15, 34, 42);
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++)
            if((i + j) % 2 == 0) {
                fill(20, 41, 52);
                rect(i * tamanhoCelula, j * tamanhoCelula, tamanhoCelula, tamanhoCelula, 10);
            }
}

public void desenhaPlacar() {
    textSize(20);
    Pessoa[] todos = new Pessoa[0];
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++)
            if(pessoas[i][j] != null) todos = (Pessoa[])append(todos, pessoas[i][j]);
    if(todos.length == 0) return;

    int nTop;
    nTop = min(todos.length, 5);
    PVector tamanhoPlacar = new PVector(240, 24 + 32 * nTop);
    todos = mergeSort(todos);
    
    Pessoa[] top5 = new Pessoa[5];
    for(int i = 0; i < 5; i++) {
        if(todos.length - i - 1 >= 0) top5[i] = todos[todos.length - i - 1];
    }

    fill(15, 34, 42, 220);
    stroke(255);
    rect(4, 4, tamanhoPlacar.x, tamanhoPlacar.y, 8);
    noStroke();
    fill(255);
    textAlign(LEFT, CENTER);
    text("ID", 8, 8, tamanhoPlacar.x - 8, tamanhoPlacar.y / (nTop + 1) - 4);
    textAlign(RIGHT, CENTER);
    text("Pessoas Infectadas", 8, 8, tamanhoPlacar.x - 8, tamanhoPlacar.y / (nTop + 1) - 4);
    for(int i = 0; i < nTop; i++) {
        textAlign(LEFT, CENTER);
        text(str(top5[i].id), 8, 32 + i * tamanhoPlacar.y / (nTop + 1) - 4, tamanhoPlacar.x - 8, tamanhoPlacar.y / (nTop + 1) - 4);
        textAlign(RIGHT, CENTER);
        text(str(top5[i].pessoasInfectadas), 8, 32 + i * tamanhoPlacar.y / (nTop + 1) - 4, tamanhoPlacar.x - 8, tamanhoPlacar.y / (nTop + 1) - 4);
    }
}

public Pessoa[] mergeSort(Pessoa[] array) {
  if (array.length <= 1) return array;

  int meio = array.length / 2;

  Pessoa[] subArray1 = mergeSort((Pessoa[])subset(array, 0, meio));
  Pessoa[] subArray2 = mergeSort((Pessoa[])subset(array, meio));

  Pessoa[] arrayOrdenado = new Pessoa[array.length];
  int i = 0, j = 0, k = 0;

  while (i < subArray1.length && j < subArray2.length) {
    if (subArray1[i].pessoasInfectadas <= subArray2[j].pessoasInfectadas) {
      arrayOrdenado[k++] = subArray1[i++];
    } else {
      arrayOrdenado[k++] = subArray2[j++];
    }
  }

  while (i < subArray1.length) arrayOrdenado[k++] = subArray1[i++];
  while (j < subArray2.length) arrayOrdenado[k++] = subArray2[j++];

  return arrayOrdenado;
}


public void simular() {
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
                ArrayList<PVector> adjacentesLivres = new ArrayList<PVector>();
                ArrayList<PVector> adjacentesOcupados = new ArrayList<PVector>();
                for(int x = -1; x <= 1; x++) {
                    for(int y = -1; y <= 1; y++) {
                        if((x != 0 || y != 0) && x + i >= 0 && x + i < tamanho && y + j >= 0 && y + j < tamanho)
                            if(pessoasNovo[i + x][j + y] == null)
                                adjacentesLivres.add(new PVector(i + x, j + y));
                            else
                                adjacentesOcupados.add(new PVector(i + x, j + y));
                    }
                }

                if(pessoasNovo[i][j].estado == Estado.INFECTADO && adjacentesOcupados.size() > 0) {
                    for(PVector posicao : adjacentesOcupados) {
                        if(random(1) < chanceContagio && pessoasNovo[(int)posicao.x][(int)posicao.y].estado == Estado.SUSCETIVEL) {
                            pessoasNovo[i][j].pessoasInfectadas++;
                            pessoasNovo[(int)posicao.x][(int)posicao.y].estado = Estado.INFECTADO;
                        }
                    }
                }

                if(adjacentesLivres.size() > 0) {
                    int index = (int)random(adjacentesLivres.size());
                    int x = (int)adjacentesLivres.get(index).x;
                    int y = (int)adjacentesLivres.get(index).y;
                    pessoasNovo[x][y] = pessoas[i][j];
                    pessoasNovo[i][j] = null;
                }
            }
        }
    }
    pessoas = pessoasNovo;
}

public void mouseReleased() {
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
        }
    }
}