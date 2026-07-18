/// App Store スクリーンショットのキャッチコピー定義。
///
/// タイトル・サブタイトルを言語（arb 言語コード）×ページ番号で引く。
/// コピー案は競合調査（tmp/research/report.md 5-A）の 5 枚構成に対応する。
/// ja / en と ASC 対象の全言語を定義し、未定義の言語は en にフォールバックする。
/// 言語を追加するときは [_copies] に 1 言語分の Map を追記するだけで済む。
class ScreenshotCopy {
  const ScreenshotCopy({
    required this.title,
    required this.subtitle,
    this.titleAccentWord,
  });

  /// 太字・大きく表示するタイトル。明示改行（\n）を含めてよい。
  final String title;

  /// タイトル下に表示する補足文。
  final String subtitle;

  /// タイトル内でアクセント色にする単語。[title] に含まれる場合のみ着色する。
  /// null の場合はタイトル全体を白で表示する。
  final String? titleAccentWord;

  /// 指定言語・ページのコピーを返す。
  ///
  /// 対象言語に定義が無ければ en、en にも無ければ p1 のコピーへフォールバックする。
  static ScreenshotCopy of({required String lang, required int page}) {
    return _copies[lang]?[page] ?? _copies['en']?[page] ?? _copies['en']![1]!;
  }

