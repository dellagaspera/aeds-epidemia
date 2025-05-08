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
        this.id = proxId++;
        this.estado = estado;
        this.tempoRecuperacao = (int) (random(1500, 6000) / velocidadeTempo);
        this.tempoAcao = (int) (random(30, 180) / velocidadeTempo);
        if(estado == Estado.SUSCETIVEL) {
            col = COLOR_SUSCETIVEL;
        } else if(estado == Estado.INFECTADO) {
            col = COLOR_INFECTADO;
        } else if(estado == Estado.IMUNE) {
            col = COLOR_IMUNE;
        }
    }
} 