import 'dart:io';
import 'dart:math';

enum Jogada { pedra, papel, tesoura }

void main() {
  bool executar = true;

  do {
    print('\n==================================================');
    print('   SISTEMA INTEGRADO DE EXERCÍCIOS - DART         ');
    print('==================================================');
    print('1. [Jogo 1] Adivinhe o Número (Conceitos: Variáveis e Laços)');
    print(
      '2. [Jogo 2] Jokenpô / Pedra, Papel e Tesoura (Conceitos: Condicionais)',
    );
    print('0. Sair do Sistema');
    print('==================================================');
    stdout.write('Escolha uma opção (0-2): ');

    final entrada = stdin.readLineSync();

    switch (entrada) {
      case '1':
        adivinhe();
      case '2':
        jokenpo();
      case '0':
        print('\nEncerrando a aplicação... Até logo!');
        executar = false;
      default:
        print('\n[ERRO] Opção inválida! Digite um número de 0 a 2.');
    }

    if (executar) {
      print('\nPressione ENTER para voltar ao menu principal...');
      stdin.readLineSync();
    }
  } while (executar);
}

/// Lê e valida um palpite entre 1 e 100.
///
/// Entradas que não forem números inteiros ou que estiverem fora do intervalo
/// não são devolvidas ao jogo e, portanto, não consomem uma tentativa.
int obterPalpiteValido() {
  while (true) {
    stdout.write('Digite seu palpite: ');
    final entrada = stdin.readLineSync()?.trim();
    final palpite = int.tryParse(entrada ?? '');

    if (palpite == null) {
      print('Por favor, digite um número inteiro válido!');
      continue;
    }

    if (palpite < 1 || palpite > 100) {
      print('O palpite deve estar entre 1 e 100. Tente novamente!');
      continue;
    }

    return palpite;
  }
}

void adivinhe() {
  const maxTentativas = 7;
  final numeroSecreto = Random().nextInt(100) + 1;
  var tentativas = 0;

  print('\n=== BEM-VINDO AO JOGO DE ADIVINHAÇÃO ===');
  print('Tente adivinhar o número entre 1 e 100!');
  print('Modo difícil: você tem no máximo $maxTentativas tentativas.');

  while (tentativas < maxTentativas) {
    final palpite = obterPalpiteValido();
    tentativas++;

    if (palpite == numeroSecreto) {
      print('\nParabéns! Você acertou em $tentativas tentativa(s).');
      return;
    }

    if (tentativas < maxTentativas) {
      if (palpite < numeroSecreto) {
        print('Muito baixo! Tente um número maior.');
      } else {
        print('Muito alto! Tente um número menor.');
      }

      final restantes = maxTentativas - tentativas;
      print('Tentativas restantes: $restantes');
    }
  }

  print('\nFim de Jogo');
  print('Você utilizou as $maxTentativas tentativas.');
  print('O número correto era $numeroSecreto.');
}

Jogada? converterJogada(String? entrada) {
  switch (entrada?.toLowerCase().trim()) {
    case 'pedra':
      return Jogada.pedra;
    case 'papel':
      return Jogada.papel;
    case 'tesoura':
      return Jogada.tesoura;
    default:
      return null;
  }
}

bool jogadorVence(Jogada jogador, Jogada computador) {
  return (jogador == Jogada.pedra && computador == Jogada.tesoura) ||
      (jogador == Jogada.papel && computador == Jogada.pedra) ||
      (jogador == Jogada.tesoura && computador == Jogada.papel);
}

void exibirPlacar(int vitoriasJogador, int vitoriasComputador) {
  print('Placar: Jogador $vitoriasJogador x $vitoriasComputador Computador');
}

void jokenpo() {
  const vitoriasParaGanhar = 3;
  final random = Random();
  var vitoriasJogador = 0;
  var vitoriasComputador = 0;

  print('\n=== BEM-VINDO AO JOKENPÔ ===');
  print('Opções válidas: pedra, papel ou tesoura.');
  print('Vence a partida quem alcançar $vitoriasParaGanhar vitórias primeiro.');

  while (vitoriasJogador < vitoriasParaGanhar &&
      vitoriasComputador < vitoriasParaGanhar) {
    stdout.write('\nEscolha sua jogada (ou digite "sair"): ');
    final entrada = stdin.readLineSync()?.toLowerCase().trim();

    if (entrada == 'sair') {
      print('\nPartida encerrada pelo jogador.');
      exibirPlacar(vitoriasJogador, vitoriasComputador);
      print('Obrigado por jogar!');
      return;
    }

    final jogadaJogador = converterJogada(entrada);

    if (jogadaJogador == null) {
      print('Jogada inválida! Escolha apenas pedra, papel ou tesoura.');
      continue;
    }

    final jogadaComputador =
        Jogada.values[random.nextInt(Jogada.values.length)];

    print('Você escolheu: ${jogadaJogador.name}');
    print('O computador escolheu: ${jogadaComputador.name}');

    if (jogadaJogador == jogadaComputador) {
      print('Empate!');
    } else if (jogadorVence(jogadaJogador, jogadaComputador)) {
      vitoriasJogador++;
      print('Você ganhou a rodada!');
    } else {
      vitoriasComputador++;
      print('O computador ganhou a rodada!');
    }

    exibirPlacar(vitoriasJogador, vitoriasComputador);
  }

  print('\n=== FIM DA PARTIDA ===');
  if (vitoriasJogador == vitoriasParaGanhar) {
    print('Parabéns! Você venceu a partida!');
  } else {
    print('O computador venceu a partida!');
  }
  exibirPlacar(vitoriasJogador, vitoriasComputador);
}
