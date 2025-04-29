enum Estado {
    SUSCETIVEL, INFECTADO, IMUNE
};

public class Pessoa {
    int id;
    Estado estado = Estado.SUSCETIVEL;
    int tempoInfeccao = 0;
    int tempoRecuperacao = 0;
    int tempoAcao = 0;
    int pessoasInfectadas = 0;

    Pessoa(int id, Estado estado) {
        this.id = id;
        this.estado = estado;
        this.tempoRecuperacao = (int) random(300, 600);
        this.tempoAcao = (int) random(30, 180);
    }
}

int tamanho = 10;
Pessoa[][] pessoas = new Pessoa[tamanho][tamanho];

public void setup() {
    size(800, 600);

    pessoas[5][8] = new Pessoa(0, Estado.INFECTADO);
    pessoas[2][3] = new Pessoa(1, Estado.SUSCETIVEL);
    noStroke();
}

public void draw() {
    background(15, 34, 42);

    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if((i + j) % 2 == 0) {
                fill(25, 38, 52);
                rect(i * 50 + 2, j * 50 + 2, 48, 48, 10);
            }
            if(pessoas[i][j] != null) {
                if(pessoas[i][j].estado == Estado.SUSCETIVEL) {
                    fill(80, 255, 80);
                } else if(pessoas[i][j].estado == Estado.INFECTADO) {
                    fill(255, 80, 80);
                } else if(pessoas[i][j].estado == Estado.IMUNE) {
                    fill(80, 80, 255);
                }
                rect(i * 50 + 2, j * 50 + 2, 48, 48, 10);
                textAlign(RIGHT, BOTTOM);
                fill(255);
                text(""+pessoas[i][j].id, i * 50, j * 50, 46, 46);
            }
            textAlign(LEFT, TOP);
            fill(255);
            text(i + ", " + j, i * 50, j * 50);
        }
    }
}

public void simular() {
    println("Simulando...");
    Pessoa[][] pessoasNovo = new Pessoa[tamanho][tamanho];  
    for(int x = 0; x < tamanho; x++)
        for(int y = 0; y < tamanho; y++)
            pessoasNovo[x][y] = pessoas[x][y];

    for(int i = 0; i < tamanho; i++) {
        for(int j = 0; j < tamanho; j++) {
            if(pessoas[i][j] != null) {
                ArrayList<PVector> espacosLivres = new ArrayList<PVector>();
                for(int x = -1; x <= 1; x++) {
                    for(int y = -1; y <= 1; y++) {
                        if(x != 0 && y != 0 && x + i >= 0 && x + i < tamanho && y + j >= 0 && y + j < tamanho)
                            if(pessoasNovo[i + x][j + y] == null)
                                espacosLivres.add(new PVector(i + x, j + y));
                    }
                }

                int index = (int)random(espacosLivres.size());
                pessoasNovo[(int)espacosLivres.get(index).x][(int)espacosLivres.get(index).y] = pessoasNovo[i][j];
                pessoasNovo[i][j] = null;
                println("id: " + pessoasNovo[(int)espacosLivres.get(index).x][(int)espacosLivres.get(index).y].id + "\nposicao: " + (int)espacosLivres.get(index).x + ", " + (int)espacosLivres.get(index).y + "\nvizinhos: " + espacosLivres);
            }
        }
    }
    pessoas = pessoasNovo;
}

public void mouseReleased() {
    simular();
}