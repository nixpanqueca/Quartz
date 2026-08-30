// Shared Aether service ABI definitions.
// Incluido tanto pelo kernel (kernel\svc.pas) quanto pelos programas
// (programs\common\svcapi.pas) para manter o layout da tabela de servicos
// em sincronia.

// Endereco fixo da tabela de servicos preenchida pelo kernel no boot.
const
  SERVICE_TABLE_ADDR = $00060000;

  // Endereco fixo onde os binarios de programas sao carregados e executados.
  PROGRAM_BASE = $00100000;
  PROGRAM_MAX  = $80000;   // 128 KB de espaco por programa

  // Indices da tabela de servicos (cada entrada e um LongWord/ponteiro).
  SVC_MAGIC       = 0;
  SVC_CLEARSCREEN = 1;
  SVC_WRITEAT     = 2;
  SVC_WRITEATCOL  = 3;
  SVC_FILLRECT    = 4;
  SVC_PUTPIXEL    = 5;
  SVC_DRAWLINE    = 6;
  SVC_DELAYMS     = 7;
  SVC_SERIALSTR   = 8;
  SVC_SERIALCHAR  = 9;
  SVC_KEYPOLL     = 10;
  SVC_ANYKEY      = 11;
  SVC_KEYPRESSED  = 12;
  SVC_FSREAD      = 13;
  SVC_DRAWBMP     = 14;
  SVC_MOUSEX      = 15;
  SVC_MOUSEY      = 16;

  // Janelas (Prism WindowManager, kernel\windows.pas).
  SVC_WINCREATE   = 17;   // WinCreate(Title, X, Y, W, H): Integer (0 = falhou)
  SVC_WINPOLL     = 18;   // WinPoll: Integer (evento da janela)
  SVC_WINDESTROY  = 19;   // WinDestroy
  SVC_WINKEY      = 20;   // WinKey: Char (ultima tecla do programa)

  // Eventos retornados por SVC_WINPOLL.
  WINEV_NONE = 0;   // nada novo; segue o jogo
  WINEV_CLOSE = 1;  // botao fechar foi clicado (encerre a janela)

  SERVICE_TABLE_MAGIC = $31564353;   // 'SVC1'
