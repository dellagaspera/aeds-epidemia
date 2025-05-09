// Define as cores de cada estado
final color COLOR_INFECTADO = color(255, 80, 80);
final color COLOR_SUSCETIVEL = color(80, 255, 80);
final color COLOR_IMUNE = color(80, 80, 255);

// Tamanho do grid
final int tamanho = 24;

// Tamanho, na tela, de uma celula
final int tamanhoCelula = 32;


// O valor do próximo Id (da próxima pessoa)
static int proxId = 0;

// Chance de se contagiar e virar um infectado
final float chanceContagio = 0.5;

// VeloccicloAcaos de Interpolação
final float tempoInterpolacaoCor = 0.1f;
final float tempoInterpolacaoMovimento = 0.25f;
final float tempoInterpolacaoTamanho = 0.5f;

// VeloccicloAcao da Simulação (feito por diversão). 
// Note que é a quantcicloAcao de simulações por frame!
final int veloccicloAcaoTempo = 1; // não exagere :)

// Posição que o placar se encontra na tela (algum canto)
int posicaoPlacar = 0;

// Vetor que é responsável por armazenar as pessoas
Pessoa[][] pessoas = new Pessoa[tamanho][tamanho];

// Se a simulação está pausada ou não
boolean pausado = false;

// Posição do mouse na grade
int ultimaTrocaSelecao = 0;
int mouseXGrid = 0;
int mouseYGrid = 0;