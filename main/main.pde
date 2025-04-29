static enum Estado {
    SUSCETIVEL, INFECTADO, RECUPERADO;
}

class Pessoa {
    int id = 0;
    Estado estado = Estado.SUSCETIVEL;
    int tempoAcaoContador = 0;
    int tempoAcao = 60;
    int tempoInfectado = 0;
    int tempoParaRecuperar = 0;
    int quantosInfectou = 0;

    Pessoa(int id, Estado estado) {
        this.id = id;
        this.estado = estado;
        this.tempoAcao = (int)(random(30, 120));
        this.tempoParaRecuperar = (int)(random(300, 600));
    }

    void atualizar() {
        if(estado == Estado.INFECTADO) {
            tempoInfectado++;
            if(tempoInfectado >= tempoParaRecuperar) {
                estado = Estado.RECUPERADO;
            }
        } else if(estado == Estado.RECUPERADO) {
            // Recuperado não faz nada
        }
    }
}

int tamanho = 10;
Pessoa[][] pessoas = new Pessoa[tamanho][tamanho];
Pessoa[][] pessoasNovo = new Pessoa[tamanho][tamanho];

void setup() {
    size(800, 600);
    background(255);
    frameRate(1);
    pessoas[4][2] = new Pessoa(1, Estado.INFECTADO);
    pessoas[9][4] = new Pessoa(1, Estado.SUSCETIVEL);
}

void draw() {
    background(43, 40, 70);
    pessoasNovo = pessoas;
    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoasNovo[i][j] != null) {
                pessoasNovo[i][j].atualizar();
                
                fill(0, 0, 255); // Cor azul para suscetível
                if(pessoasNovo[i][j].estado == Estado.INFECTADO) {
                    fill(255, 0, 0); // Cor vermelha para infectado
                } else if(pessoasNovo[i][j].estado == Estado.RECUPERADO) {
                    fill(0, 255, 0); // Cor verde para recuperado
                }
                ellipse(i * width / tamanho, j * height / tamanho, width / tamanho, height / tamanho);

                ArrayList<PVector> espacosLivres = new ArrayList<PVector>();
                for(int x = -1; x <= 1; x++) {
                    for(int y = -1; y <= 1; y++) {
                        if(x == 0 && y == 0) continue;
                        int x_ = i + x;
                        int y_ = j + y;
                        if(x_ >= 0 && x_ < tamanho && y_ >= 0 && y_ < tamanho && pessoasNovo[x_][y_] == null) {
                            espacosLivres.add(new PVector(x_, y_));
                        }
                    }
                }

                if(espacosLivres.size() > 0) {
                    int posicaoAleatoria = (int)random(espacosLivres.size());
                    pessoasNovo[(int)espacosLivres.get(posicaoAleatoria).x][(int)espacosLivres.get(posicaoAleatoria).y] = pessoasNovo[i][j];
                    pessoasNovo[i][j] = null;
                }
            }
        }
    }
    pessoas = pessoasNovo;
}