  /// 言語コード→ページ番号→コピーの対応表。
  ///
  /// 5-A の 5 枚構成:
  /// 1 社会的証明＋中核価値 / 2 ピルシート UI / 3 伏せた通知 /
  /// 4 複数回リマインド / 5 生理管理。
  static const Map<String, Map<int, ScreenshotCopy>> _copies = {
    'ja': {
      1: ScreenshotCopy(
        title: '14万人が使う\n飲み忘れ防止アプリ',
        subtitle: '毎日の服用時刻に通知。App Store ★4.6 の安心。',
        titleAccentWord: '14万人',
      ),
      2: ScreenshotCopy(
        title: 'もう、飲んだか\n不安にならない',
        subtitle: 'ピルシートをそのまま画面に再現。',
        titleAccentWord: '不安にならない',
      ),
      3: ScreenshotCopy(
        title: '伏せた通知だから、\n誰にも気づかれない',
        subtitle: 'ロック画面に出ても、中身はわからない。',
        titleAccentWord: '伏せた通知',
      ),
      4: ScreenshotCopy(
        title: '飲み忘れても大丈夫。\n通知は何度も届く',
        subtitle: '服用するまで、くり返しお知らせします。',
        titleAccentWord: '何度も',
      ),
      5: ScreenshotCopy(
        title: 'ピルも生理も、\nこれひとつで管理',
        subtitle: '生理を記録すると、次の予定を自動で予測。',
        titleAccentWord: 'これひとつ',
      ),
    },
    'en': {
      1: ScreenshotCopy(
        title: 'Trusted by 140K+ users\nNever miss your pill',
        subtitle: 'A reminder at every dose time. Rated 4.6★ on the App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Never wonder if you\nalready took it',
        subtitle: 'Your pill pack on screen. See your progress at a glance.',
        titleAccentWord: 'Never wonder',
      ),
      3: ScreenshotCopy(
        title: 'Discreet reminders,\nno one sees what it\'s for',
        subtitle: 'Even on the lock screen, it stays private.',
        titleAccentWord: 'Discreet',
      ),
      4: ScreenshotCopy(
        title: 'Missed it?\nWe\'ll remind you again',
        subtitle: 'Reminders repeat until you take your pill.',
        titleAccentWord: 'again',
      ),
      5: ScreenshotCopy(
        title: 'Your pill and your period,\nall in one',
        subtitle: 'Log your period and the next date is predicted.',
        titleAccentWord: 'all in one',
      ),
    },
    'ar': {
      1: ScreenshotCopy(
        title: '+140 ألف مستخدمة\nلن تفوّتي حبتك مجدداً',
        subtitle: 'تذكير عند كل موعد جرعة، وتقييم 4.6★ في App Store',
        titleAccentWord: '140 ألف',
      ),
      2: ScreenshotCopy(
        title: 'لن تتساءلي بعد اليوم\nهل تناولتِ حبتك؟',
        subtitle: 'شريط حبوبك يظهر كما هو على الشاشة',
        titleAccentWord: 'لن تتساءلي',
      ),
      3: ScreenshotCopy(
        title: 'إشعارات سرّية تماماً\nلن يلاحظها أحد',
        subtitle: 'حتى في شاشة القفل، يبقى المحتوى خاصاً',
        titleAccentWord: 'سرّية',
      ),
      4: ScreenshotCopy(
        title: 'نسيتِ حبتك؟ لا مشكلة\nسنذكّرك مراراً وتكراراً',
        subtitle: 'سيتكرر التذكير حتى تتناولي حبتك',
        titleAccentWord: 'مراراً وتكراراً',
      ),
      5: ScreenshotCopy(
        title: 'حبوبك ودورتك الشهرية\nكلاهما في تطبيق واحد',
        subtitle: 'سجّلي دورتك، ويُتوقَّع موعدها القادم تلقائياً',
        titleAccentWord: 'تطبيق واحد',
      ),
    },
    'ca': {
      1: ScreenshotCopy(
        title: '140K+ usuàries\nno obliden la píndola',
        subtitle: 'Recordatori a cada presa. 4,6★ a l\'App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'No et preguntis mai\nsi ja l\'has presa',
        subtitle: 'El teu blister, tal com és, a la pantalla.',
        titleAccentWord: 'No et preguntis mai',
      ),
      3: ScreenshotCopy(
        title: 'Avisos discrets,\nningú sap de què són',
        subtitle: 'Encara que surti a la pantalla de bloqueig, és privat.',
        titleAccentWord: 'Avisos discrets',
      ),
      4: ScreenshotCopy(
        title: 'T\'has oblidat?\nT\'ho recordarem de nou',
        subtitle: 'Els avisos es repeteixen fins que prens la píndola.',
        titleAccentWord: 'de nou',
      ),
      5: ScreenshotCopy(
        title: 'La píndola i el període,\ntot en un',
        subtitle: 'Registra el període i predim la propera data.',
        titleAccentWord: 'tot en un',
      ),
    },
    'cs': {
      1: ScreenshotCopy(
        title: 'Důvěřuje jí 140K+ lidí\nUž nikdy nezapomenete',
        subtitle: 'Upozornění na každou dávku. Hodnocení ★4,6 na App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Už nemusíte řešit,\njestli jste ji vzala',
        subtitle: 'Váš blistr pilulek přesně na obrazovce telefonu.',
        titleAccentWord: 'Už nemusíte řešit',
      ),
      3: ScreenshotCopy(
        title: 'Diskrétní upozornění,\nnikdo nic nepozná',
        subtitle: 'I na uzamčené obrazovce zůstává obsah skrytý.',
        titleAccentWord: 'Diskrétní',
      ),
      4: ScreenshotCopy(
        title: 'Zapomněli jste?\nPřipomeneme to znovu',
        subtitle: 'Upomínky se opakují, dokud dávku nevezmete.',
        titleAccentWord: 'znovu',
      ),
      5: ScreenshotCopy(
        title: 'Pilulky i menstruace,\nvše na jednom místě',
        subtitle: 'Zaznamenejte menstruaci, další termín odhadneme sami.',
        titleAccentWord: 'vše na jednom místě',
      ),
    },
    'da': {
      1: ScreenshotCopy(
        title: '140.000+ brugere\nGlem aldrig din pille',
        subtitle: 'Påmindelse ved hver dosis. 4,6★ på App Store.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Vær aldrig i tvivl\nom du har taget den',
        subtitle: 'Din pilleplade genskabt på skærmen – se fremskridt med et blik.',
        titleAccentWord: 'aldrig i tvivl',
      ),
      3: ScreenshotCopy(
        title: 'Diskrete påmindelser,\ningen ser hvad det er',
        subtitle: 'Selv på låseskærmen forbliver det privat.',
        titleAccentWord: 'Diskrete påmindelser',
      ),
      4: ScreenshotCopy(
        title: 'Glemte du den?\nVi minder dig igen',
        subtitle: 'Påmindelser gentages, indtil du tager pillen.',
        titleAccentWord: 'igen',
      ),
      5: ScreenshotCopy(
        title: 'Pille og menstruation,\nsamlet ét sted',
        subtitle: 'Registrer din menstruation – næste dato forudsiges automatisk.',
        titleAccentWord: 'samlet ét sted',
      ),
    },
    'de': {
      1: ScreenshotCopy(
        title: '140.000+ Nutzerinnen\nvergessen nie wieder',
        subtitle: 'Erinnerung zu jeder Einnahmezeit. 4,6★ im App Store.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Nie mehr unsicher,\nob du sie genommen hast',
        subtitle: 'Dein Pillenblister, originalgetreu auf dem Bildschirm.',
        titleAccentWord: 'Nie mehr unsicher',
      ),
      3: ScreenshotCopy(
        title: 'Diskrete Erinnerungen,\nniemand merkt etwas',
        subtitle: 'Auch auf dem Sperrbildschirm bleibt es privat.',
        titleAccentWord: 'Diskrete Erinnerungen',
      ),
      4: ScreenshotCopy(
        title: 'Verpasst? Kein Problem.\nWir erinnern dich erneut',
        subtitle: 'Erinnerungen wiederholen sich, bis du sie nimmst.',
        titleAccentWord: 'erneut',
      ),
      5: ScreenshotCopy(
        title: 'Pille und Periode,\nalles in einer App',
        subtitle: 'Periode erfassen – nächster Termin automatisch vorhergesagt.',
        titleAccentWord: 'alles in einer App',
      ),
    },
    'el': {
      1: ScreenshotCopy(
        title: '140.000+ χρήστες\nμας εμπιστεύονται',
        subtitle: 'Υπενθύμιση σε κάθε ώρα λήψης. 4.6★ στο App Store.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Μην αγωνιάς\nαν το πήρες ήδη',
        subtitle: 'Η κάρτα χαπιών σου, στην οθόνη. Δες την πρόοδό σου με μια ματιά.',
        titleAccentWord: 'Μην αγωνιάς',
      ),
      3: ScreenshotCopy(
        title: 'Διακριτικές ειδοποιήσεις\nκανείς δεν καταλαβαίνει',
        subtitle: 'Ακόμα και στην οθόνη κλειδώματος, παραμένει ιδιωτικό.',
        titleAccentWord: 'Διακριτικές',
      ),
      4: ScreenshotCopy(
        title: 'Το ξέχασες;\nΘα σου το θυμίζουμε ξανά',
        subtitle: 'Οι υπενθυμίσεις επαναλαμβάνονται μέχρι να πάρεις το χάπι σου.',
        titleAccentWord: 'ξανά',
      ),
      5: ScreenshotCopy(
        title: 'Χάπι και περίοδος,\nόλα σε μία εφαρμογή',
        subtitle: 'Κατέγραψε την περίοδό σου και μάθε πότε θα έρθει η επόμενη.',
        titleAccentWord: 'όλα σε μία εφαρμογή',
      ),
    },
    'es': {
      1: ScreenshotCopy(
        title: '140K+ usuarias\nnunca olvidan su píldora',
        subtitle: 'Recordatorio en cada toma. 4.6★ en App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Nunca más te preguntes\nsi ya la tomaste',
        subtitle: 'Tu blíster de píldoras, en la pantalla.',
        titleAccentWord: 'Nunca más',
      ),
      3: ScreenshotCopy(
        title: 'Avisos discretos,\nnadie se entera',
        subtitle: 'Incluso en la pantalla de bloqueo, sigue siendo privado.',
        titleAccentWord: 'discretos',
      ),
      4: ScreenshotCopy(
        title: '¿Se te olvidó?\nTe avisamos otra vez',
        subtitle: 'El aviso se repite hasta que tomes tu píldora.',
        titleAccentWord: 'otra vez',
      ),
      5: ScreenshotCopy(
        title: 'Tu píldora y tu período,\ntodo en una app',
        subtitle: 'Registra tu período y te predecimos la próxima fecha.',
        titleAccentWord: 'todo en una app',
      ),
    },
    'fi': {
      1: ScreenshotCopy(
        title: 'Yli 140 000 käyttäjää\nei unohda pilleriä',
        subtitle: 'Muistutus jokaisella annosajalla. App Store ★4,6.',
        titleAccentWord: '140 000',
      ),
      2: ScreenshotCopy(
        title: 'Älä enää mieti,\notitko pillerin',
        subtitle: 'Pilleriliuska suoraan näytölläsi.',
        titleAccentWord: 'Älä enää mieti',
      ),
      3: ScreenshotCopy(
        title: 'Huomaamaton muistutus,\nkukaan ei arvaa syytä',
        subtitle: 'Jopa lukitusnäytöllä sisältö pysyy yksityisenä.',
        titleAccentWord: 'Huomaamaton muistutus',
      ),
      4: ScreenshotCopy(
        title: 'Unohditko pillerin?\nMuistutamme uudelleen',
        subtitle: 'Muistutukset toistuvat, kunnes otat pillerin.',
        titleAccentWord: 'uudelleen',
      ),
      5: ScreenshotCopy(
        title: 'Pillerit ja kuukautiset\nyhdessä paikassa',
        subtitle: 'Kirjaa kuukautiset, seuraava ennustetaan automaattisesti.',
        titleAccentWord: 'yhdessä paikassa',
      ),
    },
    'he': {
      1: ScreenshotCopy(
        title: '140,000+ משתמשות\nלא שוכחות לקחת גלולה',
        subtitle: 'תזכורת בכל שעת נטילה. דירוג 4.6★ ב-App Store.',
        titleAccentWord: '140,000+',
      ),
      2: ScreenshotCopy(
        title: 'תפסיקו לדאוג\nאם כבר לקחתן גלולה',
        subtitle: 'לוח הגלולות שלכן מוצג בדיוק על המסך.',
        titleAccentWord: 'תפסיקו לדאוג',
      ),
      3: ScreenshotCopy(
        title: 'תזכורות דיסקרטיות,\nבלי שאף אחד יבין למה',
        subtitle: 'גם במסך הנעילה, התוכן נשאר פרטי.',
        titleAccentWord: 'דיסקרטיות',
      ),
      4: ScreenshotCopy(
        title: 'שכחתן? זה בסדר.\nנזכיר לכן שוב ושוב',
        subtitle: 'התזכורות חוזרות עד לנטילת הגלולה.',
        titleAccentWord: 'שוב ושוב',
      ),
      5: ScreenshotCopy(
        title: 'גלולה ומחזור\nהכל באפליקציה אחת',
        subtitle: 'תעדו מחזור וקבלו תחזית אוטומטית לתאריך הבא.',
        titleAccentWord: 'אפליקציה אחת',
      ),
    },
    'hi': {
      1: ScreenshotCopy(
        title: '1.4 लाख+ का भरोसा\nकभी न छूटे गोली लेना',
        subtitle: 'हर खुराक के समय रिमाइंडर। App Store पर ★4.6 रेटिंग।',
        titleAccentWord: '1.4 लाख+',
      ),
      2: ScreenshotCopy(
        title: 'अब यह चिंता नहीं\nकि गोली ली या नहीं',
        subtitle: 'स्क्रीन पर आपकी गोली पैक। एक नज़र में प्रोग्रेस देखें।',
        titleAccentWord: 'चिंता नहीं',
      ),
      3: ScreenshotCopy(
        title: 'गोपनीय नोटिफिकेशन,\nकिसी को पता नहीं चलेगा',
        subtitle: 'लॉक स्क्रीन पर भी प्राइवेट रहता है।',
        titleAccentWord: 'गोपनीय',
      ),
      4: ScreenshotCopy(
        title: 'भूल गए? कोई बात नहीं।\nरिमाइंडर बार-बार आएगा',
        subtitle: 'गोली लेने तक रिमाइंडर आते रहेंगे।',
        titleAccentWord: 'बार-बार',
      ),
      5: ScreenshotCopy(
        title: 'गोली और पीरियड दोनों,\nबस एक ऐप में मैनेज करें',
        subtitle: 'पीरियड लॉग करें, अगली तारीख अपने आप पता चलेगी।',
        titleAccentWord: 'एक ऐप में',
      ),
    },
    'hr': {
      1: ScreenshotCopy(
        title: '140.000+ korisnika\nNe zaboravi tabletu',
        subtitle: 'Podsjetnik za svaku dozu. Ocjena 4,6★ na App Storeu.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Nikad se nećeš brinuti\njesi li popila tabletu',
        subtitle: 'Blister na ekranu. Vidi napredak jednim pogledom.',
        titleAccentWord: 'Nikad se nećeš brinuti',
      ),
      3: ScreenshotCopy(
        title: 'Diskretne obavijesti,\nnitko ne zna za što su',
        subtitle: 'Čak i na zaključanom ekranu ostaje privatno.',
        titleAccentWord: 'Diskretne',
      ),
      4: ScreenshotCopy(
        title: 'Zaboravila si?\nJavit ćemo ti ponovno',
        subtitle: 'Podsjeća te dok ne uzmeš tabletu.',
        titleAccentWord: 'ponovno',
      ),
      5: ScreenshotCopy(
        title: 'Tabletu i menstruaciju\nprati na jednom mjestu',
        subtitle: 'Bilježi menstruaciju, a sljedeći termin predviđamo automatski.',
        titleAccentWord: 'na jednom mjestu',
      ),
    },
    'hu': {
      1: ScreenshotCopy(
        title: '140 000+ felhasználó\nSosem felejti a tablettát',
        subtitle: 'Emlékeztető minden szedési időpontban. 4,6★ az App Store-on.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Soha többé ne aggódj\nhogy bevetted-e',
        subtitle: 'A tablettacsíkod a képernyőn. Láss mindent egy pillantással.',
        titleAccentWord: 'ne aggódj',
      ),
      3: ScreenshotCopy(
        title: 'Diszkrét emlékeztetők,\nsenki sem veszi észre',
        subtitle: 'Még a zárolt képernyőn is titokban marad.',
        titleAccentWord: 'Diszkrét',
      ),
      4: ScreenshotCopy(
        title: 'Kihagytad?\nÚjra és újra emlékeztetünk',
        subtitle: 'A bevételig folyamatosan emlékeztetünk.',
        titleAccentWord: 'Újra és újra',
      ),
      5: ScreenshotCopy(
        title: 'Tabletta és menstruáció,\nmind egy helyen',
        subtitle: 'Rögzítsd a menstruációt, mi megjósoljuk a következőt.',
        titleAccentWord: 'mind egy helyen',
      ),
    },
    'id': {
      1: ScreenshotCopy(
        title: 'Dipercaya 140K+ Pengguna\nAnti Lupa Minum Pil',
        subtitle: 'Pengingat di setiap jadwal minum. Rating ★4.6 di App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Tenang, Tak Perlu Cemas\nSudah Minum atau Belum',
        subtitle: 'Kemasan pil kamu, tampil persis di layar.',
        titleAccentWord: 'Tak Perlu Cemas',
      ),
      3: ScreenshotCopy(
        title: 'Notifikasi Rahasia,\nTak Ada yang Tahu',
        subtitle: 'Muncul di layar kunci, tapi isinya tetap rahasia.',
        titleAccentWord: 'Notifikasi Rahasia',
      ),
      4: ScreenshotCopy(
        title: 'Lupa Minum? Tenang Saja\nKami Ingatkan Lagi',
        subtitle: 'Pengingat berulang sampai kamu minum pil.',
        titleAccentWord: 'Lagi',
      ),
      5: ScreenshotCopy(
        title: 'Pil dan Haid Kamu\ndalam Satu Aplikasi',
        subtitle: 'Catat haidmu, tanggal berikutnya diprediksi otomatis.',
        titleAccentWord: 'Satu Aplikasi',
      ),
    },
    'it': {
      1: ScreenshotCopy(
        title: '140.000+ ci scelgono\nNon dimenticarla mai più',
        subtitle: 'Un promemoria a ogni dose. 4,6★ su App Store.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Mai più dubbi\nse l\'hai già presa',
        subtitle: 'Il blister ricreato fedelmente sullo schermo.',
        titleAccentWord: 'Mai più dubbi',
      ),
      3: ScreenshotCopy(
        title: 'Notifiche discrete,\nnessuno se ne accorge',
        subtitle: 'Anche sulla schermata di blocco, resta privato.',
        titleAccentWord: 'discrete',
      ),
      4: ScreenshotCopy(
        title: 'L\'hai dimenticata?\nTe la ricordiamo ancora',
        subtitle: 'Ti avvisiamo più volte, finché non la prendi.',
        titleAccentWord: 'ancora',
      ),
      5: ScreenshotCopy(
        title: 'Pillola e ciclo,\ntutto in un\'app sola',
        subtitle: 'Registra il ciclo e prevediamo la prossima data.',
        titleAccentWord: 'tutto in un\'app sola',
      ),
    },
    'ko': {
      1: ScreenshotCopy(
        title: '14만 명이 사용하는\n복용 알림 앱',
        subtitle: '매일 복용 시간에 알림. App Store ★4.6의 신뢰.',
        titleAccentWord: '14만 명',
      ),
      2: ScreenshotCopy(
        title: '이제 먹었는지\n불안해하지 않아요',
        subtitle: '필 시트를 화면에 그대로 재현.',
        titleAccentWord: '불안해하지 않아요',
      ),
      3: ScreenshotCopy(
        title: '숨긴 알림이라\n아무도 눈치 못 채요',
        subtitle: '잠금 화면에 떠도 내용은 알 수 없어요.',
        titleAccentWord: '숨긴 알림',
      ),
      4: ScreenshotCopy(
        title: '깜빡해도 괜찮아요.\n알림이 계속 와요',
        subtitle: '복용할 때까지 반복해서 알려드려요.',
        titleAccentWord: '계속',
      ),
      5: ScreenshotCopy(
        title: '피임약도 생리도\n이 앱 하나로 관리',
        subtitle: '생리를 기록하면 다음 일정을 자동으로 예측해요.',
        titleAccentWord: '이 앱 하나로',
      ),
    },
    'ms': {
      1: ScreenshotCopy(
        title: '140K+ pengguna percaya\nJangan lupa minum pil',
        subtitle: 'Peringatan setiap waktu minum ubat. Dinilai 4.6★ di App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Tak perlu risau sama ada\nanda dah minum pil',
        subtitle: 'Helaian pil dipaparkan terus pada skrin.',
        titleAccentWord: 'Tak perlu risau',
      ),
      3: ScreenshotCopy(
        title: 'Peringatan sulit,\ntiada siapa perasan',
        subtitle: 'Walaupun pada skrin kunci, isinya kekal peribadi.',
        titleAccentWord: 'Peringatan sulit',
      ),
      4: ScreenshotCopy(
        title: 'Terlepas masa?\nKami ingatkan lagi',
        subtitle: 'Peringatan berulang sehingga anda minum pil.',
        titleAccentWord: 'lagi',
      ),
      5: ScreenshotCopy(
        title: 'Pil dan haid anda,\nsemua dalam satu apl',
        subtitle: 'Rekod haid anda, tarikh seterusnya diramal automatik.',
        titleAccentWord: 'semua dalam satu',
      ),
    },
    'nl': {
      1: ScreenshotCopy(
        title: '140K+ gebruikers\nvertrouwen op Pilll',
        subtitle: 'Herinnering bij elke innametijd. 4,6★ in de App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Nooit meer twijfelen\nof je al hebt geslikt',
        subtitle: 'Je pilstrip op het scherm. Zie in één oogopslag je voortgang.',
        titleAccentWord: 'Nooit meer twijfelen',
      ),
      3: ScreenshotCopy(
        title: 'Discrete meldingen,\nniemand ziet waarvoor',
        subtitle: 'Zelfs op het vergrendelscherm blijft het privé.',
        titleAccentWord: 'Discrete meldingen',
      ),
      4: ScreenshotCopy(
        title: 'Toch vergeten?\nWe herinneren je weer',
        subtitle: 'Herinneringen herhalen zich totdat je je pil hebt ingenomen.',
        titleAccentWord: 'weer',
      ),
      5: ScreenshotCopy(
        title: 'Je pil en menstruatie,\nalles in één app',
        subtitle: 'Registreer je menstruatie, de volgende datum wordt automatisch voorspeld.',
        titleAccentWord: 'in één app',
      ),
    },
    'no': {
      1: ScreenshotCopy(
        title: 'Brukt av 140K+\nGlem aldri pillen',
        subtitle: 'Påminnelse ved hver dose. 4,6★ på App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Aldri i tvil om\ndu har tatt pillen',
        subtitle: 'Pilleplaten din vises rett på skjermen.',
        titleAccentWord: 'Aldri i tvil',
      ),
      3: ScreenshotCopy(
        title: 'Diskrete varsler,\ningen ser innholdet',
        subtitle: 'Selv på låseskjermen forblir det privat.',
        titleAccentWord: 'Diskrete varsler',
      ),
      4: ScreenshotCopy(
        title: 'Glemte du den?\nVi minner deg igjen',
        subtitle: 'Påminnelser gjentas til du tar pillen.',
        titleAccentWord: 'igjen',
      ),
      5: ScreenshotCopy(
        title: 'Pillen og mensen,\nalt på ett sted',
        subtitle: 'Registrer mensen, og neste dato beregnes automatisk.',
        titleAccentWord: 'alt på ett sted',
      ),
    },
    'pl': {
      1: ScreenshotCopy(
        title: '140 tys. użytkowników\nNie zapomnisz tabletki',
        subtitle: 'Przypomnienie o każdej porze przyjęcia. 4,6★ w App Store.',
        titleAccentWord: '140 tys.',
      ),
      2: ScreenshotCopy(
        title: 'Nie zastanawiaj się już,\nczy wzięłaś tabletkę',
        subtitle: 'Blister tabletek dokładnie odwzorowany na ekranie.',
        titleAccentWord: 'Nie zastanawiaj się',
      ),
      3: ScreenshotCopy(
        title: 'Dyskretne przypomnienia,\nnikt się nie domyśli',
        subtitle: 'Nawet na ekranie blokady treść pozostaje prywatna.',
        titleAccentWord: 'Dyskretne przypomnienia',
      ),
      4: ScreenshotCopy(
        title: 'Zapomniałaś?\nPrzypomnimy Ci ponownie',
        subtitle: 'Przypomnienia powtarzają się, aż weźmiesz tabletkę.',
        titleAccentWord: 'ponownie',
      ),
      5: ScreenshotCopy(
        title: 'Tabletki i okres\nw jednej aplikacji',
        subtitle: 'Zapisz swój okres, a kolejny termin przewidzimy automatycznie.',
        titleAccentWord: 'w jednej aplikacji',
      ),
    },
    'pt': {
      1: ScreenshotCopy(
        title: 'Mais de 140 mil usuárias\nnunca esquecem a pílula',
        subtitle: 'Notificação em cada horário. Nota 4,6★ na App Store.',
        titleAccentWord: '140 mil',
      ),
      2: ScreenshotCopy(
        title: 'Chega de dúvida\nse já tomou a pílula',
        subtitle: 'Sua cartela de pílulas, recriada na tela.',
        titleAccentWord: 'Chega de dúvida',
      ),
      3: ScreenshotCopy(
        title: 'Notificação discreta,\nninguém desconfia',
        subtitle: 'Mesmo na tela de bloqueio, o conteúdo não aparece.',
        titleAccentWord: 'Notificação discreta',
      ),
      4: ScreenshotCopy(
        title: 'Esqueceu? Sem problema.\nAvisamos várias vezes',
        subtitle: 'Repetimos o aviso até você tomar a pílula.',
        titleAccentWord: 'várias vezes',
      ),
      5: ScreenshotCopy(
        title: 'Pílula e menstruação,\ntudo em um só app',
        subtitle: 'Registre sua menstruação e preveja a próxima data.',
        titleAccentWord: 'tudo em um só app',
      ),
    },
    'ro': {
      1: ScreenshotCopy(
        title: '140K+ utilizatoare\nnu uită pastila',
        subtitle: 'Notificare la fiecare doză. Rating 4,6★ pe App Store.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Nu te mai întreba\ndacă ai luat pastila',
        subtitle: 'Vezi blisterul de pastile direct pe ecran.',
        titleAccentWord: 'Nu te mai întreba',
      ),
      3: ScreenshotCopy(
        title: 'Notificări discrete,\nnimeni nu bănuiește',
        subtitle: 'Chiar și pe ecranul de blocare, rămâne privat.',
        titleAccentWord: 'discrete',
      ),
      4: ScreenshotCopy(
        title: 'Ai uitat o doză?\nÎți reamintim din nou',
        subtitle: 'Notificările se repetă până iei pastila.',
        titleAccentWord: 'din nou',
      ),
      5: ScreenshotCopy(
        title: 'Pastila și ciclul,\ntotul într-un loc',
        subtitle: 'Notează ciclul, iar următoarea dată e prezisă automat.',
        titleAccentWord: 'totul într-un loc',
      ),
    },
    'ru': {
      1: ScreenshotCopy(
        title: '140 000+ пользователей\nуже не пропускают приём',
        subtitle: 'Напоминание точно в момент приёма. Рейтинг 4.6★ в App Store.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Никогда не сомневайтесь\nприняли ли вы таблетку',
        subtitle: 'Блистер с таблетками — точно как в жизни, на экране.',
        titleAccentWord: 'не сомневайтесь',
      ),
      3: ScreenshotCopy(
        title: 'Скрытые уведомления —\nникто не догадается',
        subtitle: 'Даже на экране блокировки никто ничего не узнает.',
        titleAccentWord: 'Скрытые уведомления',
      ),
      4: ScreenshotCopy(
        title: 'Забыли выпить?\nНапомним снова и снова',
        subtitle: 'Напоминания повторяются, пока вы не примете таблетку.',
        titleAccentWord: 'снова и снова',
      ),
      5: ScreenshotCopy(
        title: 'Таблетки и цикл —\nвсё в одном приложении',
        subtitle: 'Запишите цикл — и мы предскажем следующую дату.',
        titleAccentWord: 'всё в одном',
      ),
    },
    'sk': {
      1: ScreenshotCopy(
        title: '140 000+ ľudí\nnikdy nezabudnú',
        subtitle: 'Pripomienka pri každom užití. Hodnotenie 4,6★ na App Store.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Nikdy sa netráp,\nči si ju vzala',
        subtitle: 'Presná kópia tvojho blistra na obrazovke.',
        titleAccentWord: 'Nikdy sa netráp',
      ),
      3: ScreenshotCopy(
        title: 'Diskrétne upozornenia,\nnikto nič netuší',
        subtitle: 'Aj na zamknutej obrazovke zostáva súkromné.',
        titleAccentWord: 'Diskrétne',
      ),
      4: ScreenshotCopy(
        title: 'Zabudla si?\nPripomenieme ti znova',
        subtitle: 'Pripomienky sa opakujú, kým si tabletku nevezmeš.',
        titleAccentWord: 'znova',
      ),
      5: ScreenshotCopy(
        title: 'Pilulky aj menštruácia\nvšetko na jednom mieste',
        subtitle: 'Zaznamenaj menštruáciu, ďalší termín predpovieme automaticky.',
        titleAccentWord: 'na jednom mieste',
      ),
    },
    'sv': {
      1: ScreenshotCopy(
        title: '140 000+ litar på oss\nMissa aldrig en tablett',
        subtitle: 'En påminnelse varje dag. 4.6★ på App Store.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Undra aldrig\nom du redan tagit den',
        subtitle: 'Din p-pillerkarta, direkt på skärmen.',
        titleAccentWord: 'Undra aldrig',
      ),
      3: ScreenshotCopy(
        title: 'Diskreta påminnelser,\ningen anar vad det är',
        subtitle: 'Även på låsskärmen förblir det privat.',
        titleAccentWord: 'Diskreta',
      ),
      4: ScreenshotCopy(
        title: 'Missade du den?\nVi påminner dig igen',
        subtitle: 'Påminnelser upprepas tills du tar pillret.',
        titleAccentWord: 'igen',
      ),
      5: ScreenshotCopy(
        title: 'P-piller och mens,\nallt på ett ställe',
        subtitle: 'Logga mensen, så förutspår vi nästa datum.',
        titleAccentWord: 'allt på ett ställe',
      ),
    },
    'th': {
      1: ScreenshotCopy(
        title: 'ผู้ใช้กว่า 140,000+ คน\nแอปเตือนกินยาคุม',
        subtitle: 'แจ้งเตือนตรงเวลาทุกวัน มั่นใจด้วยคะแนน 4.6★ บน App Store',
        titleAccentWord: '140,000+',
      ),
      2: ScreenshotCopy(
        title: 'หมดกังวลว่า\nกินยาไปหรือยัง',
        subtitle: 'จำลองแผงยาคุมได้เหมือนจริงบนหน้าจอ',
        titleAccentWord: 'หมดกังวล',
      ),
      3: ScreenshotCopy(
        title: 'แจ้งเตือนแบบส่วนตัว\nไม่มีใครล่วงรู้',
        subtitle: 'แม้ขึ้นหน้าจอล็อก ก็ไม่มีใครรู้เนื้อหาข้างใน',
        titleAccentWord: 'แบบส่วนตัว',
      ),
      4: ScreenshotCopy(
        title: 'ลืมกินยาก็ไม่เป็นไร\nแจ้งเตือนซ้ำได้หลายครั้ง',
        subtitle: 'เตือนซ้ำไปเรื่อยๆ จนกว่าคุณจะกินยา',
        titleAccentWord: 'หลายครั้ง',
      ),
      5: ScreenshotCopy(
        title: 'ยาคุมและประจำเดือน\nจัดการได้ในแอปเดียว',
        subtitle: 'บันทึกประจำเดือน แล้วแอปจะคาดการณ์รอบถัดไปให้อัตโนมัติ',
        titleAccentWord: 'แอปเดียว',
      ),
    },
    'tr': {
      1: ScreenshotCopy(
        title: '140K+ kişinin tercihi\nHapını asla unutma',
        subtitle: 'Her hap saatinde hatırlatma. App Store\'da 4,6 yıldız.',
        titleAccentWord: '140K+',
      ),
      2: ScreenshotCopy(
        title: 'Aldın mı diye\nartık endişelenme',
        subtitle: 'Hap şeridini olduğu gibi ekranında gör.',
        titleAccentWord: 'endişelenme',
      ),
      3: ScreenshotCopy(
        title: 'Gizli bildirimler,\nkimse fark etmez',
        subtitle: 'Kilit ekranında görünse bile içeriği gizli kalır.',
        titleAccentWord: 'Gizli bildirimler',
      ),
      4: ScreenshotCopy(
        title: 'Unutsan da sorun yok,\ntekrar tekrar hatırlatır',
        subtitle: 'Hapını alana kadar durmadan hatırlatırız.',
        titleAccentWord: 'tekrar tekrar',
      ),
      5: ScreenshotCopy(
        title: 'Hap ve regl takibi,\nhepsi tek uygulamada',
        subtitle: 'Regl döngünü kaydet, sıradaki tarih otomatik tahmin edilir.',
        titleAccentWord: 'hepsi tek uygulamada',
      ),
    },
    'uk': {
      1: ScreenshotCopy(
        title: '140 000+ користувачів\nне забувають пігулку',
        subtitle: 'Нагадування щоразу в час прийому. Рейтинг 4,6★ в App Store.',
        titleAccentWord: '140 000+',
      ),
      2: ScreenshotCopy(
        title: 'Більше не хвилюйтеся,\nчи прийняли таблетку',
        subtitle: 'Ваш блістер таблеток — просто на екрані.',
        titleAccentWord: 'не хвилюйтеся',
      ),
      3: ScreenshotCopy(
        title: 'Непомітні нагадування,\nніхто не здогадається',
        subtitle: 'На екрані блокування вміст залишається прихованим.',
        titleAccentWord: 'Непомітні нагадування',
      ),
      4: ScreenshotCopy(
        title: 'Забули випити?\nМи нагадаємо знову',
        subtitle: 'Нагадування повторюються, доки ви не приймете пігулку.',
        titleAccentWord: 'знову',
      ),
      5: ScreenshotCopy(
        title: 'Пігулки й місячні —\nусе в одному місці',
        subtitle: 'Занотуйте місячні — додаток передбачить наступну дату.',
        titleAccentWord: 'усе в одному',
      ),
    },
    'vi': {
      1: ScreenshotCopy(
        title: '140.000+ người tin dùng\nỨng dụng nhắc uống thuốc',
        subtitle: 'Nhắc đúng giờ mỗi ngày. 4,6★ trên App Store.',
        titleAccentWord: '140.000+',
      ),
      2: ScreenshotCopy(
        title: 'Không còn lo lắng\nđã uống thuốc chưa',
        subtitle: 'Vỉ thuốc được tái hiện y hệt trên màn hình.',
        titleAccentWord: 'Không còn lo lắng',
      ),
      3: ScreenshotCopy(
        title: 'Thông báo kín đáo,\nkhông ai biết được',
        subtitle: 'Trên màn hình khóa vẫn giữ kín riêng tư.',
        titleAccentWord: 'Thông báo kín đáo',
      ),
      4: ScreenshotCopy(
        title: 'Quên uống cũng không sao\nNhắc lại nhiều lần',
        subtitle: 'Thông báo lặp lại đến khi bạn uống thuốc.',
        titleAccentWord: 'nhiều lần',
      ),
      5: ScreenshotCopy(
        title: 'Thuốc và kỳ kinh nguyệt\nchỉ trong một ứng dụng',
        subtitle: 'Ghi lại kỳ kinh, ứng dụng tự dự đoán ngày tiếp theo.',
        titleAccentWord: 'một ứng dụng',
      ),
    },
    'zh': {
      1: ScreenshotCopy(
        title: '14万人的选择\n防止忘记吃药',
        subtitle: '每日服药时间提醒，App Store评分4.6★。',
        titleAccentWord: '14万人',
      ),
      2: ScreenshotCopy(
        title: '再也不用担心\n是否已经吃药',
        subtitle: '药板原样呈现在屏幕上，进度一目了然。',
        titleAccentWord: '不用担心',
      ),
      3: ScreenshotCopy(
        title: '悄悄提醒，\n没人看得出内容',
        subtitle: '即使出现在锁屏，也看不出内容。',
        titleAccentWord: '悄悄提醒',
      ),
      4: ScreenshotCopy(
        title: '忘记吃药也没关系，\n通知会反复提醒你',
        subtitle: '直到你服药为止，会反复提醒。',
        titleAccentWord: '反复',
      ),
      5: ScreenshotCopy(
        title: '服药与生理，\n一个App全搞定',
        subtitle: '记录生理周期，自动预测下次日期。',
        titleAccentWord: '一个App',
      ),
    },
  };
}
