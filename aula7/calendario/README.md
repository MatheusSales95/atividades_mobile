# calendario

App Flutter para Android que consulta o calendário do dispositivo e lista os compromissos de hoje e dos próximos seis dias (7 dias no total), usando o pacote `device_calendar`.

## Como executar

Requer Flutter 3.47.9 ou mais recente. Com um celular Android conectado (ou um emulador):

```
flutter run
```

## Como usar

1. Tenha compromissos cadastrados na agenda do aparelho (por exemplo, no app Google Agenda).
2. Toque em **Consultar compromissos**.
3. Na primeira vez, o Android pede acesso à agenda: toque em **Permitir**.
4. O app busca os eventos de todos os calendários do aparelho e mostra a lista em ordem cronológica, com título, calendário, início, fim, local e descrição. Compromissos que ocupam o dia inteiro aparecem com a marcação **Dia inteiro** e mostram só a data.

Durante a consulta, aparece um indicador de carregamento. O app avisa quando:

- não há compromissos no período;
- o acesso à agenda foi negado;
- ocorreu uma falha na consulta.

Se o acesso tiver sido negado definitivamente, libere-o em Configurações > Apps > calendario > Permissões > Agenda e consulte de novo.

## Permissões

Declaradas em `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.READ_CALENDAR" />
<uses-permission android:name="android.permission.WRITE_CALENDAR" />
```

O app só lê a agenda, mas o `device_calendar` só considera o acesso concedido quando as duas permissões foram liberadas.
