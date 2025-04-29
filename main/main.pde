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
        this.tempoRecuperacao = (int) random(3000, 6000);
        this.tempoAcao = (int) random(30, 180);
    }
}

static int proxId = 0;
int tamanho = 24;
int tamanhoCelula = 48;
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
                textAlign(RIGHT, BOTTOM);
                fill(255);
                text(""+pessoas[i][j].id, pessoas[i][j].posicaoTela.x, pessoas[i][j].posicaoTela.y, tamanhoCelula - 4, tamanhoCelula - 4);
            }
            textAlign(LEFT, TOP);
            fill(255);
            text(i + ", " + j, i * tamanhoCelula, j * tamanhoCelula);
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
    int[] todos = new int[0];
    for(int i = 0; i < tamanho; i++)
        for(int j = 0; j < tamanho; j++)
            if(pessoas[i][j] != null) todos = append(todos, pessoas[i][j].pessoasInfectadas);
    if(todos.length == 0) return;

    int nTop;
    nTop = min(todos.length, 5);
    PVector tamanhoPlacar = new PVector(120, 24 * nTop);
    todos = mergeSort(todos);
    
    int[] top5 = new int[5];
    for(int i = 0; i < 5; i++) {
        if(todos.length - i - 1 >= 0) top5[i] = todos[todos.length - i - 1];
    }

    fill(15, 34, 42, 180);
    rect(4, 4, tamanhoPlacar.x, tamanhoPlacar.y, 8);
    fill(255);
    for(int i = 0; i < nTop; i++) {
        textAlign(LEFT, TOP);
        text(nf(top5[i]), 8, 8 + i * 24);
    }
}

public int[] mergeSort(int[] array) {
  if (array.length <= 1) return array;

  int meio = array.length / 2;

  int[] subArray1 = mergeSort(subset(array, 0, meio));
  int[] subArray2 = mergeSort(subset(array, meio));

  int[] arrayOrdenado = new int[array.length];
  int i = 0, j = 0, k = 0;

  while (i < subArray1.length && j < subArray2.length) {
    arrayOrdenado[k++] = (subArray1[i] <= subArray2[j]) ? subArray1[i++] : subArray2[j++];
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
                        if(x != 0 && y != 0 && x + i >= 0 && x + i < tamanho && y + j >= 0 && y + j < tamanho)
                            if(pessoasNovo[i + x][j + y] == null)
                                adjacentesLivres.add(new PVector(i + x, j + y));
                            else
                                adjacentesOcupados.add(new PVector(i + x, j + y));
                    }
                }

                int x = i;
                int y = j;
                if(adjacentesLivres.size() > 0) {
                    int index = (int)random(adjacentesLivres.size());
                    x = (int)adjacentesLivres.get(index).x;
                    y = (int)adjacentesLivres.get(index).y;
                    pessoasNovo[x][y] = pessoas[i][j];
                    pessoasNovo[i][j] = null;
                }

                if(pessoasNovo[x][y].estado == Estado.INFECTADO && adjacentesOcupados.size() > 0) {
                    for(PVector posicao : adjacentesOcupados) {
                        if(random(1) < chanceContagio && pessoasNovo[(int)posicao.x][(int)posicao.y].estado == Estado.SUSCETIVEL) {
                            pessoasNovo[x][y].pessoasInfectadas++;
                            pessoasNovo[(int)posicao.x][(int)posicao.y].estado = Estado.INFECTADO;
                        }
                    }
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

    println("tabX: " + tabX);
    println("tabY: " + tabY);
}